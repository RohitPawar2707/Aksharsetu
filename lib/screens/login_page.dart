import 'package:flutter/material.dart';
import 'loading_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _passwordVisible = false;
  String? emailError;
  String? passwordError;

  late AnimationController fadeCtrl;
  late AnimationController slideCtrl;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeCtrl,
      curve: Curves.easeOut,
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: slideCtrl, curve: Curves.easeOutBack),
    );

    fadeCtrl.forward();
    slideCtrl.forward();
  }

  void validateAndLogin() {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (!emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      setState(() => emailError = "Enter a valid email");
      return;
    }

    if (passController.text.length < 6) {
      setState(() => passwordError = "Password must be at least 6 characters");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoadingPage()),
    );
  }

  Widget glassField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required IconData icon,
    String? errorText,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          errorText: errorText,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),

      body: FadeTransition(
        opacity: fadeAnim,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: SlideTransition(
              position: slideAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 40),

                  // ⭐ Animated Welcome
                  Row(
                    children: const [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text("👋", style: TextStyle(fontSize: 32)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Login to your AksharSetu account",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),

                  const SizedBox(height: 45),

                  // ⭐ EMAIL FIELD
                  glassField(
                    controller: emailController,
                    label: "Email",
                    obscure: false,
                    icon: Icons.email_outlined,
                    errorText: emailError,
                  ),

                  const SizedBox(height: 22),

                  // ⭐ PASSWORD FIELD
                  glassField(
                    controller: passController,
                    label: "Password",
                    obscure: !_passwordVisible,
                    icon: Icons.lock_outline,
                    errorText: passwordError,
                    suffix: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ⭐ LOGIN BUTTON (GRADIENT)
                  GestureDetector(
                    onTap: validateAndLogin,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ⭐ SIGN UP LINK
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Don’t have an account? Sign Up",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
