import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CallingReceivedScreen extends StatefulWidget {
  const CallingReceivedScreen({super.key});

  @override
  State<CallingReceivedScreen> createState() => _CallingReceivedScreenState();
}

class _CallingReceivedScreenState extends State<CallingReceivedScreen> {
  XFile? cameraVideo;
  final ImagePicker image = ImagePicker();

  Future<void> videoCam() async {
    cameraVideo = await image?.pickVideo(source: ImageSource.camera);

    if (cameraVideo != null) {
      print("Video path: ${cameraVideo!.path}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    videoCam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [

          
        ],
      ));
  }
}
