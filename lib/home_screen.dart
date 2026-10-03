import 'package:flutter/material.dart';
import 'package:videocall/calling_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 235, 197),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallingScreen()),
                );
              },
              icon: Icon(
                Icons.video_call,
                color: const Color.fromARGB(255, 0, 77, 3),
                size: 90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
