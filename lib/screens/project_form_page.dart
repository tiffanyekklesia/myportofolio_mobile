import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/portfolio_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _technologiesController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  String _category = _categories.first;

  void _saveProject() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final projectName = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final technologies = _technologiesController.text.trim();
    final projectLink = _linkController.text.trim();
    final category = _category;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Project added successfully!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('Project Name', projectName),
              _summaryRow('Description', description),
              _summaryRow('Category', category),
              _summaryRow(
                'Technologies',
                technologies.isEmpty ? '—' : technologies,
              ),
              _summaryRow('Link', projectLink.isEmpty ? '—' : projectLink),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: $value'),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _descriptionController.clear();
    _technologiesController.clear();
    _linkController.clear();
    setState(() {
      _category = _categories.first;
    });
  }

  String? _requiredTextValidator(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  String? _projectLinkValidator(String? value) {
    final link = value?.trim() ?? '';
    if (link.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(link);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return 'Enter a valid http or https URL.';
    }
    return null;
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
                  key: const Key('project-name-field'),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    hintText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      _requiredTextValidator(value, 'Enter a project name.'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('project-description-field'),
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Project Description',
                    hintText: 'Describe your project',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _requiredTextValidator(
                    value,
                    'Enter a project description.',
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: const Key('project-category-field'),
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Project Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newCategory) {
                    if (newCategory != null) {
                      setState(() {
                        _category = newCategory;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('project-technologies-field'),
                  controller: _technologiesController,
                  decoration: const InputDecoration(
                    labelText: 'Technologies Used (optional)',
                    hintText: 'Example: Flutter, Django, Figma',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('project-link-field'),
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Project Link (optional)',
                    hintText: 'https://example.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: _projectLinkValidator,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saveProject,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
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
    _nameController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _linkController.dispose();
    super.dispose();
  }
}
