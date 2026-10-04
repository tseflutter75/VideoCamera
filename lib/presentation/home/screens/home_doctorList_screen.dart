import 'package:flutter/material.dart';
import 'package:videocall/app/url.dart';
import 'package:videocall/core/services/network_caller.dart';
import 'package:videocall/presentation/auth/presentation/AuthController.dart';
import 'package:videocall/presentation/home/screens/calling_received_screen.dart';
import 'package:videocall/presentation/home/screens/incoming_call_screen.dart';
import 'package:videocall/presentation/home/screens/model/phonebook_model.dart';

import 'package:flutter/material.dart';

// import 'path_to_calling_screen/calling_received_screen.dart';

class DoctorListScreen extends StatefulWidget {
  final int fromTabIndex;
  const DoctorListScreen({super.key, this.fromTabIndex = 0});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<PhoneBookModel> _doctorList = [];
  bool inprogressDoctorList = false;

  // Doctor List Get API (Phonebook API স্ট্রাকচার ব্যবহার করে)
  Future<void> _getDoctorList() async {
    inprogressDoctorList = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls
          .phonebookUrl, // প্রয়োজনমতো ডাক্তারের আলাদা এন্ডপয়েন্ট ইউআরএল এখানে বসাতে পারেন
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final doctorData = response.responseData;

      for (Map<String, dynamic> doctorJson in doctorData['data']) {
        final doctorModel = PhoneBookModel.fromJson(doctorJson);
        _doctorList.add(doctorModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    if (mounted) {
      inprogressDoctorList = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getDoctorList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(
        0xFF121212,
      ), // মেডিকেল ভিডিও অ্যাপের জন্য প্রিমিয়াম ডার্ক থিম
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Get.offAll(() => BottomNavControllerScreen());
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          "Doctor Consultation List",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Visibility(
        visible: inprogressDoctorList == false,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            16,
            100,
            16,
            16,
          ), // AppBar এর নিচে স্পেস রাখার জন্য
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 14),
          itemCount: _doctorList.length,
          itemBuilder: (context, index) {
            var doctor = _doctorList[index];

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Doctor Profile Image with Online Status Indicator
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: doctor.image.isEmpty
                              ? Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey.shade800,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white70,
                                    size: 40,
                                  ),
                                )
                              : Image.network(
                                  Uri.encodeFull(doctor.image!),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.grey.shade800,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white70,
                                          size: 40,
                                        ),
                                      ),
                                ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF1E1E1E),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Doctor Info (Name, Designation, Department)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.employeename,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            doctor.designation,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doctor.department,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00BFA5).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Available for Video Call",
                              style: TextStyle(
                                color: Color(0xFF00BFA5),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Video Call Trigger Button
                    Material(
                      color: const Color(0xFF00BFA5),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // String uniqueChannelName =
                          //     "demo-channel_${doctor.id}";
                          String uniqueChannelName = "demo-channel";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallingReceivedScreen(
                                channelName: uniqueChannelName,
                                employeeName: doctor.employeename,
                                employeeMobile: doctor.mobile,
                                employeeImage: doctor.image,
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.videocam_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: // Nahid- er Dashboard / Home Screen- e ei button- ti add kore dite paren:
      FloatingActionButton.extended(
        onPressed: () {
          // Nahid er screen theke manually incoming call trigger korlam
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IncomingCallScreen(
                channelName:
                    "demo-channel", // Sadman je channel e ase, ekhane o setai thakbe
                callerName: "Al Amin Hoque",
                callerMobile: "01552490396",
                callerImage:
                    "https://software.digonta.space/storage/images/1767082242_WhatsApp Image 2024-12-19 at 5.07.30 PM.jpeg",
              ),
            ),
          );
        },
        backgroundColor: Colors.orange,
        label: const Text("Test Incoming Call"),
        icon: Icon(Icons.phone_in_talk_outlined),
      ),
    );
  }
}
