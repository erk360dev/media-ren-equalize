class Subfolder {
  final String name;
  final String path;
  final int index;
  bool isChecked;

  Subfolder({
    required this.name,
    required this.path,
    required this.index,
    this.isChecked = false,
  });
}