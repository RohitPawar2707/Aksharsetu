import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';

class CropPage extends StatefulWidget {
  final String imagePath;

  const CropPage({super.key, required this.imagePath});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final CropController _controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Crop Image"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: File(widget.imagePath).readAsBytesSync(),
              controller: _controller,
              onCropped: (croppedBytes) {
                final file = File(widget.imagePath)
                  ..writeAsBytesSync(croppedBytes);
                Navigator.pop(context, file);
              },
              initialSize: 0.8,
              interactive: true,
              cornerDotBuilder: (size, index) => Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _controller.crop(),
            child: const Text("Done"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
