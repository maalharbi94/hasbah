// تعريف أنواع الحسابات
enum CalculationType {
  monthlySalary, // راتب شهري
  financialGoal, // هدف مالي
}

// نموذج إدخال البيانات للحساب
class CalculationInput {
  final CalculationType type;
  final double? initialAmount; // المبلغ المبدئي (اختياري)
  
  // حقول خاصة بنوع "راتب شهري"
  final double? requiredMonthlyIncome; // الدخل الشهري المطلوب
  final int? yearsToRetirement; // عدد السنوات حتى التقاعد
  
  // حقول خاصة بنوع "هدف مالي"
  final double? monthlySavingsAmount; // المبلغ الشهري المدخر
  final int? savingYears; // عدد سنوات الادخار
  final double? annualProfitRate; // نسبة الربح السنوية

  // باني النموذج لنوع "راتب شهري"
  CalculationInput.forMonthlySalary({
    required this.requiredMonthlyIncome,
    required this.yearsToRetirement,
    this.initialAmount,
  }) : type = CalculationType.monthlySalary,
       monthlySavingsAmount = null,
       savingYears = null,
       annualProfitRate = null;

  // باني النموذج لنوع "هدف مالي"
  CalculationInput.forFinancialGoal({
    required this.monthlySavingsAmount,
    required this.savingYears,
    required this.annualProfitRate,
    this.initialAmount,
  }) : type = CalculationType.financialGoal,
       requiredMonthlyIncome = null,
       yearsToRetirement = null;
}

// نموذج النتائج
abstract class CalculationResult {
  final CalculationType type;
  final double? initialAmount; // المبلغ المبدئي (إن وجد)
  
  const CalculationResult({required this.type, this.initialAmount});
}

// نتائج حساب الراتب الشهري
class MonthlySalaryResult extends CalculationResult {
  final double totalRequiredAmount; // المبلغ النهائي المطلوب
  final double annualReturnRate; // نسبة العائد السنوي
  final double requiredMonthlySavings; // الادخار الشهري المطلوب
  
  const MonthlySalaryResult({
    double? initialAmount,
    required this.totalRequiredAmount,
    required this.annualReturnRate,
    required this.requiredMonthlySavings,
  }) : super(
         type: CalculationType.monthlySalary, 
         initialAmount: initialAmount
       );
}

// نتائج حساب الهدف المالي
class FinancialGoalResult extends CalculationResult {
  final double finalAmountWithoutProfits; // المبلغ النهائي بدون أرباح
  final double finalAmountWithProfits; // المبلغ النهائي مع الأرباح
  final double totalPaid; // إجمالي المدفوع
  final double totalProfits; // إجمالي الأرباح التراكمية

  const FinancialGoalResult({
    double? initialAmount,
    required this.finalAmountWithoutProfits,
    required this.finalAmountWithProfits,
    required this.totalPaid,
    required this.totalProfits,
  }) : super(
         type: CalculationType.financialGoal, 
         initialAmount: initialAmount
       );
}
