import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class GoalSettingsScreen extends StatefulWidget {
  const GoalSettingsScreen({super.key});

  @override
  State<GoalSettingsScreen> createState() => _GoalSettingsScreenState();
}

class _GoalSettingsScreenState extends State<GoalSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _stepsCtrl;
  late final TextEditingController _caloriesCtrl;
  late final TextEditingController _minutesCtrl;

  @override
  void initState() {
    super.initState();
    final goal = context.read<FitnessProvider>().goal;
    _stepsCtrl = TextEditingController(text: goal.stepsGoal.toString());
    _caloriesCtrl = TextEditingController(text: goal.caloriesGoal.toString());
    _minutesCtrl = TextEditingController(text: goal.activeMinutesGoal.toString());
  }

  @override
  void dispose() {
    _stepsCtrl.dispose();
    _caloriesCtrl.dispose();
    _minutesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<FitnessProvider>();
    provider.updateGoal(provider.goal.copyWith(
      stepsGoal: int.parse(_stepsCtrl.text),
      caloriesGoal: int.parse(_caloriesCtrl.text),
      activeMinutesGoal: int.parse(_minutesCtrl.text),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Goals')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field('Daily steps goal', _stepsCtrl),
            const SizedBox(height: 16),
            _field('Daily calories goal (kcal)', _caloriesCtrl),
            const SizedBox(height: 16),
            _field('Daily active minutes goal', _minutesCtrl),
            const SizedBox(height: 28),
            ElevatedButton(onPressed: _save, child: const Text('Save goals')),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Required';
            final n = int.tryParse(v);
            if (n == null || n <= 0) return 'Enter a valid number';
            return null;
          },
        ),
      ],
    );
  }
}
