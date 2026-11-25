import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/portfolio_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _techStackController = TextEditingController();
  final TextEditingController _projectUrlController = TextEditingController();
  final TextEditingController _projectImageUrlController =
      TextEditingController();
  bool _isSubmitting = false;

  String? _requiredTextValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  String? _urlValidator(String? value, {required bool optional}) {
    final url = value?.trim() ?? '';
    if (optional && url.isEmpty) return null;
    if (url.isEmpty) return 'Project URL is required.';

    final uri = Uri.tryParse(url);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return 'Enter a valid http or https URL.';
    }
    return null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final authState = context.read<AuthState>();
    final token = authState.token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final project = Project(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        techStack: _techStackController.text.trim(),
        projectUrl: _projectUrlController.text.trim(),
        projectImageUrl: _projectImageUrlController.text.trim(),
      );
      final createdProject = await context.read<ApiClient>().createProject(
        project,
        token: token,
      );
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Project added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow('Title', createdProject.title),
                _summaryRow('Description', createdProject.description),
                _summaryRow('Tech Stack', createdProject.techStack),
                _summaryRow('Project URL', createdProject.projectUrl),
                _summaryRow(
                  'Project Image URL',
                  createdProject.projectImageUrl.isEmpty
                      ? '—'
                      : createdProject.projectImageUrl,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (mounted) _resetForm();
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        await _handleExpiredSession(authState);
      } else if (error.statusCode == null) {
        _showError('Could not connect to the API server. Check the API URL.');
      } else {
        _showError('Could not save project (HTTP ${error.statusCode}).');
      }
    } on FormatException {
      if (mounted) _showError('The API returned an invalid project response.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _handleExpiredSession(AuthState authState) async {
    String? logoutFailure;
    try {
      await authState.logout();
    } on ApiException catch (error) {
      logoutFailure = error.statusCode == null
          ? ' The server could not revoke the expired token.'
          : ' Token revocation failed (HTTP ${error.statusCode}).';
    }

    if (!mounted) return;
    _showError('Session expired. Please log in again.$logoutFailure');
    await ensureLoggedIn(context);
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: $value'),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _techStackController.clear();
    _projectUrlController.clear();
    _projectImageUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const PortfolioDrawer(currentPage: 'add_project'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Project Details',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('project-title-field'),
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) => _requiredTextValidator(value, 'Title'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('project-description-field'),
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredTextValidator(value, 'Description'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('project-tech-stack-field'),
                  controller: _techStackController,
                  decoration: const InputDecoration(
                    labelText: 'Tech Stack',
                    hintText: 'Example: Flutter, Django, Figma',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _requiredTextValidator(value, 'Tech Stack'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('project-url-field'),
                  controller: _projectUrlController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Project URL',
                    hintText: 'https://example.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _urlValidator(value, optional: false),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('project-image-url-field'),
                  controller: _projectImageUrlController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Project Image URL (optional)',
                    hintText: 'https://example.com/image.png',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _urlValidator(value, optional: true),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _saveProject,
                  icon: const Icon(Icons.save),
                  label: _isSubmitting
                      ? const Text('Saving...')
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _projectUrlController.dispose();
    _projectImageUrlController.dispose();
    super.dispose();
  }
}
