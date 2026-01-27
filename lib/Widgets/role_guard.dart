import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:provider/provider.dart';

/// Role-Based Access Control Widget
/// Conditionally shows/hides child widgets based on user's role in current organization
class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);
    final userRole = orgProvider.role;

    // If no org context, hide by default
    if (userRole == null) {
      return fallback ?? const SizedBox.shrink();
    }

    // Check if user's role is in allowed roles
    if (allowedRoles.contains(userRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Helper function to check permissions programmatically
class PermissionHelper {
  static const List<String> adminRoles = ['owner', 'admin'];
  static const List<String> teacherRoles = ['owner', 'admin', 'moderator', 'teacher'];
  static const List<String> allRoles = ['owner', 'admin', 'moderator', 'teacher', 'student'];

  /// Check if user can manage organization (owner/admin only)
  static bool canManageOrg(String? role) {
    return role != null && adminRoles.contains(role);
  }

  /// Check if user can create content (teachers and above)
  static bool canCreateContent(String? role) {
    return role != null && teacherRoles.contains(role);
  }

  /// Check if user can invite members
  static bool canInviteMembers(String? role) {
    return role != null && adminRoles.contains(role);
  }

  /// Check if user is owner
  static bool isOwner(String? role) {
    return role == 'owner';
  }

  /// Check if user is at least a teacher
  static bool isTeacherOrAbove(String? role) {
    return role != null && teacherRoles.contains(role);
  }
}

/// Disabled widget wrapper - shows widget but disabled if permission denied
class PermissionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final List<String> requiredRoles;

  const PermissionButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.requiredRoles,
  });

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);
    final userRole = orgProvider.role;

    final hasPermission = userRole != null && requiredRoles.contains(userRole);

    if (child is ElevatedButton) {
      return ElevatedButton(
        onPressed: hasPermission ? onPressed : null,
        child: (child as ElevatedButton).child,
      );
    }

    if (child is IconButton) {
      return IconButton(
        onPressed: hasPermission ? onPressed : null,
        icon: (child as IconButton).icon,
      );
    }

    // Default: wrap in opacity
    return Opacity(
      opacity: hasPermission ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !hasPermission,
        child: child,
      ),
    );
  }
}
