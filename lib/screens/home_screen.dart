import 'package:flutter/material.dart';
import '../models/calculation_model.dart';
import '../services/calculation_service.dart';
import '../widgets/calculation_form.dart';
import '../widgets/calculation_result.dart';
import '../widgets/calculation_type_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalculationType _calculationType = CalculationType.monthlySalary;
  final CalculationService _calculationService = CalculationService();
  CalculationResult? _result;
  bool _showResult = false;

  void _onCalculationTypeChanged(CalculationType type) {
    setState(() {
      _calculationType = type;
      _showResult = false;
      _result = null;
    });
  }

  void _calculateResult(CalculationInput input) {
    final result = _calculationService.calculate(input);
    setState(() {
      _result = result;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'حسبه',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // تحديد اتجاه النص من اليمين لليسار
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // نص الإهداء
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'اهداء إلى اخواني الغالين، احسب على السريع',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ),
                // نوع الحسبة
                CalculationTypeSelector(
                  selectedType: _calculationType,
                  onTypeChanged: _onCalculationTypeChanged,
                ),

                const SizedBox(height: 24),

                // نموذج الحسبة
                CalculationForm(
                  calculationType: _calculationType,
                  onCalculate: _calculateResult,
                ),

                // نتيجة الحسبة إذا كانت متاحة
                if (_showResult && _result != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: CalculationResultWidget(result: _result!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
