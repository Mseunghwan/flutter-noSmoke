import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math; // 추가된 부분
import 'package:stop_smoke/screens/UserSettingPage.dart'; // UserSettingsPage import

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _nickname = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(animation: _animation.value),
                );
              },
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
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
                      '회원가입',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSignUpForm(),
                    const SizedBox(height: 24),
                    _buildLoginLink(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            hint: '닉네임',
            icon: Icons.person_outline,
            onChanged: (v) => _nickname = v,
          ),
          const SizedBox(height: 16),
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
          _buildSignUpButton(),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 입력사항입니다';
        }
        return null;
      },
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

  Widget _buildSignUpButton() {
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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Firebase Auth에 사용자 등록
              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _email,
                password: _password,
              );

              // Firestore에 사용자 정보 저장
              await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                'email': _email,
                'nickname': _nickname,
                'start_date': Timestamp.now(),
                'daily_smoking_amount': 0, // 초기값 설정
                'total_money_saved': 0, // 초기값 설정
              });

              // 사용자 설정 페이지로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSettingsPage(email: _email), // email 전달
                ),
              );
            } catch (e) {
              print('회원가입 실패: $e');
            }
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
          '회원가입',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '이미 계정이 있으신가요? 로그인하기',
            style: TextStyle(color: Colors.grey[600]),
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
