import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:myportofolio_mobile/widgets/portfolio_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickDate(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final institution = _institutionController.text.trim();
      final degree = _degreeController.text.trim();
      final field = _fieldController.text.trim();
      final startDate = _startDateController.text.trim();
      final endDate = _endDateController.text.trim();
      final description = _descriptionController.text.trim();

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Education Summary'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryRow('Institution', institution),
                  _summaryRow('Degree', degree),
                  _summaryRow('Field of Study', field),
                  _summaryRow('Start Date', startDate),
                  _summaryRow('End Date', endDate),
                  _summaryRow(
                    'Description',
                    description.isEmpty ? '—' : description,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Education',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const PortfolioDrawer(currentPage: 'add_education'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Education Details',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('institution-field'),
                    controller: _institutionController,
                    decoration: const InputDecoration(
                      labelText: 'Institution',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Institution is required.';
                      }
                      if (value.trim().length > 100) {
                        return 'Institution name cannot exceed 100 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('degree-field'),
                    controller: _degreeController,
                    decoration: const InputDecoration(
                      labelText: 'Degree',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Degree is required.';
                      }
                      if (value.trim().length > 80) {
                        return 'Degree cannot exceed 80 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('field-of-study-field'),
                    controller: _fieldController,
                    decoration: const InputDecoration(
                      labelText: 'Field of Study',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Field of study is required.';
                      }
                      if (value.trim().length > 80) {
                        return 'Field of study cannot exceed 80 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('start-date-field'),
                    controller: _startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _pickDate(_startDateController),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Start date is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('end-date-field'),
                    controller: _endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                    ),
                    onTap: () => _pickDate(_endDateController),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'End date is required.';
                      }

                      final startDate = DateTime.tryParse(
                        _startDateController.text,
                      );
                      final endDate = DateTime.tryParse(value);

                      if (startDate == null || endDate == null) {
                        return 'Please select valid dates.';
                      }

                      if (endDate.isBefore(startDate)) {
                        return 'End date cannot be earlier than start date.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
