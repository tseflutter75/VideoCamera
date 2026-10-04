import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videocall/app/utils.dart';

class CallingReceivedScreen extends StatefulWidget {
  final String channelName;
  final String employeeName;
  final String employeeMobile;
  final String employeeImage;

  const CallingReceivedScreen({
    super.key,
    required this.channelName,
    required this.employeeName,
    required this.employeeMobile,
    required this.employeeImage,
  });

  @override
  State<CallingReceivedScreen> createState() => _CallingReceivedScreenState();
}

class _CallingReceivedScreenState extends State<CallingReceivedScreen> {
  late RtcEngine _engine;
  bool _isJoined = false;
  int? _remoteUid;
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // Permission check
    await [Permission.microphone, Permission.camera].request();

    // Create Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    // Register event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              setState(() {
                _remoteUid = null;
              });
            },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    // Join channel
    await _engine.joinChannel(
      token: rtcToken,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  // Toggle Mute Audio
  void _onToggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  // Toggle Video Off/On
  void _onToggleVideo() {
    setState(() {
      _isVideoOff = !_isVideoOff;
    });
    _engine.muteLocalVideoStream(_isVideoOff);
  }

  // Switch Camera (Front/Back)
  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Remote User Video (Full Screen) or Connecting View with Employee Info
          Center(
            child: _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: widget.channelName),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Employee Profile Avatar while connecting
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.employeeImage),
                        onBackgroundImageError: (_, __) =>
                            const Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.employeeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.employeeMobile,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const CircularProgressIndicator(color: Color(0xFF00BFA5)),
                      const SizedBox(height: 12),
                      const Text(
                        "Connecting...",
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
          ),

          // Top App Bar Details (Name overlay when video is connected)
          if (_remoteUid != null)
            Positioned(
              top: 50,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(widget.employeeImage),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.employeeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 2. Local User Video Preview (Top Right Floating Box)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 110,
              height: 150,
              margin: const EdgeInsets.fromLTRB(0, 50, 16, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isJoined && !_isVideoOff
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.videocam_off,
                          color: Colors.white54,
                        ),
                      ),
              ),
            ),
          ),

          // 3. Call Control Bottom Toolbar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 36),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mute Button
                  IconButton(
                    onPressed: _onToggleMute,
                    icon: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.red : Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // End Call Button
                  RawMaterialButton(
                    onPressed: () => Navigator.pop(context),
                    elevation: 2.0,
                    fillColor: Colors.red,
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Video Camera Toggle
                  IconButton(
                    onPressed: _onToggleVideo,
                    icon: Icon(
                      _isVideoOff ? Icons.videocam_off : Icons.videocam,
                      color: _isVideoOff ? Colors.red : Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Switch Camera Button
                  IconButton(
                    onPressed: _onSwitchCamera,
                    icon: const Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class CallingReceivedScreen extends StatefulWidget {
//   final String channelName;
//   const CallingReceivedScreen({super.key, required this.channelName});

//   @override
//   State<CallingReceivedScreen> createState() => _CallingReceivedScreenState();
// }

// class _CallingReceivedScreenState extends State<CallingReceivedScreen> {
//   late RtcEngine _engine;
//   bool _isJoined = false;
//   int? _remoteUid;
//   bool _isMuted = false;
//   bool _isVideoOff = false;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     // Permission check
//     await [Permission.microphone, Permission.camera].request();

//     // Create Agora engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(
//       const RtcEngineContext(
//         appId: agoraAppId,
//         channelProfile: ChannelProfileType.channelProfileCommunication,
//       ),
//     );

//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline:
//             (
//               RtcConnection connection,
//               int remoteUid,
//               UserOfflineReasonType reason,
//             ) {
//               setState(() {
//                 _remoteUid = null;
//               });
//             },
//       ),
//     );

//     await _engine.enableVideo();
//     await _engine.startPreview();

//     // Join channel
//     await _engine.joinChannel(
//       token: "",
//       channelId: widget.channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }

//   // Toggle Mute Audio
//   void _onToggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//     });
//     _engine.muteLocalAudioStream(_isMuted);
//   }

//   // Toggle Video Off/On
//   void _onToggleVideo() {
//     setState(() {
//       _isVideoOff = !_isVideoOff;
//     });
//     _engine.muteLocalVideoStream(_isVideoOff);
//   }

//   // Switch Camera (Front/Back)
//   void _onSwitchCamera() {
//     _engine.switchCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // 1. Remote User Video (Full Screen)
//           Center(
//             child: _remoteUid != null
//                 ? AgoraVideoView(
//                     controller: VideoViewController.remote(
//                       rtcEngine: _engine,
//                       canvas: VideoCanvas(uid: _remoteUid),
//                       connection: RtcConnection(channelId: widget.channelName),
//                     ),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       CircularProgressIndicator(color: Color(0xFF00BFA5)),
//                       SizedBox(height: 16),
//                       Text(
//                         "Connecting with Doctor...",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ],
//                   ),
//           ),

//           // 2. Local User Video Preview (Top Right Floating Box)
//           Align(
//             alignment: Alignment.topRight,
//             child: Container(
//               width: 110,
//               height: 150,
//               margin: const EdgeInsets.fromLTRB(0, 50, 16, 0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.white24, width: 1.5),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: _isJoined && !_isVideoOff
//                     ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: _engine,
//                           canvas: const VideoCanvas(uid: 0),
//                         ),
//                       )
//                     : Container(
//                         color: Colors.grey[900],
//                         child: const Icon(
//                           Icons.videocam_off,
//                           color: Colors.white54,
//                         ),
//                       ),
//               ),
//             ),
//           ),

//           // 3. Call Control Bottom Toolbar
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 36),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(color: Colors.white12),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Mute Button
//                   IconButton(
//                     onPressed: _onToggleMute,
//                     icon: Icon(
//                       _isMuted ? Icons.mic_off : Icons.mic,
//                       color: _isMuted ? Colors.red : Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 20),

//                   // End Call Button
//                   RawMaterialButton(
//                     onPressed: () => Navigator.pop(context),
//                     elevation: 2.0,
//                     fillColor: Colors.red,
//                     padding: const EdgeInsets.all(15.0),
//                     shape: const CircleBorder(),
//                     child: const Icon(
//                       Icons.call_end,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                   const SizedBox(width: 20),

//                   // Video Camera Toggle
//                   IconButton(
//                     onPressed: _onToggleVideo,
//                     icon: Icon(
//                       _isVideoOff ? Icons.videocam_off : Icons.videocam,
//                       color: _isVideoOff ? Colors.red : Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 20),

//                   // Switch Camera Button
//                   IconButton(
//                     onPressed: _onSwitchCamera,
//                     icon: const Icon(
//                       Icons.switch_camera,
//                       color: Colors.white,
//                       size: 28,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
