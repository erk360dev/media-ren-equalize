import 'package:flutter/foundation.dart';
import '../../../domain/models/media_file.dart';

class RenameViewModel extends ChangeNotifier {
  List<MediaFile> _files = [];
  String _renameMethod = 'literal';
  String _renameOperation = 'remove';
  String _renameInput = '';
  String _regexInput = '';
  String _selectedPredefinedPattern = 'Remove spaces';
  
  final List<String> _predefinedPatterns = [
    'Remove spaces',
    'Replace underscores with spaces',
    'Convert to lowercase',
    'Convert to uppercase',
    'Remove numbers',
    'Add prefix',
    'Add suffix',
  ];

  // Getters
  List<MediaFile> get files => _files;
  String get renameMethod => _renameMethod;
  String get renameOperation => _renameOperation;
  String get renameInput => _renameInput;
  String get regexInput => _regexInput;
  String get selectedPredefinedPattern => _selectedPredefinedPattern;
  List<String> get predefinedPatterns => _predefinedPatterns;

  // Methods
  void setFiles(List<MediaFile> files) {
    _files = files;
    notifyListeners();
  }

  void setRenameMethod(String method) {
    _renameMethod = method;
    notifyListeners();
  }

  void setRenameOperation(String operation) {
    _renameOperation = operation;
    notifyListeners();
  }

  void setRenameInput(String input) {
    _renameInput = input;
    notifyListeners();
  }

  void setRegexInput(String input) {
    _regexInput = input;
    notifyListeners();
  }

  void setSelectedPredefinedPattern(String pattern) {
    _selectedPredefinedPattern = pattern;
    notifyListeners();
  }

  void applyRename() {
    // Implementation for applying rename logic
    // This would typically call a service or repository
    notifyListeners();
  }
}