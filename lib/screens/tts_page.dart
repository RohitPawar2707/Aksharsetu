import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TtsPage extends StatefulWidget {
  final String imagePath;
  final String ttsCode;
  final String language;

  const TtsPage({
    super.key,
    required this.imagePath,
    required this.language,
    required this.ttsCode, required String text, required String script,
  });

  @override
  State<TtsPage> createState() => _TtsPageState();
}

class _TtsPageState extends State<TtsPage> {
  final FlutterTts _tts = FlutterTts();
  late final TextRecognizer _recognizer;

  String extractedText = "";
  bool loading = true;
  bool speaking = false;

  @override
  void initState() {
    super.initState();
    _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _extractText();
    _setupTts();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage(widget.ttsCode);
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  Future<void> _extractText() async {
    final inputImage = InputImage.fromFile(File(widget.imagePath));
    final result = await _recognizer.processImage(inputImage);

    setState(() {
      extractedText = result.text.isEmpty
          ? "No readable text found in image."
          : result.text;
      loading = false;
    });
  }

  Future<void> _speak() async {
    setState(() => speaking = true);
    await _tts.stop();
    await _tts.speak(extractedText);
    setState(() => speaking = false);
  }

  @override
  void dispose() {
    _tts.stop();
    _recognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF050A30),

      appBar: AppBar(
        title: Text("Speak in ${widget.language}"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: loading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    extractedText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: speaking ? null : _speak,
              icon: const Icon(Icons.volume_up_rounded),
              label: Text(
                speaking ? "Speaking..." : "Speak",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                minimumSize: Size(size.width * 0.85, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
