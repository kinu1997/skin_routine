import 'package:flutter/material.dart';

import '../utils/storage_helper.dart';
import '../widgets/line_chart.dart';

class StreaksScreen extends StatefulWidget {
  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  int streakDays = 0;

  @override
  void initState() {
    super.initState();
    loadStreak();
  }

  Future<void> loadStreak() async {
    int storedStreak = await StorageHelper.getStreak();
    setState(() {
      streakDays = storedStreak;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("Streaks")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Goal: ${streakDays + 1} streak days", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Streak Days", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                    SizedBox(height: 5),
                    Text(streakDays.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Daily Streak", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              SizedBox(height: 5),
              Text(streakDays.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink)),
              SizedBox(height: 10),
              Text("Last 30 Days +100%", style: TextStyle(color: Colors.green)),
              SizedBox(height: 20),
              StreakChart(),
              SizedBox(height: 10),
              Text("Keep it up! You're on a roll.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),


              SizedBox(height: 10),
              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => RoutineScreen()));
                    },
                    child: Text("Get Started"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
