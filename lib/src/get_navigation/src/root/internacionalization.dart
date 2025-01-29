/// List of languages that use Right-to-Left (RTL) writing system
const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi/Persian
  'he', // Hebrew
  'ps', // Pashto
  'ur', // Urdu
];

/// Abstract class for implementing translations in GetX
/// Implementations must provide a map of translations
abstract class Translations {
  /// Returns a map of translations where:
  /// - First key is the locale code (e.g., 'en_US')
  /// - Second key is the translation key
  /// - Value is the translated string
  Map<String, Map<String, String>> get keys;
}
