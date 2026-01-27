# Role-Based Access Control (RBAC) System

## Overview
The RBAC system provides fine-grained permission control for organization features. Roles are **organization-scoped** - users have different roles in different organizations.

## Role Hierarchy

### 1. Owner
- **Highest authority** in the organization
- Can delete organization
- Can transfer ownership
- Full admin privileges + ownership rights

### 2. Admin
- Can manage organization settings
- Can invite/remove members
- Can assign roles (except owner)
- Can create/delete programs, courses, classes

### 3. Moderator
- Can create content (programs, courses, classes)
- Can manage existing content
- Can view analytics
- Cannot manage members or org settings

### 4. Teacher
- Can create courses and classes
- Can manage assigned classes
- Can create assignments and exams
- Can grade submissions

### 5. Student
- Can view enrolled courses
- Can join classes
- Can submit assignments
- Can view grades

## Usage

### 1. RoleGuard Widget
Conditionally show/hide UI elements based on role:

```dart
import 'package:htoochoon_flutter/Widgets/role_guard.dart';

// Only show to admins
RoleGuard(
  allowedRoles: ['owner', 'admin'],
  child: ElevatedButton(
    onPressed: () => inviteMember(),
    child: Text('Invite Member'),
  ),
)

// With fallback widget
RoleGuard(
  allowedRoles: ['teacher', 'admin', 'owner'],
  fallback: Text('You need teacher access'),
  child: CreateCourseButton(),
)
```

### 2. PermissionHelper
Programmatic permission checks:

```dart
import 'package:htoochoon_flutter/Widgets/role_guard.dart';

final orgProvider = Provider.of<OrgProvider>(context);
final userRole = orgProvider.role;

// Check specific permissions
if (PermissionHelper.canManageOrg(userRole)) {
  // Show admin panel
}

if (PermissionHelper.canCreateContent(userRole)) {
  // Enable content creation
}

if (PermissionHelper.isOwner(userRole)) {
  // Show ownership controls
}
```

### 3. PermissionButton
Auto-disable buttons based on permissions:

```dart
PermissionButton(
  requiredRoles: ['owner', 'admin'],
  onPressed: () => deleteOrganization(),
  child: ElevatedButton(
    child: Text('Delete Org'),
  ),
)
```

## Permission Matrix

| Feature | Owner | Admin | Moderator | Teacher | Student |
|---------|-------|-------|-----------|---------|---------|
| Delete Organization | ✅ | ❌ | ❌ | ❌ | ❌ |
| Manage Settings | ✅ | ✅ | ❌ | ❌ | ❌ |
| Invite Members | ✅ | ✅ | ❌ | ❌ | ❌ |
| Assign Roles | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create Programs | ✅ | ✅ | ✅ | ✅ | ❌ |
| Create Courses | ✅ | ✅ | ✅ | ✅ | ❌ |
| Create Classes | ✅ | ✅ | ✅ | ✅ | ❌ |
| Create Assignments | ✅ | ✅ | ✅ | ✅ | ❌ |
| Grade Submissions | ✅ | ✅ | ✅ | ✅ | ❌ |
| View Analytics | ✅ | ✅ | ✅ | ❌ | ❌ |
| Join Classes | ✅ | ✅ | ✅ | ✅ | ✅ |
| Submit Work | ✅ | ✅ | ✅ | ✅ | ✅ |

## Firestore Structure

```
organizations/{orgId}/members/{userId}
  - uid: string
  - role: 'owner' | 'admin' | 'moderator' | 'teacher' | 'student'
  - email: string
  - joinedAt: timestamp
  - status: 'active' | 'invited' | 'pending'
```

## Best Practices

1. **Always check permissions** before showing sensitive UI
2. **Use RoleGuard** for declarative permission control
3. **Use PermissionHelper** for complex conditional logic
4. **Never trust client-side checks alone** - always validate on backend
5. **Cache role in OrgProvider** to avoid repeated Firestore reads
6. **Clear role when leaving organization** context

## Example Implementation

See `lib/Screens/OrgScreens/org_management_screen.dart` for a complete working example.

## Security Notes

⚠️ **Important**: Client-side permission checks are for UX only. Always implement server-side validation using Firebase Security Rules:

```javascript
// Example Firestore Security Rule
match /organizations/{orgId}/programs/{programId} {
  allow create: if isTeacherOrAbove(orgId);
  allow delete: if isAdmin(orgId);
}

function isTeacherOrAbove(orgId) {
  let member = get(/databases/$(database)/documents/organizations/$(orgId)/members/$(request.auth.uid));
  return member.data.role in ['owner', 'admin', 'moderator', 'teacher'];
}
```
