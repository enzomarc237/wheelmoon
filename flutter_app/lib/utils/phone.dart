class PhoneUtils {
  /// Normalizes a phone number by removing non-digits and country code
  static String normalizePhone(String phone) {
    // Remove all non-digit characters
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Remove country code 237 if present
    if (digits.startsWith('237') && digits.length > 9) {
      digits = digits.substring(3);
    }
    
    return digits;
  }
  
  /// Determines the mobile operator member ID
  static String getOperatorMember(String phone) {
    String normalized = normalizePhone(phone);
    
    if (normalized.startsWith('65') || normalized.startsWith('69')) {
      return '12001'; // Orange
    } else if (normalized.startsWith('67') || normalized.startsWith('68')) {
      return '12002'; // MTN
    }
    
    return '12002'; // Default to MTN
  }
}
