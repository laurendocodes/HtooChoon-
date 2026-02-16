import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Providers/student_clr_view_provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:htoochoon_flutter/lms/forms/screens/lms_home_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Run: flutter pub add shimmer

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = context.read<LoginProvider>();
      final classProvider = context.read<StudentClassroomProvider>();

      final user = loginProvider.firebaseUser;

      if (user != null) {
        final studentId = loginProvider.uid;
        classProvider.fetchJoinedClasses(studentId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'My Classes',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<StudentClassroomProvider>(
        builder: (_, provider, __) {
          if (provider.isLoadingClasses) {
            return const _ClassesLoadingSkeleton();
          }

          final activeClasses = provider.joinedClasses
              .where((c) => c['status'] != 'completed')
              .toList();

          final pastClasses = provider.joinedClasses
              .where((c) => c['status'] == 'completed')
              .toList();

          if (activeClasses.isEmpty && pastClasses.isEmpty) {
            return const Center(child: Text("No classes found."));
          }

          return ListView(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            children: [
              if (activeClasses.isNotEmpty) ...[
                const _SectionLabel(label: 'Active'),
                const SizedBox(height: AppTheme.spaceMd),
                ...activeClasses.map(
                  (classData) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                    child: _ClassListItem(
                      title: classData['name'] ?? '',
                      days:
                          "${classData['schedule']?['days']?.join(', ') ?? ''} • ${classData['schedule']?['time'] ?? ''}",
                      instructor: classData['teacherId'] ?? '',
                      progress: 0.4,
                      statusColor: AppTheme.success,
                      statusText: 'On Track',
                    ),
                  ),
                ),
              ],
              if (pastClasses.isNotEmpty) ...[
                const SizedBox(height: AppTheme.space2xl),
                const _SectionLabel(label: 'Past'),
                const SizedBox(height: AppTheme.spaceMd),
                ...pastClasses.map(
                  (classData) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                    child: _ClassListItem(
                      title: classData['name'] ?? '',
                      days: 'Completed',
                      instructor: classData['teacherId'] ?? '',
                      progress: 1.0,
                      statusColor: AppTheme.getTextTertiary(context),
                      statusText: 'Completed',
                      isCompleted: true,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ClassesLoadingSkeleton extends StatelessWidget {
  const _ClassesLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppTheme.borderRadiusLg,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppTheme.getTextTertiary(context),
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ClassListItem extends StatelessWidget {
  final String title;
  final String days;
  final String instructor;
  final double progress;
  final Color statusColor;
  final String statusText;
  final bool isCompleted;

  const _ClassListItem({
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
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> LmsHomeScreen(userId: userId, userRole: userRole, classId: )));
            // },
          },
          borderRadius: AppTheme.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.getSurfaceVariant(context)
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_outline
                        : Icons.class_outlined,
                    color: isCompleted
                        ? AppTheme.getTextSecondary(context)
                        : Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppTheme.getTextSecondary(context)
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space2xs),
                      Text(
                        instructor,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppTheme.getTextTertiary(context),
                          ),
                          const SizedBox(width: AppTheme.space2xs),
                          Text(
                            days,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.getTextSecondary(context),
                                  fontSize: 12,
                                ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceXs,
                              vertical: AppTheme.space2xs,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: AppTheme.borderRadiusSm,
                            ),
                            child: Text(
                              statusText,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (!isCompleted) ...[
                        const SizedBox(height: AppTheme.spaceSm),
                        ClipRRect(
                          borderRadius: AppTheme.borderRadiusSm,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppTheme.getSurfaceVariant(
                              context,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress < 0.3
                                  ? AppTheme.warning
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ],
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
