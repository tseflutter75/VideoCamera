import 'package:flutter/material.dart';
import 'package:videocall/calling_received_screen.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 156, 235, 197),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?q=80&w=689&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            height: 250,
            width: 250,
          ),

          SizedBox(height: 30),

          Center(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.call_end, size: 65, color: Colors.red),
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallingReceivedScreen(),
                ),
              );
            },
            icon: Icon(Icons.call_received, size: 65, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
