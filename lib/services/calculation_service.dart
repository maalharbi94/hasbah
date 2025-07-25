import 'dart:math';
import '../models/calculation_model.dart';

/// خدمة تنفيذ العمليات الحسابية لموقع حسبه
class CalculationService {
  /// حساب النتيجة بناءً على نوع الحسبة والمدخلات
  CalculationResult calculate(CalculationInput input) {
    switch (input.type) {
      case CalculationType.monthlySalary:
        return _calculateMonthlySalaryRequirements(input);
      case CalculationType.financialGoal:
        return _calculateFinancialGoal(input);
    }
  }

  /// حساب متطلبات الراتب الشهري (المبلغ النهائي والادخار الشهري المطلوب)
  CalculationResult _calculateMonthlySalaryRequirements(CalculationInput input) {
    // 1. حساب المبلغ الإجمالي المطلوب لتأمين الراتب الشهري
    // صيغة الحساب: المبلغ النهائي المطلوب = الدخل الشهري المطلوب × 12 ÷ نسبة العائد السنوي المتوقعة
    final double monthlyIncome = input.requiredMonthlyIncome!;
    
    // نسبة العائد السنوي المتوقعة وقت التقاعد (4% افتراضية)
    final double expectedAnnualReturn = 4.0; // نسبة مئوية
    
    // المبلغ النهائي المطلوب = الدخل السنوي ÷ نسبة العائد السنوي
    final double totalRequiredAmount = (monthlyIncome * 12) / (expectedAnnualReturn / 100);
    
    // 2. حساب نسبة العائد السنوي المطلوبة للمحافظة على المبلغ
    // نسبة العائد = (الدخل الشهري * 12) / المبلغ النهائي * 100
    final double annualReturnRate = (monthlyIncome * 12) / totalRequiredAmount * 100;
    
    // 3. حساب الادخار الشهري المطلوب للوصول للمبلغ
    final int totalMonths = input.yearsToRetirement! * 12;
    final double initialAmount = input.initialAmount ?? 0;
    
    // معدل عائد سنوي افتراضي للحساب (4%)
    final double assumedAnnualReturn = 4.0;
    final double monthlyRate = assumedAnnualReturn / 100 / 12;
    
    // حساب الادخار الشهري المطلوب باستخدام معادلة القيمة المستقبلية
    // FV = P(1+r)^n + PMT * ((1+r)^n - 1) / r
    // PMT = (FV - P(1+r)^n) / (((1+r)^n - 1) / r)
    double requiredMonthlySavings;
    if (monthlyRate > 0 && totalMonths > 0) {
      final futureValueOfInitial = initialAmount * pow(1 + monthlyRate, totalMonths);
      final compound = (pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate;
      requiredMonthlySavings = (totalRequiredAmount - futureValueOfInitial) / compound;
      // في حالة قيمة سالبة (المبلغ المبدئي كافي)، نرجع صفر
      requiredMonthlySavings = max(0, requiredMonthlySavings);
    } else {
      // في حالة عدم وجود فائدة أو عدم وجود فترة زمنية
      requiredMonthlySavings = totalMonths > 0 ? 
        (totalRequiredAmount - initialAmount) / totalMonths : 0;
    }
    
    return MonthlySalaryResult(
      initialAmount: initialAmount,
      totalRequiredAmount: totalRequiredAmount,
      annualReturnRate: annualReturnRate,
      requiredMonthlySavings: requiredMonthlySavings,
    );
  }

  /// حساب نتائج الهدف المالي (المبلغ المتجمع بعد فترة الادخار)
  CalculationResult _calculateFinancialGoal(CalculationInput input) {
    // المدخلات المطلوبة
    final double monthlySavings = input.monthlySavingsAmount!;
    final int totalMonths = input.savingYears! * 12;
    final double annualProfitRate = input.annualProfitRate!;
    final double initialAmount = input.initialAmount ?? 0;
    
    // حساب المبلغ النهائي بدون أرباح
    // المبلغ النهائي = المبلغ المبدئي + (المبلغ الشهري * عدد الأشهر)
    final double finalAmountWithoutProfits = initialAmount + (monthlySavings * totalMonths);
    
    // حساب المبلغ النهائي مع الأرباح التراكمية
    // تحويل معدل الربح السنوي إلى شهري
    final double monthlyProfitRate = annualProfitRate / 100 / 12;
    
    // حساب المبلغ النهائي باستخدام معادلة القيمة المستقبلية للأقساط الدورية مع الفائدة المركبة
    double finalAmountWithProfits;
    if (monthlyProfitRate > 0) {
      // حساب قيمة المبلغ المبدئي في المستقبل
      final double futureValueOfInitial = initialAmount * pow(1 + monthlyProfitRate, totalMonths);
      // حساب قيمة الأقساط الشهرية مع الفائدة المركبة
      final double compound = (pow(1 + monthlyProfitRate, totalMonths) - 1) / monthlyProfitRate;
      finalAmountWithProfits = futureValueOfInitial + monthlySavings * compound;
    } else {
      // في حالة عدم وجود أرباح (نسبة صفر)
      finalAmountWithProfits = finalAmountWithoutProfits;
    }
    
    // حساب إجمالي المدفوع
    final double totalPaid = initialAmount + (monthlySavings * totalMonths);
    
    // حساب إجمالي الأرباح
    final double totalProfits = finalAmountWithProfits - finalAmountWithoutProfits;
    
    return FinancialGoalResult(
      initialAmount: initialAmount,
      finalAmountWithoutProfits: finalAmountWithoutProfits,
      finalAmountWithProfits: finalAmountWithProfits,
      totalPaid: totalPaid,
      totalProfits: totalProfits,
    );
  }
}
