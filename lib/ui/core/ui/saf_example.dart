import 'package:flutter/material.dart';
import 'package:saf/saf.dart';

class SafExamplePage extends StatefulWidget {
  const SafExamplePage({super.key});

  @override
  State<SafExamplePage> createState() => _SafExamplePageState();
}

class _SafExamplePageState extends State<SafExamplePage> {
  Saf saf = Saf("Download"); // pasta base, pode trocar
  List<String> _files = [];

  Future<void> pickFolder() async {
	  final granted = await saf.getDirectoryPermission(isDynamic: true) ?? false;

	  if (granted) {
		// A lista de arquivos já é uma List<String>
		final files = await saf.cache();
		setState(() {
		  // Atribua diretamente a lista, usando `?? []` para evitar null
		  _files = files ?? []; 
		});
	  } else {
		setState(() {
		  _files = ["Permissão negada!"];
		});
	  }
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SAF Example")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickFolder,
            child: const Text("Selecionar Pasta"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_files[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}