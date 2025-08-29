
import 'package:flutter/material.dart';
import '../models/media_file.dart';
import 'file_list_item.dart';

class FileListView extends StatefulWidget {
  final List<MediaFile> files;
  final Function(MediaFile) onItemTapped;

  const FileListView({
    super.key,
    required this.files,
    required this.onItemTapped,
  });
  
  @override
  State<FileListView> createState() => _FileListViewState();
}

class _FileListViewState extends State<FileListView> {
  // Track selected files
  void _handleCheckChanged(MediaFile file, bool isChecked) {
    setState(() {
      file.isChecked = isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selection controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.files.where((f) => f.isChecked).length} of ${widget.files.length} selected',
                style: const TextStyle(color: Colors.white70),
              ),
              Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.select_all, size: 18),
                    label: const Text('SELECT ALL'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        for (var file in widget.files) {
                          file.isChecked = true;
                        }
                      });
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.deselect, size: 18),
                    label: const Text('DESELECT ALL'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        for (var file in widget.files) {
                          file.isChecked = false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // File list
        Expanded(
          child: ListView.builder(
            itemCount: widget.files.length,
            itemBuilder: (context, index) {
              final file = widget.files[index];
              return FileListItem(
                title: file.name,
                subtitle: file.folder,
                path: file.path,
                isChecked: file.isChecked,
                onCheckChanged: (isChecked) => _handleCheckChanged(file, isChecked),
              );
            },
          ),
        ),
      ],
    );
  }
}
