class MediaFile {
  final String name;
  final String path;
  final String folder;
  final int index;
  bool isChecked;

  MediaFile({
    required this.name,
    required this.path,
    required this.folder,
    required this.index,
    this.isChecked = false,
  });
}