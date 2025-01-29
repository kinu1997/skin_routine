import 'package:flutter/material.dart';
import '../utils/storage_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  List<Map<String, dynamic>> skincareSteps = [
    {"title": "Cleanser", "subtitle": "Cetaphil Gentle Skin Cleanser"},
    {"title": "Toner", "subtitle": "Thayers Witch Hazel Toner"},
    {"title": "Moisturizer", "subtitle": "Kiehl's Ultra Facial Cream"},
    {"title": "Sunscreen", "subtitle": "Supergoop SPF 40"},
    {"title": "Lip Balm", "subtitle": "Glossier Birthday Balm Dotcom"},
  ];
  List<bool> completedSteps = [false, false, false, false, false];
  List<bool> videoRecordedSteps = [false, false, false, false, false];  // Track video recording status
  List<String> recordedTimes = ['', '', '', '', '']; // To store recorded times

  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermissions() async {
    PermissionStatus cameraPermission = await Permission.camera.request();
    PermissionStatus microphonePermission = await Permission.microphone.request();

    if (cameraPermission.isGranted && microphonePermission.isGranted) {
      // You can proceed with recording after permissions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera and/or Microphone permissions are required.")),
      );
    }
  }

  Future<void> _pickVideo(int index) async {
    // Open video picker using the ImagePicker package
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      String currentTime = DateFormat('h:mm a').format(DateTime.now());  // Format the current time
      recordedTimes[index] = currentTime;  // Store the time of the video recording
      videoRecordedSteps[index] = true;  // Mark video as recorded

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video recorded for ${skincareSteps[index]['title']}")),
      );

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No video recorded.")),
      );
    }
  }

  void _markStepCompleted(int index) async {
    if (videoRecordedSteps[index]) {
      setState(() {
        completedSteps[index] = true;
      });

      await StorageHelper.saveRoutine(completedSteps);

      if (completedSteps.every((step) => step)) {
        await StorageHelper.increaseStreak();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🔥 Streak Increased! Keep it up!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please record the video before marking the step as completed.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadRoutine();
  }

  Future<void> _loadRoutine() async {
    List<bool> savedSteps = await StorageHelper.loadRoutine(5);
    setState(() {
      completedSteps = savedSteps;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Daily Skincare"),
      ),
      body: ListView.builder(
        itemCount: skincareSteps.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: completedSteps[index],
              onChanged: (_) {
                _markStepCompleted(index);
              },
            ),
            title: Text(skincareSteps[index]['title'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(skincareSteps[index]['subtitle']),
            trailing: SizedBox(
              width: 120, // Adjust width as needed
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,// Prevents Row from taking full width
                children: [
                  IconButton(
                    onPressed: () => _pickVideo(index),
                    icon: Icon(Icons.camera_alt),
                  ),
                  Text(recordedTimes[index].isNotEmpty ? recordedTimes[index] : "--:--"),

                ],
              ),
            ),

          );
        },
      ),
    );
  }
}
