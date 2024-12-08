import 'package:flutter/material.dart';
import 'homepage.dart';
import 'miniplayer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'splash_screen.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: SplashScreenPage(),
    );
  }
}