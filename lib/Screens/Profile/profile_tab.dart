import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _pickedImage;
  bool _isUploadingImage = false;

  final ImagePicker _picker = ImagePicker();

  // ------------------ PICK IMAGE ------------------
  Future<void> _pickProfileImage(UserProvider provider) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (file == null) return;

    setState(() {
      _pickedImage = File(file.path);
    });

    await _uploadProfileImage(provider);
  }

  // ------------------ UPLOAD IMAGE ------------------
  Future<void> _uploadProfileImage(UserProvider provider) async {
    if (_pickedImage == null) return;

    try {
      setState(() => _isUploadingImage = true);

      await provider.updateProfilePhoto(_pickedImage!);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile photo updated")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to upload image")));
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
          _pickedImage = null;
        });
      }
    }
  }

  // ------------------ EDIT NAME ------------------
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
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Full Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              await provider.updateProfile(name: controller.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.userData;

    if (userProvider.isLoading && user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text("Unable to load profile"));
    }

    final String displayName = user['name'] ?? user['username'] ?? 'User';
    final String? photoUrl = user['photo'];

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ------------------ AVATAR ------------------
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (photoUrl != null ? NetworkImage(photoUrl) : null)
                            as ImageProvider?,
                  child: photoUrl == null && _pickedImage == null
                      ? Text(
                          displayName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),

                // CAMERA BUTTON
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: InkWell(
                    onTap: _isUploadingImage
                        ? null
                        : () => _pickProfileImage(userProvider),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: _isUploadingImage
                          ? const SizedBox(
                              width: 14,
                              height: 14,
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

            const SizedBox(height: 16),

            // ------------------ NAME ------------------
            Text(
              displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(
              user['email'] ?? '',
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 24),

            // ------------------ PLAN CARD ------------------
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.indigo),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Plan",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            (user['plan'] ?? 'Free').toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text("Upgrade")),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ------------------ EDIT NAME ------------------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Name"),
                onPressed: () =>
                    _showEditNameDialog(context, userProvider, user),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
