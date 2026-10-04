import 'package:flutter/material.dart';
import 'calling_received_screen.dart'; // Age je video screen banano hoise

class IncomingCallScreen extends StatelessWidget {
  final String channelName;
  final String callerName;
  final String callerMobile;
  final String callerImage;

  const IncomingCallScreen({
    super.key,
    required this.channelName,
    required this.callerName,
    required this.callerMobile,
    required this.callerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0B3E6B,
      ), // Apnar preferred deep blue color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Caller Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(callerImage),
              onBackgroundImageError: (_, __) =>
                  const Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 24),
            // Caller Name
            Text(
              callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Caller Mobile
            Text(
              callerMobile,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "Incoming Video Call...",
              style: TextStyle(
                color: Color(0xFF00BFA5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),

            // Accept and Decline Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Decline Button
                  FloatingActionButton(
                    heroTag: "decline_call",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      Navigator.pop(context); // Call কেটে দেওয়া
                    },
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // Accept Button
                  FloatingActionButton(
                    heroTag: "accept_call",
                    backgroundColor: Colors.green,
                    onPressed: () {
                      // Call Accept kore CallingReceivedScreen- e chole jabe
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallingReceivedScreen(
                            channelName: channelName,
                            employeeName: callerName,
                            employeeMobile: callerMobile,
                            employeeImage: callerImage,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
