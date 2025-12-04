import 'package:flutter/material.dart';
import '../../widgets/animated_avatar.dart';
import '../../widgets/animated_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header with hero avatar
            AnimatedCard(
              delay: const Duration(milliseconds: 60),
              child: Row(
                children: [
                  AnimatedAvatar(
                    heroTag: 'profile-avatar',
                    radius: 48,
                    child: const Icon(Icons.person, color: Colors.white, size: 44),
                    onTap: () {
                      // hero to a full-screen avatar view if needed
                    },
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Rohit Pawar", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text("Cyclist • Trekker • Engineer", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      // open edit page - use AnimatedRoute for a hero edit effect if you like
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 22),

            AnimatedCard(delay: const Duration(milliseconds: 120), child: _infoRow(Icons.email, "Email", "rohitpawar@gmail.com")),
            const SizedBox(height: 14),
            AnimatedCard(delay: const Duration(milliseconds: 180), child: _infoRow(Icons.phone, "Phone", "+91 7058341901")),
            const SizedBox(height: 14),
            AnimatedCard(delay: const Duration(milliseconds: 240), child: _infoRow(Icons.location_on, "Location", "India")),

            const SizedBox(height: 30),
            Align(alignment: Alignment.centerLeft, child: Text("App Settings", style: TextStyle(color: Colors.white70, fontSize: 15))),

            const SizedBox(height: 12),
            AnimatedCard(delay: const Duration(milliseconds: 300), child: _settingsRow(Icons.lock, "Privacy Settings")),
            const SizedBox(height: 12),
            AnimatedCard(delay: const Duration(milliseconds: 360), child: _settingsRow(Icons.palette, "Theme & Appearance")),
            const SizedBox(height: 12),
            AnimatedCard(delay: const Duration(milliseconds: 420), child: _settingsRow(Icons.notifications, "Notifications")),

            const SizedBox(height: 30),
            AnimatedCard(delay: const Duration(milliseconds: 480), child: _settingsRow(Icons.share, "Share App")),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, minimumSize: const Size.fromHeight(56)), child: const Text("Logout")),
            const SizedBox(height: 12),
            Text("Version 1.0.0", style: TextStyle(color: Colors.white54))
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: Colors.white70)), const SizedBox(height:4), Text(subtitle, style: const TextStyle(color: Colors.white))])
      ],
    );
  }

  Widget _settingsRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(width: 14),
        Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
        const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16)
      ],
    );
  }
}
