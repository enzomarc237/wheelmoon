class FormatUtils {
  static String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0)} XAF';
  }
  
  static String formatCurrencyWithSeparators(double amount) {
    final amountStr = amount.toStringAsFixed(0);
    final formatted = amountStr.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted XAF';
  }
}
