import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatelessWidget {
  final XFile file;
  const ScanPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Page")),
      body: Center(
        child: Text("Scanned File: ${file.name}"),
      ),
    );
  }
}
