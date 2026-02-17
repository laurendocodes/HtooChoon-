import 'package:flutter/material.dart';

class LiveSessionListScreen extends StatelessWidget {
  final String classId;
  const LiveSessionListScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    // Mock live sessions
    final sessions = [
      {
        'title': 'Chapter 4 Review',
        'startTime': DateTime.now().add(const Duration(hours: 2)),
        'status': 'upcoming',
      },
      {
        'title': 'Project Discussion',
        'startTime': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'ended',
      },
    ];

    if (sessions.isEmpty) {
      return const Center(child: Text("No live sessions scheduled."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final status = session['status'] as String;
        final isUpcoming = status == 'upcoming';

        return Card(
          elevation: isUpcoming ? 2 : 0,
          color: isUpcoming
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).scaffoldBackgroundColor,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUpcoming
                    ? Colors.red.withOpacity(0.1)
                    : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.videocam,
                color: isUpcoming ? Colors.red : Colors.grey,
              ),
            ),
            title: Text(
              session['title'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUpcoming ? Colors.black : Colors.grey,
              ),
            ),
            subtitle: Text(
              isUpcoming ? 'Starts in 2 hours' : 'Ended yesterday',
            ),
            trailing: isUpcoming
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Join'),
                  )
                : const Chip(label: Text('Ended')),
          ),
        );
      },
    );
  }
}
