import 'package:flutter/material.dart';
import 'homepage.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToMusicPlayer();
  }

  _navigateToMusicPlayer() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PlaylistScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Welcome to Syntalix Music Player',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00FFA3),
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color(0xFFDC1FFF),
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}