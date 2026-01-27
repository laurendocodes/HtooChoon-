import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.userData;

    if (userProvider.isLoading && user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text("Unable to load profile"));
    }

    // Notion-like: Clean lists, minimalist headers, soft interactions
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.school_rounded,
              size: 24,
              color: Color(0xFF4D7CFE),
            ),
            const SizedBox(width: 8),
            Text(
              "HtooChoon",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Text(
              'Good Afternoon, ${user['name'] ?? user['username'] ?? 'Unknown User'}',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Here's what's on your schedule today.",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            // "Up Next" / Active Class Card
            _SectionHeader(title: "Up Next"),
            const SizedBox(height: 12),
            _ClassCard(
              title: "Python for Beginners",
              time: "10:00 AM - 11:30 AM",
              status: "Live Now",
              isLive: true,
            ),

            const SizedBox(height: 32),

            // "Quick Access" / Recent
            _SectionHeader(title: "Quick Access"),
            const SizedBox(height: 12),
            Row(
              children: [
                _QuickActionChip(
                  label: "Assignments",
                  icon: Icons.assignment_outlined,
                ),
                const SizedBox(width: 8),
                _QuickActionChip(
                  label: "Recordings",
                  icon: Icons.video_library_outlined,
                ),
                const SizedBox(width: 8),
                _QuickActionChip(label: "Grades", icon: Icons.grade_outlined),
              ],
            ),

            const SizedBox(height: 32),

            // "News & Announcements"
            _SectionHeader(title: "Announcements"),
            const SizedBox(height: 12),
            _AnnouncementCard(
              title: "Exam Schedule Released",
              date: "2 hours ago",
              preview:
                  "The final exam schedule for the Fall semester has been posted...",
            ),
            const SizedBox(height: 12),
            _AnnouncementCard(
              title: "New Python Material",
              date: "Yesterday",
              preview: "Instructor uploaded 'Advanced list comprehensions'...",
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: Colors.grey.shade500,
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final bool isLive;

  const _ClassCard({
    required this.title,
    required this.time,
    required this.status,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isLive ? const Color(0xFFFEF2F2) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.code,
              color: isLive ? Colors.red : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "LIVE",
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _QuickActionChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF4D7CFE)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final String preview;

  const _AnnouncementCard({
    required this.title,
    required this.date,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
