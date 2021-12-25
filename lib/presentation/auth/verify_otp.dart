import 'package:flutter/material.dart';

class VerifyOTPScreen extends StatelessWidget {
  final bool isSignup;

  const VerifyOTPScreen({Key? key, required this.isSignup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Verify OTP Screen'),
      ),
    );
  }
}
