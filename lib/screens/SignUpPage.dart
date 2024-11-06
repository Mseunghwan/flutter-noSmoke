import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _nickname = '';
  String _phoneNumber = '';
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
          // Animated Background (로그인 페이지와 동일)
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
                    const SizedBox(height: 40),
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
                        size: 60,
                        color: Colors.blue[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '회원가입',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '금연 실천과 후원으로\n더 나은 세상을 만들어보세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Signup Form with Glass Effect
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
                                  hint: '닉네임',
                                  icon: Icons.person_outline,
                                  onChanged: (v) => _nickname = v,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '닉네임을 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  hint: '이메일',
                                  icon: Icons.email_outlined,
                                  onChanged: (v) => _email = v,
                                  validator: (value) {
                                    if (value == null || !value.contains('@')) {
                                      return '올바른 이메일 주소를 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  hint: '비밀번호',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  onChanged: (v) => _password = v,
                                  validator: (value) {
                                    if (value == null || value.length < 6) {
                                      return '비밀번호는 6자 이상이어야 합니다';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  hint: '비밀번호 확인',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  onChanged: (v) => _confirmPassword = v,
                                  validator: (value) {
                                    if (value != _password) {
                                      return '비밀번호가 일치하지 않습니다';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                _buildSignUpButton(),
                                const SizedBox(height: 16),
                                _buildLoginLink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      obscureText: isPassword,
      onChanged: onChanged,
      validator: validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red[300]!),
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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // 회원가입 처리 로직
            // TODO: Implement signup functionality
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

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이미 계정이 있으신가요?',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '로그인',
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// BackgroundPainter 클래스는 로그인 페이지와 동일하게 사용
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