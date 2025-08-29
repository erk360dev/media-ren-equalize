import 'package:flutter/foundation.dart';
import '../../../domain/models/media_file.dart';

class EqualizeViewModel extends ChangeNotifier {
  List<MediaFile> _files = [];
  String _selectedEqualizerType = 'Volume';
  List<Map<String, dynamic>> _activeEqualizers = [];
  
  final List<String> _equalizerTypes = ['Volume', 'Bass', 'Mid', 'Treble', 'Codec'];
  final List<String> _codecOptions = ['libmp3lame', 'aac', 'flac', 'ogg', 'wav'];

  // Getters
  List<MediaFile> get files => _files;
  String get selectedEqualizerType => _selectedEqualizerType;
  List<Map<String, dynamic>> get activeEqualizers => _activeEqualizers;
  List<String> get equalizerTypes => _equalizerTypes;
  List<String> get codecOptions => _codecOptions;

  // Methods
  void setFiles(List<MediaFile> files) {
    _files = files;
    notifyListeners();
  }

  void setSelectedEqualizerType(String type) {
    _selectedEqualizerType = type;
    notifyListeners();
  }

  void addEqualizer() {
    if (_selectedEqualizerType == 'Codec') {
      _activeEqualizers.add({
        'type': _selectedEqualizerType,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'value': _codecOptions[0],
      });
    } else {
      _activeEqualizers.add({
        'type': _selectedEqualizerType,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'value': 0.0,
      });
    }
    notifyListeners();
  }

  void removeEqualizer(String id) {
    _activeEqualizers.removeWhere((e) => e['id'] == id);
    notifyListeners();
  }

  void updateEqualizerValue(String id, dynamic value) {
    final equalizer = _activeEqualizers.firstWhere((e) => e['id'] == id);
    equalizer['value'] = value;
    notifyListeners();
  }

  void applyEqualization() {
    // Implementation for applying equalization logic
    // This would typically call a service or repository
    notifyListeners();
  }
}