import '../../domain/models/media_file.dart';
import '../../domain/models/subfolder.dart';
import '../services/file_service.dart';

class FileRepository {
  final FileService _fileService;

  FileRepository(this._fileService);

  Future<List<MediaFile>> getFilesFromDirectory(String directoryPath) async {
    return await _fileService.getFilesFromDirectory(directoryPath);
  }

  Future<List<Subfolder>> getSubfoldersFromDirectory(String directoryPath) async {
    return await _fileService.getSubfoldersFromDirectory(directoryPath);
  }

  Future<List<MediaFile>> getFilesFromSubfolders(List<Subfolder> subfolders) async {
    return await _fileService.getFilesFromSubfolders(subfolders);
  }

  Future<bool> renameFiles(List<MediaFile> files, String method, String operation, String input) async {
    return await _fileService.renameFiles(files, method, operation, input);
  }

  Future<bool> applyEqualization(List<MediaFile> files, List<Map<String, dynamic>> equalizers) async {
    return await _fileService.applyEqualization(files, equalizers);
  }
}