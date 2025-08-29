import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/media_file.dart';
import '../../../domain/models/subfolder.dart';

class FileSelector extends StatelessWidget {
  final int selectedTab;
  final Function(List<MediaFile>) onFilesSelected;
  final Function(List<Subfolder>, List<MediaFile>)? onFoldersSelected;

  const FileSelector({
    super.key,
    required this.selectedTab,
    required this.onFilesSelected,
    this.onFoldersSelected,
  });

  Future<void> pickFiles(bool isAudio) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: isAudio ? FileType.audio : FileType.video,
    );

    if (result != null) {
      List<MediaFile> files = result.files.asMap().entries.map((entry) {
        final file = entry.value;
        final path = file.path ?? '';
        final pathParts = path.split(Platform.pathSeparator);
        final folderName = pathParts.length > 1 ? pathParts[pathParts.length - 2] : '';
        
        return MediaFile(
          name: file.name,
          path: path,
          folder: folderName,
          index: entry.key,
        );
      }).toList();

      onFilesSelected(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.audio_file),
            label: const Text("AUDIO FILE"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => pickFiles(true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.video_file),
            label: const Text("VIDEO FILE"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => pickFiles(false),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.folder),
            label: const Text("FOLDER"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _pickFolder(context),
          ),
        ),
        ],
      ),
    );
  }

  Future<void> _pickFolder(BuildContext context) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      if (selectedDirectory.startsWith('content://')) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Unable to access the selected folder.'),
            ),
          );
        }
        return;
      }

      final dir = Directory(selectedDirectory);
      
      // Get only direct subfolders (not recursive)
      final List<Directory> subfolders = [];
      final List<MediaFile> allFilesFromSubfolders = [];
      
      try {
        await for (final entity in dir.list(followLinks: false)) {
          if (entity is Directory) {
            subfolders.add(entity);
            
            // Get files from this subfolder
            try {
              await for (final subEntity in entity.list(recursive: true)) {
                if (subEntity is File) {
                  final fileName = subEntity.path.toLowerCase();
                  if (fileName.endsWith('.mp3') || 
                      fileName.endsWith('.wav') || 
                      fileName.endsWith('.mp4') || 
                      fileName.endsWith('.mkv') || 
                      fileName.endsWith('.avi')) {
                    allFilesFromSubfolders.add(MediaFile(
                      name: subEntity.uri.pathSegments.last,
                      folder: entity.path.split(Platform.pathSeparator).last,
                      path: subEntity.path,
                      index: allFilesFromSubfolders.length,
                    ));
                  }
                }
              }
            } catch (e) {
              // Continue if we can't access a particular subfolder
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error scanning folders: ${e.toString()}'),
            ),
          );
        }
        return;
      }
      
      if (subfolders.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The selected folder does not contain any subfolders.'),
            ),
          );
        }
        return;
      }

      // Create Subfolder objects for display
      List<Subfolder> subfolderList = subfolders
          .asMap()
          .entries
          .map((entry) => Subfolder(
                name: entry.value.path.split(Platform.pathSeparator).last,
                path: entry.value.path,
                index: entry.key,
              ))
          .toList();

      // Call the new callback if available, otherwise fall back to old behavior
      if (onFoldersSelected != null) {
        onFoldersSelected!(subfolderList, allFilesFromSubfolders);
      } else {
        // Fallback: convert subfolders to MediaFile format for backward compatibility
        List<MediaFile> mediaFiles = subfolderList
            .map((subfolder) => MediaFile(
                  name: subfolder.name,
                  folder: 'Subfolder',
                  path: subfolder.path,
                  index: subfolder.index,
                ))
            .toList();
        onFilesSelected(mediaFiles);
      }
    }
  }


}
