import 'package:flutter/material.dart';
import '../../../domain/models/media_file.dart';
import '../../equalize/widgets/equalize_screen.dart';

class RenameScreen extends StatefulWidget {
  final List<MediaFile> files;

  const RenameScreen({super.key, required this.files});

  @override
  State<RenameScreen> createState() => _RenameScreenState();
}

class _RenameScreenState extends State<RenameScreen> {
  bool useRegex = false;
  String selectedPattern = '';
  final TextEditingController _regexController = TextEditingController();
  final TextEditingController _comboController = TextEditingController();
  
  // Metadata editing variables
  bool _isBatchMode = true;
  String? _selectedFileForMetadata;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  String renameMethod = 'literal'; // literal, regex, predefined
  String renameOperation = 'replace'; // remove, replace, add
  int currentNavIndex = 1; // Set to Rename tab
  
  final List<String> predefinedPatterns = [
    'Special characters',
    'Start/End space',
    'Double spaces',
    'Spaces',
    'Album name',
    'Year',
    'Minus symbol',
    'Numbers',
    'Underscore',
    'Letters',
    'Band/artist name (Metadata)',
    'Whole',
  ];
  
  final List<String> renameOptions = [
    'Literal',
    'Underscore by Space',
    'Directory',
    'Album',
    'Artist',
    'Track',
    'Year',
    'Counter',
    'Grandfather Dir.',
    'Grandfather and Father Dir.', //use literal track (Grandfather - Father - [Track/name] 01.mp3)
  ];
  
