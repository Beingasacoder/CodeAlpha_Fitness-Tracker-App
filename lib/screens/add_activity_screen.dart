import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/fitness_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/activity_tile.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  ActivityType _selectedType = ActivityType.walking;
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _stepsController = TextEditingController();
  final _noteController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: _selectedTime);
    if (time != null) setState(() => _selectedTime = time);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    context.read<FitnessProvider>().addActivity(
          type: _selectedType,
          durationMinutes: int.parse(_durationController.text),
          caloriesBurned: int.parse(_caloriesController.text),
          steps: _stepsController.text.isEmpty ? 0 : int.parse(_stepsController.text),
          dateTime: dateTime,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Activity')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const Text('Activity type', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ActivityType.values.map((type) {
                final selected = type == _selectedType;
                return ChoiceChip(
                  label: Text(type.label),
                  avatar: Icon(
                    iconForActivity(type),
                    size: 18,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary),
                  onSelected: (_) => setState(() => _selectedType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            _buildLabel('Duration (minutes)'),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'e.g. 30'),
              validator: (v) => _validatePositiveInt(v, 'duration'),
            ),
            const SizedBox(height: 16),

            _buildLabel('Calories burned'),
            TextFormField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'e.g. 250'),
              validator: (v) => _validatePositiveInt(v, 'calories'),
            ),
            const SizedBox(height: 16),

            _buildLabel('Steps (optional)'),
            TextFormField(
              controller: _stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'e.g. 3000'),
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                if (int.tryParse(v) == null || int.parse(v) < 0) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('Time'),
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(_selectedTime.format(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildLabel('Note (optional)'),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'e.g. Morning run around the park'),
            ),
            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save activity'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  String? _validatePositiveInt(String? v, String fieldName) {
    if (v == null || v.isEmpty) return 'Enter $fieldName';
    final n = int.tryParse(v);
    if (n == null || n <= 0) return 'Enter a valid $fieldName';
    return null;
  }
}
