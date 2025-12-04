import 'package:flutter/material.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  bool passVisible = false;
  bool confirmVisible = false;

  String? emailError;
  String? passError;
  String? confirmError;

  late AnimationController fadeCtrl;
  late AnimationController slideCtrl;

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

    fadeCtrl.forward();
    slideCtrl.forward();
  }

  void validateAndRegister() {
    setState(() {
      emailError = null;
      passError = null;
      confirmError = null;
    });

    if (!emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      setState(() => emailError = "Enter a valid email");
      return;
    }

    if (passController.text.length < 6) {
      setState(() => passError = "Password must be at least 6 characters");
      return;
    }

    if (passController.text != confirmController.text) {
      setState(() => confirmError = "Passwords do not match");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
        opacity: fadeCtrl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
          child: SingleChildScrollView(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: slideCtrl,
                curve: Curves.easeOutBack,
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Register and join AksharSetu",
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),

                  const SizedBox(height: 40),

                  glassField(
                    controller: emailController,
                    label: "Email",
                    obscure: false,
                    icon: Icons.email,
                    errorText: emailError,
                  ),

                  const SizedBox(height: 22),

                  glassField(
                    controller: passController,
                    label: "Password",
                    obscure: !passVisible,
                    icon: Icons.lock_outline,
                    errorText: passError,
                    suffix: IconButton(
                      icon: Icon(
                        passVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() => passVisible = !passVisible),
                    ),
                  ),

                  const SizedBox(height: 22),

                  glassField(
                    controller: confirmController,
                    label: "Confirm Password",
                    obscure: !confirmVisible,
                    icon: Icons.lock_outline,
                    errorText: confirmError,
                    suffix: IconButton(
                      icon: Icon(
                        confirmVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () =>
                          setState(() => confirmVisible = !confirmVisible),
                    ),
                  ),

                  const SizedBox(height: 35),

                  GestureDetector(
                    onTap: validateAndRegister,
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
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
