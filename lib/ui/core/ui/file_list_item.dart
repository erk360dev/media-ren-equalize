import 'package:flutter/material.dart';

class FileListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String path;
  final bool isChecked;
  final bool showCheckbox;
  final Function(bool) onCheckChanged;

  const FileListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.isChecked,
    this.showCheckbox = true, // Default to true for backward compatibility
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
        color: Colors.grey[800], // Lighter background matching app theme
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.grey[600]!, width: 1), // Gray border
        ),
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
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.subtitle,
            style: TextStyle(color: Colors.grey[400]),
          ),
          trailing: widget.showCheckbox
              ? Checkbox(
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val ?? false;
                    });
                    widget.onCheckChanged(isChecked);
                  },
                  activeColor: Colors.blue,
                )
              : null,
          onTap: widget.showCheckbox
              ? () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                  widget.onCheckChanged(isChecked);
                }
              : null,
        ));
  }
}
