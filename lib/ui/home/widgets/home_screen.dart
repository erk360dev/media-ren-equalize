import 'package:flutter/material.dart';
import '../../../domain/models/media_file.dart';
import '../../../domain/models/subfolder.dart';
import '../../core/ui/file_selector.dart';
import '../../core/ui/file_list_view.dart';
import '../../core/ui/config_panel.dart';
import '../../rename/widgets/rename_screen.dart';
import '../../equalize/widgets/equalize_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  int currentNavIndex = 0; // For bottom navigation
  List<MediaFile> selectedFiles = [];
  List<Subfolder> selectedSubfolders = [];
  List<MediaFile> filesFromSubfolders =
      []; // Hidden list for files from subfolders
  bool _isFromFolderSelection = false; // Track if files are from folder selection

  // Variables to track renaming pattern - now disconnected from functionality
  String _renamingPattern = '';
  bool _showRenamingPreview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('FILE SELECTOR & PROCESSOR',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
      ),
      body: Column(
        children: [
          // Text input area with preview button
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Preview button removed
                if (false &&
                    selectedFiles
                        .isNotEmpty) // Preview section is now always hidden
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 100,
                    child: ListView.builder(
                      itemCount:
                          selectedFiles.length > 3 ? 3 : selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        final originalName = file.name;
                        final extension = originalName.contains('.')
                            ? originalName
                                .substring(originalName.lastIndexOf('.'))
                            : '';
                        final nameWithoutExt = originalName.contains('.')
                            ? originalName.substring(
                                0, originalName.lastIndexOf('.'))
                            : originalName;

                        String newName = _renamingPattern;
                        newName = newName.replaceAll('{name}', nameWithoutExt);
                        newName = newName.replaceAll('{ext}', extension);
                        newName = newName.replaceAll('{folder}', file.folder);

                        return ListTile(
                          dense: true,
                          title: Text(
                            '$originalName → $newName',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // File selector buttons
          FileSelector(
            selectedTab: selectedTab,
            onFilesSelected: (files) {
              setState(() {
                selectedFiles = files;
                _isFromFolderSelection = false; // Files selected via Audio/Video buttons
              });
            },
            onFoldersSelected: (subfolders, filesFromSubfolders) {
              setState(() {
                selectedSubfolders = subfolders;
                this.filesFromSubfolders = filesFromSubfolders;
                _isFromFolderSelection = true; // Files selected via Folder button
                // Show subfolders in the main list instead of files
                selectedFiles = subfolders
                    .map((subfolder) => MediaFile(
                          name: subfolder.name,
                          folder: 'Subfolder',
                          path: subfolder.path,
                          index: subfolder.index,
                        ))
                    .toList();
              });
            },
          ),

          // File list
          Expanded(
            child: selectedFiles.isEmpty
                ? const Center(
                    child: Text(
                      'No files selected',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : FileListView(
                    files: selectedFiles,
                    showCheckboxes: _isFromFolderSelection,
                    onItemTapped: (file) {
                      debugPrint("Clicked: \${file.name}");
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        currentIndex: currentNavIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Rename',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            label: 'Equalize',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
          if (index == 0) {
            // Stay on home screen - no navigation needed
          } else if (index == 1) {
            // Navigate to rename screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RenameScreen(
                    files: filesFromSubfolders.isNotEmpty
                        ? filesFromSubfolders
                        : selectedFiles),
              ),
            ).then((_) {
              setState(() {
                currentNavIndex = 0; // Reset to home when returning
              });
            });
          } else if (index == 2) {
            // Navigate to equalize screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EqualizeScreen(
                    files: filesFromSubfolders.isNotEmpty
                        ? filesFromSubfolders
                        : selectedFiles),
              ),
            ).then((_) {
              setState(() {
                currentNavIndex = 0; // Reset to home when returning
              });
            });
          }
        },
      ),
    );
  }
}
