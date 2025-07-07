import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please sign in.'),
              backgroundColor: Colors.green,
            ),
          );
          // Wait for 2 seconds to show the message
          await Future.delayed(const Duration(seconds: 2));
          // Navigate to sign-in page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF170101), Color(0xFF4B326F), Color(0xFF0C1531)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 80.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GET STARTED NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 50),
                  _buildLabel('name'),
                  const SizedBox(height: 8),
                  _buildTextFormField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('email address'),
                  const SizedBox(height: 8),
                  _buildTextFormField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('password'),
                  const SizedBox(height: 8),
                  _buildTextFormField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildSignUpButton(),
                  const SizedBox(height: 40),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildSocialLoginRow(),
                  const SizedBox(height: 40),
                  _buildSignInLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontFamily: 'Barlow',
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: _signUp,
      child: Container(
        width: double.infinity,
        height: 49,
        decoration: ShapeDecoration(
          color: const Color(0xFF834CFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Center(
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'ADLaM Display',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: Colors.white, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'ADLaM Display',
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('Google'),
        const SizedBox(width: 20),
        _buildSocialButton('Apple'),
      ],
    );
  }

  Widget _buildSocialButton(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            'Sign in with $text',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed('/sign-in');
      },
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'have an account already? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: 'sign in',
                style: TextStyle(
                  color: const Color(0xFF3DE95F),
                  fontSize: 15,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
