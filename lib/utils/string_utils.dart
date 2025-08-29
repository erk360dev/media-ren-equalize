class StringUtils {
  /// Capitalize the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  /// Convert camelCase to Title Case
  static String camelCaseToTitleCase(String text) {
    if (text.isEmpty) return text;
    
    return text
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim()
        .split(' ')
        .map((word) => capitalize(word))
        .join(' ');
  }
  
  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }
  
  /// Check if string is null or empty
  static bool isNullOrEmpty(String? text) {
    return text == null || text.isEmpty;
  }
  
  /// Check if string is null, empty, or whitespace
  static bool isNullOrWhitespace(String? text) {
    return text == null || text.trim().isEmpty;
  }
  
  /// Remove special characters and keep only alphanumeric and spaces
  static String sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^a-zA-Z0-9\s\-_\.]'), '');
  }
  
  /// Format duration in seconds to MM:SS format
  static String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  /// Generate a unique ID based on timestamp
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}