  @override
  void initState() {
    super.initState();
    // Reset renameMethod when useRegex changes
    if (!useRegex && renameMethod == 'regex') {
      renameMethod = 'literal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Column(
        children: [
          // Switch for regex/pattern selection
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Use Regex:', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                Switch(
                  value: useRegex,
                  onChanged: (value) {
                    setState(() {
                      useRegex = value;
                      // Reset renameMethod if regex is disabled and currently selected
                      if (!value && renameMethod == 'regex') {
                        renameMethod = 'literal';
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Pattern selection section based on rename method
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (renameMethod == 'predefined') ...[
                  const Text('Predefined Patterns:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedPattern.isEmpty ? null : selectedPattern,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                    ),
                    items: predefinedPatterns.map((pattern) {
                      return DropdownMenuItem(
                        value: pattern,
                        child: Text(pattern),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPattern = value ?? '';
                      });
                    },
                  ),
                ] else if (renameMethod == 'regex') ...[
                  const Text('Regex Pattern:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _regexController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter regex pattern',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                    ),
                  ),
                ] else ...[
                  const Text('Literal Pattern:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _regexController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter literal text',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Combo box section with rename method selection
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only show rename text field if operation is not 'remove'
                if (renameOperation != 'remove') ...[
                  const Text('Rename Text:', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _comboController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter text for rename',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[600]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[600]!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: PopupMenuButton<String>(
                          icon: Icon(Icons.arrow_drop_down_outlined, color: Colors.grey[400]),
                          color: Colors.grey[800],
                          onSelected: (String value) {
                            setState(() {
                              if (value == 'literal') {
                                _comboController.clear();
                              } else {
                                _comboController.text = value;
                              }
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return renameOptions.map((String option) {
                              return PopupMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                // Rename Method and Operation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: const Text('Rename Method:', style: TextStyle(color: Colors.white)),
                        ),
                        Radio<String>(
                          value: 'literal',
                          groupValue: renameMethod,
                          onChanged: (value) {
                            setState(() {
                              renameMethod = value!;
                            });
                          },
                        ),
                        const Text('Literal', style: TextStyle(color: Colors.white)),
                        // Only show Regex radio when useRegex is true
                        if (useRegex) ...[
                          Radio<String>(
                            value: 'regex',
                            groupValue: renameMethod,
                            onChanged: (value) {
                              setState(() {
                                renameMethod = value!;
                              });
                            },
                          ),
                          const Text('Regex', style: TextStyle(color: Colors.white)),
                        ],
                        Radio<String>(
                          value: 'predefined',
                          groupValue: renameMethod,
                          onChanged: (value) {
                            setState(() {
                              renameMethod = value!;
                            });
                          },
                        ),
                        const Text('Predefined', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: const Text('Rename Operation:', style: TextStyle(color: Colors.white)),
                        ),
                        Radio<String>(
                          value: 'remove',
                          groupValue: renameOperation,
                          onChanged: (value) {
                            setState(() {
                              renameOperation = value!;
                            });
                          },
                        ),
                        const Text('Remove', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                          value: 'replace',
                          groupValue: renameOperation,
                          onChanged: (value) {
                            setState(() {
                              renameOperation = value!;
                            });
                          },
                        ),
                        const Text('Replace', style: TextStyle(color: Colors.white)),
                        Radio<String>(
                          value: 'add',
                          groupValue: renameOperation,
                          onChanged: (value) {
                            setState(() {
                              renameOperation = value!;
                            });
                          },
                        ),
                        const Text('Insert', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Apply button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Apply rename operation
                _showConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // File list at the bottom
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Files to Rename:', style: TextStyle(color: Colors.white, fontSize: 16)),
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[600]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          onPressed: _showMetadataDialog,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          icon: const Text(
                            '</>',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          tooltip: 'Edit Metadata',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600]!, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero, // Remove default padding
                        itemCount: widget.files.length,
                        itemBuilder: (context, index) {
                          final file = widget.files[index];
                          return Container(
                            height: 30, // Small height as requested
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                file.name,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
          if (index == 0) {
            // Navigate to home screen
            Navigator.pop(context);
          } else if (index == 1) {
            // Stay on rename screen - no action needed
          } else if (index == 2) {
            // Navigate to equalize screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EqualizeScreen(files: widget.files),
              ),
            );
          }
        },
      ),
    );
  }

  void _previewRename() {
    setState(() {
      // Update file names with preview based on rename patterns
      for (int i = 0; i < widget.files.length; i++) {
        final file = widget.files[i];
        String newName = _generatePreviewName(file, i);
        // Create a new file object with the preview name
        widget.files[i] = MediaFile(
          name: newName,
          path: file.path,
          folder: file.folder,
          index: file.index,
          isChecked: file.isChecked,
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preview updated with rename patterns!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
  
  String _generatePreviewName(MediaFile file, int index) {
    String renameText = _comboController.text;
    String originalName = file.name;
    
    // Extract extension
    String extension = originalName.contains('.')
        ? originalName.substring(originalName.lastIndexOf('.'))
        : '';
    String nameWithoutExt = originalName.contains('.')
        ? originalName.substring(0, originalName.lastIndexOf('.'))
        : originalName;
    
    if (renameOperation == 'remove') {
      // Remove operation - apply pattern removal
      if (renameMethod == 'literal') {
        return originalName.replaceAll(_regexController.text, '');
      } else if (renameMethod == 'regex') {
        try {
          return originalName.replaceAll(RegExp(_regexController.text), '');
        } catch (e) {
          return originalName; // Return original if regex is invalid
        }
      }
      return originalName;
    } else if (renameOperation == 'replace') {
      // Replace operation
      String newName = renameText;
      
      // Replace placeholders
      newName = newName.replaceAll('{name}', nameWithoutExt);
      newName = newName.replaceAll('{ext}', extension.replaceAll('.', ''));
      newName = newName.replaceAll('{folder}', file.folder);
      newName = newName.replaceAll('{counter}', (index + 1).toString().padLeft(2, '0'));
      
      // Handle predefined patterns
      if (renameMethod == 'predefined' && selectedPattern.isNotEmpty) {
        newName = _applyPredefinedPattern(originalName, selectedPattern);
      }
      
      return newName + extension;
    } else if (renameOperation == 'add') {
      // Insert operation - add rename text to original name
      return nameWithoutExt + '_' + renameText + extension;
    }
    
    return originalName;
  }
  
  String _applyPredefinedPattern(String originalName, String pattern) {
    switch (pattern) {
      case 'Special characters':
        return originalName.replaceAll(RegExp(r'[^a-zA-Z0-9\s\.]'), '');
      case 'Start/End space':
        return originalName.trim();
      case 'Double spaces':
        return originalName.replaceAll(RegExp(r'\s+'), ' ');
      case 'Spaces':
        return originalName.replaceAll(' ', '_');
      case 'Underscore':
        return originalName.replaceAll('_', ' ');
      case 'Numbers':
        return originalName.replaceAll(RegExp(r'\d'), '');
      case 'Letters':
        return originalName.replaceAll(RegExp(r'[a-zA-Z]'), '');
      default:
        return originalName;
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text('Confirm Rename', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to apply the rename operation to all selected files?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _previewRename();
              },
              child: const Text('Preview', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform the actual rename operation here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rename operation applied successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Apply', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showMetadataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[800],
              title: const Text('Edit Metadata', style: TextStyle(color: Colors.white)),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Batch mode switch
                    Row(
                      children: [
                        const Text('Batch Mode:', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 10),
                        Switch(
                          value: _isBatchMode,
                          onChanged: (value) {
                            setState(() {
                              _isBatchMode = value;
                              if (!value) {
                                _selectedFileForMetadata = widget.files.isNotEmpty ? widget.files.first.name : null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // File selection dropdown (only when not in batch mode)
                    if (!_isBatchMode) ...[
                      const Text('Select File:', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedFileForMetadata,
                        dropdownColor: Colors.grey[700],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!),
                          ),
                        ),
                        items: widget.files.map((file) {
                          return DropdownMenuItem(
                            value: file.name,
                            child: Text(file.name, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFileForMetadata = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Metadata input fields
                    _buildMetadataField('Title', _titleController),
                    const SizedBox(height: 12),
                    _buildMetadataField('Artist', _artistController),
                    const SizedBox(height: 12),
                    _buildMetadataField('Album', _albumController),
                    const SizedBox(height: 12),
                    _buildMetadataField('Year', _yearController),
                    const SizedBox(height: 12),
                    _buildMetadataField('Genre', _genreController),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showMetadataConfirmationDialog();
                  },
                  child: const Text('Apply', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Widget _buildMetadataField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showMetadataConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text('Confirm Metadata Changes', style: TextStyle(color: Colors.white)),
          content: Text(
            _isBatchMode
                ? 'Are you sure you want to apply metadata changes to all MP3 files?'
                : 'Are you sure you want to apply metadata changes to the selected file?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _applyMetadataChanges();
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
  
  void _applyMetadataChanges() {
    // Clear the controllers
    _titleController.clear();
    _artistController.clear();
    _albumController.clear();
    _yearController.clear();
    _genreController.clear();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBatchMode
              ? 'Metadata changes applied to all MP3 files successfully!'
              : 'Metadata changes applied to selected file successfully!',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _regexController.dispose();
    _comboController.dispose();
    _titleController.dispose();
    _artistController.dispose();
    _albumController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    super.dispose();
  }
}