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
  String renameMethod = 'literal'; // literal, regex, predefined
  String renameOperation = 'replace'; // remove, replace, add
  int currentNavIndex = 1; // Set to Rename tab
  
  final List<String> predefinedPatterns = [
    'Remove spaces',
    'Add prefix',
    'Add suffix',
    'Replace underscores with spaces',
    'Lowercase all',
    'Uppercase all',
  ];

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
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Regex or Pattern selection section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: useRegex
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                const Text('Rename Text:', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: _comboController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter text for renaming',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                  ),
                ),
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
                        const Text('Add', style: TextStyle(color: Colors.white)),
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
                  const Text('Files to Rename:', style: TextStyle(color: Colors.white, fontSize: 16)),
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

  @override
  void dispose() {
    _regexController.dispose();
    _comboController.dispose();
    super.dispose();
  }
}