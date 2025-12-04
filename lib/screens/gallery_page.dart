import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatelessWidget {
  final XFile file;
  const GalleryPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery Page")),
      body: Center(
        child: Text("Gallery File: ${file.name}"),
      ),
    );
  }
}
