import 'package:flutter/foundation.dart';
import '../../../domain/models/media_file.dart';
import '../../../domain/models/subfolder.dart';

class HomeViewModel extends ChangeNotifier {
  List<MediaFile> _selectedFiles = [];
  List<MediaFile> _filesFromSubfolders = [];
  List<Subfolder> _subfolders = [];
  String? _selectedFolderPath;
  int _currentNavIndex = 0;

  // Getters
  List<MediaFile> get selectedFiles => _selectedFiles;
  List<MediaFile> get filesFromSubfolders => _filesFromSubfolders;
  List<Subfolder> get subfolders => _subfolders;
  String? get selectedFolderPath => _selectedFolderPath;
  int get currentNavIndex => _currentNavIndex;

  // Methods
  void updateSelectedFiles(List<MediaFile> files) {
    _selectedFiles = files;
    notifyListeners();
  }

  void updateFilesFromSubfolders(List<MediaFile> files) {
    _filesFromSubfolders = files;
    notifyListeners();
  }

  void updateSubfolders(List<Subfolder> subfolders) {
    _subfolders = subfolders;
    notifyListeners();
  }

  void setSelectedFolderPath(String? path) {
    _selectedFolderPath = path;
    notifyListeners();
  }

  void setCurrentNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void resetNavIndex() {
    _currentNavIndex = 0;
    notifyListeners();
  }
}