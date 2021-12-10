import 'dart:async';

import 'package:audio_player/tracks.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
            () => Navigator.push(context,MaterialPageRoute(builder: (context) => Tracks())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Image.asset("assets/670540040.png")
            ]
        )
    );
  }
}

