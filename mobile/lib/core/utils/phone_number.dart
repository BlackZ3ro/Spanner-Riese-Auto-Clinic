/// Turns phone numbers as people type them ("082 345 6721", "+27 (0)82 345 6721"...)
/// into the formats WhatsApp and SMS need.
class PhoneNumber {
  PhoneNumber._();

  /// South Africa. Numbers written without a country code are assumed to be local.
  static const defaultCountryCode = '27';

  /// International digits without the "+", e.g. `27823456721`.
  /// Returns null when the text doesn't look like a real phone number.
  static String? international(String raw, {String countryCode = defaultCountryCode}) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final hasPlus = trimmed.startsWith('+');
    var digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    if (!hasPlus) {
      if (digits.startsWith('00')) {
        // 0027 82 345 6721 -> 27 82 345 6721
        digits = digits.substring(2);
      } else if (digits.startsWith('0')) {
        // 082 345 6721 -> 27 82 345 6721
        digits = countryCode + digits.substring(1);
      } else if (digits.length == 9) {
        // 82 345 6721 (leading zero left off) -> 27 82 345 6721
        digits = countryCode + digits;
      }
    }

    // "+27 (0)82 345 6721" writes the local zero after the country code: drop it.
    if (digits.startsWith('${countryCode}0')) {
      digits = countryCode + digits.substring(countryCode.length + 1);
    }

    if (digits.length < 8 || digits.length > 15) return null; // international limits
    if (digits.startsWith('0')) return null;

    // South African numbers are the country code plus exactly 9 digits.
    if (countryCode == '27' && digits.startsWith('27') && digits.length != 11) return null;

    return digits;
  }

  /// `+27823456721` form, used for SMS. Null when the number isn't usable.
  static String? e164(String raw) {
    final digits = international(raw);
    return digits == null ? null : '+$digits';
  }
}
