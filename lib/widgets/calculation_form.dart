import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/calculation_model.dart';

class CalculationForm extends StatefulWidget {
  final CalculationType calculationType;
  final Function(CalculationInput) onCalculate;

  const CalculationForm({
    super.key,
    required this.calculationType,
    required this.onCalculate,
  });

  @override
  State<CalculationForm> createState() => _CalculationFormState();
}

class _CalculationFormState extends State<CalculationForm> {
  final _formKey = GlobalKey<FormState>();
  final _initialAmountController = TextEditingController();

  // حقول خاصة بنوع "راتب شهري"
  final _requiredMonthlyIncomeController = TextEditingController();
  final _yearsToRetirementController = TextEditingController();

  // حقول خاصة بنوع "هدف مالي"
  final _monthlySavingsAmountController = TextEditingController();
  final _savingYearsController = TextEditingController();
  final _annualProfitRateController = TextEditingController();

  @override
  void dispose() {
    _initialAmountController.dispose();
    _requiredMonthlyIncomeController.dispose();
    _yearsToRetirementController.dispose();
    _monthlySavingsAmountController.dispose();
    _savingYearsController.dispose();
    _annualProfitRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بيانات الحساب',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),

          // حقل المبلغ المبدئي (مشترك)
          _buildTextField(
            controller: _initialAmountController,
            labelText: 'المبلغ المبدئي',
            hintText: 'مثال: 5000',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            isOptional: true,
            validator: (val) => val != null && val.isNotEmpty ? _validateNumber(val) : null,
            formatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),

          const SizedBox(height: 16),

          // الحقول الخاصة بنوع الحسبة
          if (widget.calculationType == CalculationType.monthlySalary) ...[
            // حقول خاصة بنوع "راتب شهري"
            _buildTextField(
              controller: _requiredMonthlyIncomeController,
              labelText: 'الدخل الشهري المطلوب',
              hintText: 'مثال: 2000',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateNumber,
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _yearsToRetirementController,
              labelText: 'عدد السنوات حتى التقاعد',
              hintText: 'مثال: 20',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              validator: _validateNumber,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ] else if (widget.calculationType == CalculationType.financialGoal) ...[
            // حقول خاصة بنوع "هدف مالي"
            _buildTextField(
              controller: _monthlySavingsAmountController,
              labelText: 'المبلغ الشهري المدخر',
              hintText: 'مثال: 500',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateNumber,
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),

            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _savingYearsController,
              labelText: 'عدد سنوات الادخار',
              hintText: 'مثال: 10',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              validator: _validateNumber,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),

            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _annualProfitRateController,
              labelText: 'نسبة الربح السنوية %',
              hintText: 'مثال: 5',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateNumber,
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ],

          const SizedBox(height: 16),

          const SizedBox(height: 32),

          // زر الحساب
          Center(
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('احسب'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required TextInputType keyboardType,
    bool isOptional = false,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixText: labelText.contains('%')
            ? '%'
            : (labelText.contains('مبلغ') || labelText.contains('الدخل')
                  ? 'د.ك'
                  : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
      ),
      validator: isOptional ? null : (validator ?? _validateRequired),
      inputFormatters: formatters,
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'يجب إدخال رقم صحيح';
    }

    if (number <= 0) {
      return 'يجب إدخال رقم أكبر من صفر';
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final initialAmount = _initialAmountController.text.isNotEmpty
          ? double.parse(_initialAmountController.text)
          : null;

      CalculationInput input;

      if (widget.calculationType == CalculationType.monthlySalary) {
        input = CalculationInput.forMonthlySalary(
          requiredMonthlyIncome: double.parse(
            _requiredMonthlyIncomeController.text,
          ),
          yearsToRetirement: int.parse(
            _yearsToRetirementController.text,
          ),
          initialAmount: initialAmount,
        );
      } else {
        input = CalculationInput.forFinancialGoal(
          monthlySavingsAmount: double.parse(_monthlySavingsAmountController.text),
          savingYears: int.parse(_savingYearsController.text),
          annualProfitRate: double.parse(_annualProfitRateController.text),
          initialAmount: initialAmount,
        );
      }

      widget.onCalculate(input);
    }
  }
}
