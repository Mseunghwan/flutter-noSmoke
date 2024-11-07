import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stop_smoke/screens/SignUpPage.dart';
import 'package:stop_smoke/main.dart';
import 'dart:ui';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );
      // 로그인 성공 시 홈 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // 로그인 실패 시 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(
                    animation: _animation.value,
                  ),
                );
              },
            ),
          ),
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Logo Animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.eco,
                        size: 80,
                        color: Colors.blue[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Green Impact',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '금연으로 시작하는 작은 변화,\n함께 만드는 더 나은 미래',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Login Form with Glass Effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  hint: '이메일',
                                  icon: Icons.email_outlined,
                                  onChanged: (v) => _email = v,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  hint: '비밀번호',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  onChanged: (v) => _password = v,
                                ),
                                const SizedBox(height: 24),
                                _buildLoginButton(),
                                const SizedBox(height: 20),
                                _buildDivider(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildBottomLinks(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      obscureText: isPassword,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue[600]!),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[300]!.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _signIn(); // Firebase 로그인 메서드 호출
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          '로그인',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '또는',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildBottomLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            '비밀번호를 잊으셨나요?',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Text('•', style: TextStyle(color: Colors.grey[600])),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: Text(
            '회원가입',
            style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animation;

  BackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[100]!.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();
    final y1 = math.sin(animation * 2 * math.pi) * 50;
    final y2 = math.cos(animation * 2 * math.pi) * 50;

    path.moveTo(0, size.height * 0.8 + y1);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.7 + y2,
      size.width * 0.5,
      size.height * 0.8 + y1,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9 + y2,
      size.width,
      size.height * 0.8 + y1,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
