import 'package:flutter/material.dart';
import '../models/media_file.dart';

class EqualizeScreen extends StatefulWidget {
  final List<MediaFile> files;

  const EqualizeScreen({super.key, required this.files});

  @override
  State<EqualizeScreen> createState() => _EqualizeScreenState();
}

class _EqualizeScreenState extends State<EqualizeScreen> {
  String selectedEqualizerType = 'Volume';
  List<Map<String, dynamic>> activeEqualizers = [];
  
  final List<String> equalizerTypes = [
    'Volume',
    'Bass',
    'Mid',
    'Treble',
    'Codec',
  ];
  
  final List<String> codecOptions = [
    'libmp3lame',
    'aac',
    'flac',
    'ogg',
    'wav',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Equalize Files', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Equalizer controls
            const Text(
              'Audio Equalizer',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Equalizer type selector and add button
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedEqualizerType,
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
                    items: equalizerTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEqualizerType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addEqualizer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Active equalizers
            ...activeEqualizers.map((equalizer) => _buildEqualizerWidget(equalizer)).toList(),
            
            const SizedBox(height: 30),
            
            // Apply button
            ElevatedButton(
              onPressed: _showEqualizationConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Apply Equalization'),
            ),
            
            const SizedBox(height: 20),
            
            // File list
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Files to Equalize:', style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600]!, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListView.builder(
                        itemCount: widget.files.length,
                        itemBuilder: (context, index) {
                          final file = widget.files[index];
                          return GestureDetector(
                            onTap: () {
                              _showFileDetailsDialog(file);
                            },
                            child: Container(
                              height: 30,
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addEqualizer() {
    setState(() {
      if (selectedEqualizerType == 'Codec') {
        activeEqualizers.add({
          'type': selectedEqualizerType,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'value': codecOptions[0],
        });
      } else {
        activeEqualizers.add({
          'type': selectedEqualizerType,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'value': 0.0,
        });
      }
    });
  }

  Widget _buildEqualizerWidget(Map<String, dynamic> equalizer) {
    if (equalizer['type'] == 'Codec') {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${equalizer['type']}:', style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: equalizer['value'],
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
                    items: codecOptions.map((codec) {
                      return DropdownMenuItem(
                        value: codec,
                        child: Text(codec),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        equalizer['value'] = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                setState(() {
                  activeEqualizers.removeWhere((e) => e['id'] == equalizer['id']);
                });
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${equalizer['type']}: ${(equalizer['value'] as double).toStringAsFixed(1)}', 
                       style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: equalizer['value'],
                    min: -10.0,
                    max: 10.0,
                    divisions: 20,
                    onChanged: (value) {
                      setState(() {
                        equalizer['value'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                setState(() {
                  activeEqualizers.removeWhere((e) => e['id'] == equalizer['id']);
                });
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      );
    }
  }

  void _showEqualizationConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text('Confirm Equalization', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to apply equalization to the selected files?',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Equalization applied successfully!')),
                );
              },
              child: const Text('Apply', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showFileDetailsDialog(MediaFile file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text('File Details: ${file.name}', style: const TextStyle(color: Colors.white)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Volume = 20', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text('Frame Rate = 100', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text('Bit Rate = 128', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text('Codec = libmp3lame', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text('Size = 5 MB', style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}