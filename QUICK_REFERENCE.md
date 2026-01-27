# RBAC Quick Reference Card

## Import Statement
```dart
import 'package:htoochoon_flutter/Widgets/role_guard.dart';
```

## Common Patterns

### Hide UI Element by Role
```dart
RoleGuard(
  allowedRoles: ['owner', 'admin'],
  child: DeleteButton(),
)
```

### Show Different UI for Different Roles
```dart
RoleGuard(
  allowedRoles: ['student'],
  child: StudentView(),
  fallback: RoleGuard(
    allowedRoles: ['teacher'],
    child: TeacherView(),
    fallback: AdminView(),
  ),
)
```

### Disable Button by Permission
```dart
PermissionButton(
  requiredRoles: PermissionHelper.adminRoles,
  onPressed: () => deleteOrg(),
  child: ElevatedButton(child: Text('Delete')),
)
```

### Programmatic Check
```dart
final role = Provider.of<OrgProvider>(context).role;

if (PermissionHelper.canManageOrg(role)) {
  // Show admin features
}
```

## Role Constants

```dart
PermissionHelper.adminRoles        // ['owner', 'admin']
PermissionHelper.teacherRoles      // ['owner', 'admin', 'moderator', 'teacher']
PermissionHelper.allRoles          // All 5 roles
```

## Permission Methods

```dart
PermissionHelper.canManageOrg(role)      // Owner/Admin
PermissionHelper.canCreateContent(role)   // Teacher+
PermissionHelper.canInviteMembers(role)   // Admin only
PermissionHelper.isOwner(role)            // Owner only
PermissionHelper.isTeacherOrAbove(role)   // Teacher+
```

## Structure Provider

### Create Program
```dart
await structureProvider.createProgram(
  orgId,
  'Program Name',
  'Description',
);
```

### Create Course
```dart
await structureProvider.createCourse(
  orgId,
  programId,
  'Course Name',
  'Description',
);
```

### Create Class
```dart
await structureProvider.createClass(
  orgId: orgId,
  programId: programId,
  courseId: courseId,
  name: 'Class Name',
  teacherId: teacherId,
  schedule: 'Mon/Wed 10AM',
);
```

### Fetch Data
```dart
await structureProvider.fetchPrograms(orgId);
await structureProvider.fetchCourses(orgId, programId);
await structureProvider.fetchClasses(orgId, programId, courseId);

// Access cached data
final programs = structureProvider.programs;
final courses = structureProvider.courses;
final classes = structureProvider.classes;
```

## Org Provider

### Invite Member
```dart
await orgProvider.inviteMember(
  'user@example.com',
  'teacher',
);
```

### Fetch Members
```dart
final members = await orgProvider.fetchOrgMembers();
```

### Switch Organization
```dart
await orgProvider.switchOrganization(
  orgId,
  orgName,
  userRole,
);
```

### Leave Organization
```dart
await orgProvider.leaveOrganization();
```

## Common Workflows

### Admin Inviting Teacher
```dart
if (PermissionHelper.canInviteMembers(orgProvider.role)) {
  await orgProvider.inviteMember(email, 'teacher');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Teacher invited')),
  );
}
```

### Teacher Creating Course
```dart
RoleGuard(
  allowedRoles: PermissionHelper.teacherRoles,
  child: ElevatedButton(
    onPressed: () async {
      await structureProvider.createCourse(
        orgProvider.currentOrgId!,
        programId,
        courseName,
        description,
      );
    },
    child: Text('Create Course'),
  ),
)
```

### Student Viewing Content
```dart
// Students can always view - no guard needed
ListView.builder(
  itemCount: structureProvider.courses.length,
  itemBuilder: (context, index) {
    final course = structureProvider.courses[index];
    return CourseCard(course: course);
  },
)
```

## Status Badges

Organization member status:
- `active` - Full access
- `invited` - Email sent, pending acceptance
- `pending` - Awaiting approval

Check status in UI:
```dart
final status = org['status'] ?? 'active';
if (status == 'pending') {
  return PendingBadge();
}
```

## Remember

✅ Always check permissions before showing sensitive UI
✅ Use RoleGuard for declarative control
✅ Use PermissionHelper for complex logic
✅ Cache role in OrgProvider (no repeated reads)
✅ Clear role when leaving org context
⚠️ Implement server-side validation (Security Rules)
⚠️ Never trust client-side checks alone
