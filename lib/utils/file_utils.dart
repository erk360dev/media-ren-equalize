import 'dart:io';
import 'package:path/path.dart' as path;

class FileUtils {
  /// Check if a file has a supported audio extension
  static bool isAudioFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.mp3', '.wav', '.flac', '.aac', '.ogg'].contains(extension);
  }
  
  /// Check if a file has a supported video extension
  static bool isVideoFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.mp4', '.avi', '.mkv', '.mov', '.wmv'].contains(extension);
  }
  
  /// Check if a file is a media file (audio or video)
  static bool isMediaFile(String filePath) {
    return isAudioFile(filePath) || isVideoFile(filePath);
  }
  
  /// Get file size in a human-readable format
  static String getFileSize(File file) {
    try {
      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } catch (e) {
      return 'Unknown';
    }
  }
  
  /// Get file extension without the dot
  static String getFileExtension(String filePath) {
    return path.extension(filePath).replaceFirst('.', '').toUpperCase();
  }
  
  /// Get file name without extension
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }
  
  /// Validate file name for renaming
  static bool isValidFileName(String fileName) {
    if (fileName.isEmpty) return false;
    
    // Check for invalid characters
    final invalidChars = RegExp(r'[<>:"/\|?*]');
    if (invalidChars.hasMatch(fileName)) return false;
    
    // Check for reserved names on Windows
    final reservedNames = ['CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9', 'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9'];
    if (reservedNames.contains(fileName.toUpperCase())) return false;
    
    return true;
  }
}