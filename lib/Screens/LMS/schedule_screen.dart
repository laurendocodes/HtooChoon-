import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDateHeader(context, "Today, Oct 24"),
          _buildScheduleItem(
            context,
            time: "09:00 AM",
            title: "Advanced Math Live Session",
            type: "Live",
            color: Colors.red,
          ),
          _buildScheduleItem(
            context,
            time: "02:00 PM",
            title: "History Essay Due",
            type: "Assignment",
            color: Colors.blue,
          ),

          const SizedBox(height: 24),
          _buildDateHeader(context, "Tomorrow, Oct 25"),
          _buildScheduleItem(
            context,
            time: "10:00 AM",
            title: "Physics Lab",
            type: "Class",
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        date,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required String time,
    required String title,
    required String type,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.only(
        //   left: BorderSide(color: color, width: 4),
        //   top: BorderSide(color: Colors.grey.shade200),
        //   right: BorderSide(color: Colors.grey.shade200),
        //   bottom: BorderSide(color: Colors.grey.shade200),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
