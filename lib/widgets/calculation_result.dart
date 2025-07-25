import 'package:flutter/material.dart';
import '../models/calculation_model.dart';
// استيراد صريح للفئات الفرعية
import '../models/calculation_model.dart' show MonthlySalaryResult, FinancialGoalResult;

class CalculationResultWidget extends StatelessWidget {
  final CalculationResult result;

  const CalculationResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'نتيجة الحسبة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (result is MonthlySalaryResult) ... [
              // نتائج حساب الراتب الشهري
              _buildResultItem(
                context,
                title: 'المبلغ النهائي المطلوب:',
                value: _formatCurrency((result as MonthlySalaryResult).totalRequiredAmount),
                isHighlighted: true,
              ),

              const SizedBox(height: 12),

              _buildResultItem(
                context,
                title: 'العائد السنوي المطلوبة للمحافظة على المبلغ:',
                value: '${(result as MonthlySalaryResult).annualReturnRate.toStringAsFixed(1)}%',
                isHighlighted: false,
              ),

              const SizedBox(height: 12),

              _buildResultItem(
                context,
                title: 'الادخار الشهري المطلوب للوصول للمبلغ:',
                value: _formatCurrency((result as MonthlySalaryResult).requiredMonthlySavings),
                isHighlighted: true,
              ),
            ] else if (result is FinancialGoalResult) ... [
              // نتائج حساب الهدف المالي
              _buildResultItem(
                context,
                title: 'المبلغ النهائي مع الأرباح:',
                value: _formatCurrency((result as FinancialGoalResult).finalAmountWithProfits),
                isHighlighted: true,
              ),

              const SizedBox(height: 12),

              _buildResultItem(
                context,
                title: 'المبلغ النهائي بدون أرباح:',
                value: _formatCurrency((result as FinancialGoalResult).finalAmountWithoutProfits),
                isHighlighted: false,
              ),

              const Divider(height: 32),

              _buildResultItem(
                context,
                title: 'إجمالي المدفوع:',
                value: _formatCurrency((result as FinancialGoalResult).totalPaid),
                isHighlighted: false,
              ),

              const SizedBox(height: 12),

              _buildResultItem(
                context,
                title: 'الأرباح التراكمية:',
                value: _formatCurrency((result as FinancialGoalResult).totalProfits),
                isHighlighted: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(
    BuildContext context, {
    required String title,
    required String value,
    required bool isHighlighted,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontSize: isHighlighted ? 18 : 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: isHighlighted ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    // تقريب الرقم إلى أقرب رقم عشري واحد
    final roundedAmount = (amount * 10).round() / 10;

    // تنسيق الرقم بالفواصل للآلاف
    final parts = roundedAmount.toStringAsFixed(1).split('.');
    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    return '$wholePart.${parts[1]} د.ك';
  }
}
