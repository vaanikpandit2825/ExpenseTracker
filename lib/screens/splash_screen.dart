import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: RadialGradient(
                  colors: [
                    const Color.fromARGB(255, 178, 2, 187).withOpacity(0.6),
                    const Color.fromARGB(255, 169, 1, 177).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.6, 1.0],
                ),
              ),
            ),
            Image.asset(
              'assets/images/splash_Screen.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
