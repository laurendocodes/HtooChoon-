import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:htoochoon_flutter/Theme/themedata.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _pickedImage;
  bool _isUploadingImage = false;

  final ImagePicker _picker = ImagePicker();

  // Future<void> _pickProfileImage(UserProvider provider) async {
  //   final XFile? file = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 75,
  //   );
  //
  //   if (file == null) return;
  //
  //   setState(() {
  //     _pickedImage = File(file.path);
  //   });
  //
  //   await _uploadProfileImage(provider);
  // }

  // Future<void> _uploadProfileImage(UserProvider provider) async {
  //   if (_pickedImage == null) return;
  //
  //   try {
  //     setState(() => _isUploadingImage = true);
  //
  //     await provider.updateProfilePhoto(_pickedImage!);
  //
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Profile photo updated')));
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isUploadingImage = false;
  //         _pickedImage = null;
  //       });
  //     }
  //   }
  // }

  void _showEditNameDialog(
    BuildContext context,
    UserProvider provider,
    Map<String, dynamic> user,
  ) {
    final controller = TextEditingController(
      text: user['name'] ?? user['username'],
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: AppTheme.spaceXs),
          ElevatedButton(
            onPressed: () async {
              // if (controller.text.trim().isEmpty) return;
              //
              // await provider.updateProfile(name: controller.text.trim());
              // if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (authProvider.isLoading && user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.getTextTertiary(context),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              'Unable to load profile',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.getTextSecondary(context),
              ),
            ),
          ],
        ),
      );
    }

    final String displayName = user.name;
    // final String? photoUrl = user['photo'];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'My Profile',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.1),

                  // backgroundImage: _pickedImage != null
                  //     ? FileImage(_pickedImage!)
                  //     : (photoUrl != null ? NetworkImage(photoUrl) : null)
                  //           as ImageProvider?,
                  // child: photoUrl == null && _pickedImage == null
                  //     ? Text(
                  //         displayName[0].toUpperCase(),
                  //         style: Theme.of(context).textTheme.displaySmall
                  //             ?.copyWith(
                  //               fontWeight: FontWeight.w700,
                  //               color: Theme.of(context).colorScheme.primary,
                  //             ),
                  //       )
                  //     : null,
                  child: Text(
                    displayName[0].toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                // Camera Button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    // _isUploadingImage
                    //     ? null
                    //     : () => _pickProfileImage(userProvider),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spaceXs),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 3,
                        ),
                      ),
                      child: _isUploadingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceLg),

            // Name
            Text(
              displayName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: AppTheme.space2xs),

            // Email
            Text(
              user.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.getTextSecondary(context),
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Plan Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppTheme.borderRadiusLg,
                border: Border.all(
                  color: AppTheme.getBorder(context),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceXs),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFF8B5CF6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.getTextSecondary(context),
                              ),
                        ),
                        const SizedBox(height: AppTheme.space2xs),
                        Text(
                          ('Free').toString().toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Upgrade')),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Edit Name Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Edit Name'),
                onPressed: () {},
                // _showEditNameDialog(context, userProvider, user),
              ),
            ),

            const SizedBox(height: AppTheme.spaceMd),

            // Account Settings Section (optional enhancement)
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppTheme.borderRadiusLg,
                border: Border.all(
                  color: AppTheme.getBorder(context),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  _SettingItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: user.email ?? '',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: AppTheme.getBorder(context)),
                  _SettingItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: '••••••••',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: AppTheme.getBorder(context)),
                  _SettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage preferences',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.getTextSecondary(context)),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppTheme.getTextTertiary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
