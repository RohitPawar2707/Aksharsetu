// camera_page.dart
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with TickerProviderStateMixin {
  CameraController? controller;
  List<CameraDescription>? cameras;

  bool flashOn = false;
  bool isFront = false;

  File? capturedImage;
  File? galleryImage;

  String? selectedLanguage;

  late AnimationController glowController;

  File? get activeImage => capturedImage ?? galleryImage;

  @override
  void initState() {
    super.initState();
    _initCamera();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.92,
      upperBound: 1.08,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller?.dispose();
    glowController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();

    final backCam = cameras!.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras!.first,
    );

    controller = CameraController(
      backCam,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (!(controller?.value.isInitialized ?? false)) return;

    flashOn = !flashOn;
    await controller!.setFlashMode(
        flashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  Future<void> _switchCamera() async {
    if (cameras == null) return;

    isFront = !isFront;

    final cam = cameras!.firstWhere(
          (c) => c.lensDirection ==
          (isFront ? CameraLensDirection.front : CameraLensDirection.back),
      orElse: () => cameras!.first,
    );

    controller = CameraController(
      cam,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  Future<void> _captureImage() async {
    if (!(controller?.value.isInitialized ?? false)) return;

    final img = await controller!.takePicture();

    setState(() {
      capturedImage = File(img.path);
      galleryImage = null;
      selectedLanguage = null;
    });
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        galleryImage = File(img.path);
        capturedImage = null;
        selectedLanguage = null;
      });
    }
  }

  Widget _cameraBox() {
    final h = MediaQuery.of(context).size.height * 0.70;
    final w = MediaQuery.of(context).size.width - 26;

    return Center(
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // LIVE CAMERA
              if (activeImage == null)
                (controller != null &&
                    controller!.value.isInitialized)
                    ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller!.value.previewSize!.width,
                    height: controller!.value.previewSize!.height,
                    child: CameraPreview(controller!),
                  ),
                )
                    : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              else
              // GALLERY / CAPTURED IMAGE
                Image.file(activeImage!, fit: BoxFit.cover),

              if (activeImage == null)
                _grid(),

              if (activeImage == null)
                Positioned(
                  top: 16,
                  left: 16,
                  child: _glassBtn(
                    icon: flashOn ? Icons.flash_on : Icons.flash_off,
                    onTap: _toggleFlash,
                  ),
                ),

              if (activeImage == null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _glassBtn(
                    icon: Icons.cameraswitch_rounded,
                    onTap: _switchCamera,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassBtn({required IconData icon, required VoidCallback onTap}) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
              border: Border.all(color: Colors.white30),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          for (int i = 1; i < 3; i++)
            Positioned(
              top: c.maxHeight * (i / 3),
              left: 0,
              right: 0,
              child: Container(height: 1, color: Colors.white24),
            ),
          for (int i = 1; i < 3; i++)
            Positioned(
              left: c.maxWidth * (i / 3),
              top: 0,
              bottom: 0,
              child: Container(width: 1, color: Colors.white24),
            ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _pickFromGallery,
                child: _circleBtn(Icons.photo, Colors.purpleAccent),
              ),
              GestureDetector(
                onTap: () {
                  if (activeImage == null) {
                    _captureImage();
                  } else {
                    setState(() {
                      capturedImage = null;
                      galleryImage = null;
                      selectedLanguage = null;
                    });
                  }
                },
                child: ScaleTransition(
                  scale: glowController,
                  child: _captureBtn(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (activeImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Capture or select an image first.")),
                    );
                    return;
                  }
                  _openLanguagePicker();
                },
                child: _circleBtn(Icons.language, Colors.greenAccent),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Opacity(
            opacity: selectedLanguage == null ? 0.4 : 1,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedLanguage == null
                    ? null
                    : () {
                  Navigator.pushNamed(
                    context,
                    "/output",
                    arguments: {
                      "image": activeImage!.path,
                      "language": selectedLanguage,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  "Transliterate",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(icon, size: 26, color: Colors.white),
    );
  }

  Widget _captureBtn() {
    final icon = activeImage == null ? Icons.camera_alt : Icons.refresh;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Colors.cyan, Colors.blueAccent],
        ),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  void _openLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          children: [
            for (final lang in ["Hindi", "Marathi", "Tamil", "Telugu"])
              ListTile(
                title: Text(lang, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() => selectedLanguage = lang);
                  Navigator.pop(context);
                },
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A30),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _cameraBox(),
            _bottomBar(),
          ],
        ),
      ),
    );
  }
}
