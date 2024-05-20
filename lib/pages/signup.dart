import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Let\'s Get',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.left,
            ),
            const Text(
              'Started',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.start,
            ),
            Container(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
