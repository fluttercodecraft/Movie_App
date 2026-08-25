import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_hub/Ui/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Movie Icon
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.movie_rounded,
                color: Colors.white,
                size: 55,
              ),
            ),

            const SizedBox(height: 25),

            // App Name
            const Text(
              'MovieHub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Discover your next favorite movie',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),

            const SizedBox(height: 35),

            // Loading Indicator
            const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFE50914),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
