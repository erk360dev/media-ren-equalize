
import 'package:flutter/material.dart';

class FileListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String path;
  final bool isChecked;
  final Function(bool) onCheckChanged;

  const FileListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.isChecked,
    required this.onCheckChanged,
  });

  @override
  State<FileListItem> createState() => _FileListItemState();
}

class _FileListItemState extends State<FileListItem> {
  late bool isChecked;
  
  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }
  
  @override
  void didUpdateWidget(FileListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      isChecked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Color.fromRGBO(66, 52, 42, 1), // Darker brown-tinted color
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: ListTile(
        leading: Icon(
          widget.path.endsWith('.mp3') || widget.path.endsWith('.wav')
              ? Icons.audiotrack
              : Icons.videocam,
          color: Colors.blue,
          size: 28,
        ),
        title: Text(
          widget.title, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.subtitle, 
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Checkbox(
          value: isChecked,
          onChanged: (val) {
            setState(() {
              isChecked = val ?? false;
            });
            widget.onCheckChanged(isChecked);
          },
          activeColor: Colors.blue,
        ),
        onTap: () {
          setState(() {
            isChecked = !isChecked;
          });
          widget.onCheckChanged(isChecked);
        },
      )
    );
  }
}
