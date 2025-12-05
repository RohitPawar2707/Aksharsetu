import 'dart:io';
import 'package:flutter/material.dart';
import 'tts_page.dart';

class AppLanguage {
  final String name;
  final String script;
  final String ttsCode;

  const AppLanguage({
    required this.name,
    required this.script,
    required this.ttsCode,
  });
}

const List<AppLanguage> appLanguages = [
  AppLanguage(name: "Hindi", script: "Devanagari", ttsCode: "hi-IN"),
  AppLanguage(name: "Marathi", script: "Devanagari", ttsCode: "mr-IN"),
  AppLanguage(name: "Tamil", script: "Tamil", ttsCode: "ta-IN"),
  AppLanguage(name: "Telugu", script: "Telugu", ttsCode: "te-IN"),
  AppLanguage(name: "Gujarati", script: "Gujarati", ttsCode: "gu-IN"),
  AppLanguage(name: "Kannada", script: "Kannada", ttsCode: "kn-IN"),
  AppLanguage(name: "Malayalam", script: "Malayalam", ttsCode: "ml-IN"),
  AppLanguage(name: "Bengali", script: "Bengali", ttsCode: "bn-IN"),
  AppLanguage(name: "Punjabi", script: "Gurmukhi", ttsCode: "pa-IN"),
  AppLanguage(name: "English", script: "Latin", ttsCode: "en-IN"),
];

class TransliterationOutputPage extends StatefulWidget {
  final String image;
  final String language;
  final String script;
  final String ttsCode;

  const TransliterationOutputPage({
    super.key,
    required this.image,
    required this.language,
    required this.script,
    required this.ttsCode,
  });

  @override
  State<TransliterationOutputPage> createState() =>
      _TransliterationOutputPageState();
}

class _TransliterationOutputPageState extends State<TransliterationOutputPage> {
  late AppLanguage _selectedLang;

  @override
  void initState() {
    super.initState();

    _selectedLang = appLanguages.firstWhere(
            (l) => l.name == widget.language,
        orElse: () => appLanguages.first);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final file = File(widget.image);

    return Scaffold(
      backgroundColor: const Color(0xFF050A30),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Transliteration Output"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: _bottomNav(),

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// IMAGE 70%
            SizedBox(
              height: size.height * 0.70,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                /// TTS BUTTON
                Expanded(
                  flex: 12,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TtsPage(
                            imagePath: widget.image,
                            language: _selectedLang.name,
                            ttsCode: _selectedLang.ttsCode, text: '', script: '',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text("Text to Speech"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// LANGUAGE DROPDOWN
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E1446),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AppLanguage>(
                        value: _selectedLang,
                        dropdownColor: const Color(0xFF0E1446),
                        icon: const Icon(Icons.arrow_drop_down_rounded,
                            color: Colors.white),
                        items: appLanguages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(lang.name,
                                style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (lang) =>
                            setState(() => _selectedLang = lang!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.blueAccent, size: 30),
            onPressed: () => Navigator.pushNamed(context, "/home"),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.purple, size: 30),
            onPressed: () => Navigator.pushNamed(context, "/profile"),
          ),
        ],
      ),
    );
  }
}
