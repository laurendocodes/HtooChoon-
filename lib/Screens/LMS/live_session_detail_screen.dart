import 'package:flutter/material.dart';

class LiveSessionDetailScreen extends StatelessWidget {
  final String title;
  final DateTime startTime;
  final String status;

  const LiveSessionDetailScreen({
    super.key,
    required this.title,
    required this.startTime,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;
    Color color;

    if (status == 'live') {
      message = "Session is Live!";
      icon = Icons.videocam;
      color = Colors.red;
    } else if (status == 'upcoming') {
      message = "Starting soon";
      icon = Icons.calendar_today;
      color = Colors.blue;
    } else {
      message = "Session Ended";
      icon = Icons.history;
      color = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Live Session")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(message, style: TextStyle(fontSize: 18, color: color)),
              const SizedBox(height: 48),
              if (status == 'live' || status == 'upcoming')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Launch meeting link logic (e.g. url_launcher)
                    },
                    icon: const Icon(Icons.launch),
                    label: const Text("Join Meeting"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: status == 'live'
                          ? Colors.red
                          : Colors.blue,
                      foregroundColor: Colors.white,
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
