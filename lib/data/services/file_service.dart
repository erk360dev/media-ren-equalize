import 'dart:io';
import '../../domain/models/media_file.dart';
import '../../domain/models/subfolder.dart';

class FileService {
  Future<List<MediaFile>> getFilesFromDirectory(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        return [];
      }

      final files = await directory
          .list()
          .where((entity) => entity is File)
          .cast<File>()
          .toList();

      return files.map((file) {
        return MediaFile(
          folder: file.parent.path,
          index: files.indexOf(file),
          name: file.uri.pathSegments.last,
          path: file.path,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Subfolder>> getSubfoldersFromDirectory(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        return [];
      }

      final subfolders = await directory
          .list()
          .where((entity) => entity is Directory)
          .cast<Directory>()
          .toList();

      return subfolders.map((folder) {
        return Subfolder(
          index: subfolders.indexOf(folder),
          name: folder.uri.pathSegments[folder.uri.pathSegments.length - 2],
          path: folder.path,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MediaFile>> getFilesFromSubfolders(List<Subfolder> subfolders) async {
    List<MediaFile> allFiles = [];
    
    for (final subfolder in subfolders) {
      final files = await getFilesFromDirectory(subfolder.path);
      allFiles.addAll(files);
    }
    
    return allFiles;
  }

  Future<bool> renameFiles(List<MediaFile> files, String method, String operation, String input) async {
    try {
      // Implementation for renaming files based on method, operation, and input
      // This is a placeholder - actual implementation would depend on requirements
      for (final file in files) {
        // Perform rename operation
        print('Renaming ${file.name} using $method $operation with input: $input');
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> applyEqualization(List<MediaFile> files, List<Map<String, dynamic>> equalizers) async {
    try {
      // Implementation for applying equalization to files
      // This is a placeholder - actual implementation would use audio processing libraries
      for (final file in files) {
        print('Applying equalization to ${file.name}');
        for (final equalizer in equalizers) {
          print('  ${equalizer['type']}: ${equalizer['value']}');
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}