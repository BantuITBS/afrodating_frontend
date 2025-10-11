import 'package:flutter/material.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text('Live Stream')),
      body: Center(child: Text('Live Stream UI (Agora RTC)', style: TextStyle(color: Colors.white))),
    );
  }
}