import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassesTab extends StatelessWidget {
  const ClassesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Classes",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, // Filter action
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Active Classes Section
          SectionLabel(label: "Active"),
          SizedBox(height: 12),
          ClassListItem(
            title: "Python Basics (Batch A)",
            days: "Mon, Wed • 10:00 AM",
            instructor: "Dr. Smith",
            progress: 0.45,
            statusColor: Colors.green,
            statusText: "On Track",
          ),
          SizedBox(height: 16),
          ClassListItem(
            title: "Web Development Bootcamp",
            days: "Tue, Thu • 2:00 PM",
            instructor: "Prof. Johnson",
            progress: 0.1,
            statusColor: Colors.orange,
            statusText: "Behind",
          ),

          SizedBox(height: 32),

          // Completed / Archived Section
          SectionLabel(label: "Past"),
          SizedBox(height: 12),
          ClassListItem(
            title: "Intro to CS",
            days: "Completed",
            instructor: "Dr. Smith",
            progress: 1.0,
            statusColor: Colors.grey,
            statusText: "Completed",
            isCompleted: true,
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade500,
        letterSpacing: 1.0,
      ),
    );
  }
}

class ClassListItem extends StatelessWidget {
  final String title;
  final String days;
  final String instructor;
  final double progress;
  final Color statusColor;
  final String statusText;
  final bool isCompleted;

  const ClassListItem({
    super.key,
    required this.title,
    required this.days,
    required this.instructor,
    required this.progress,
    required this.statusColor,
    required this.statusText,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon / Thumbnail
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.grey.shade100 : const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle_outline : Icons.class_outlined,
                    color: isCompleted ? Colors.grey : const Color(0xFF4D7CFE),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isCompleted ? Colors.grey.shade700 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        instructor,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            days,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                           Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              statusText,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!isCompleted) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress < 0.3 ? Colors.orange : const Color(0xFF4D7CFE),
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
