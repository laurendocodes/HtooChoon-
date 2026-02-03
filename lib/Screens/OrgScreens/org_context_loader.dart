import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/OrgWidgets/create_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';

class OrgContextLoader extends StatefulWidget {
  const OrgContextLoader({super.key});

  @override
  State<OrgContextLoader> createState() => _OrgContextLoaderState();
}

class _OrgContextLoaderState extends State<OrgContextLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrgProvider>().fetchUserOrgs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrgProvider>(
      builder: (context, orgProvider, _) {
        return Stack(
          children: [
            // ---------------- MAIN CONTENT ----------------
            if (orgProvider.userOrgs.isNotEmpty)
              Scaffold(
                appBar: AppBar(
                  title: const Text("My Organizations"),
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => showCreateOrgDialog(context),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                body: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orgProvider.userOrgs.length,
                  itemBuilder: (context, index) {
                    final org = orgProvider.userOrgs[index];
                    final role = org['role'] ?? 'student';
                    final status = org['status'] ?? 'active';

                    Color roleColor() {
                      switch (role.toLowerCase()) {
                        case 'owner':
                          return Colors.purple;
                        case 'admin':
                          return Colors.deepOrange;
                        case 'moderator':
                          return Colors.indigo;
                        case 'teacher':
                          return Colors.blue;
                        default:
                          return Colors.green;
                      }
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: orgProvider.orgIsLoading
                            ? null
                            : () {
                                context.read<OrgProvider>().switchOrganization(
                                  org['id'],
                                  org['name'],
                                  role,
                                );
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      roleColor().withOpacity(0.7),
                                      roleColor(),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.business_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      org['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      role.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: roleColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              // ---------------- EMPTY STATE ----------------
              Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.business_center_outlined, size: 80),
                      SizedBox(height: 16),
                      Text(
                        "No Organizations Yet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ---------------- FACEBOOK-STYLE SWITCHING OVERLAY ----------------
            if (orgProvider.isLoading)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.black.withOpacity(0.55),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: Lottie.asset(
                              'assets/lottie/networking.json',
                              repeat: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Switching organization…",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

//
// class OrgContextLoader extends StatefulWidget {
//   const OrgContextLoader({super.key});
//
//   @override
//   State<OrgContextLoader> createState() => _OrgContextLoaderState();
// }
//
// class _OrgContextLoaderState extends State<OrgContextLoader> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch orgs when entering this tab
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<OrgProvider>(context, listen: false).fetchUserOrgs();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<OrgProvider>(
//       builder: (context, orgProvider, child) {
//         if (orgProvider.isLoading) {
//           return MainDashboardWrapper(
//             currentOrgID: orgProvider.isLoading.toString(),
//           );
//         }
//
//         if (orgProvider.userOrgs.isNotEmpty) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("My Organizations"),
//               elevation: 0,
//               actions: [
//                 IconButton(
//                   onPressed: () => showCreateOrgDialog(context),
//                   icon: const Icon(Icons.add_circle_outline),
//                   tooltip: "Create Organization",
//                 ),
//               ],
//             ),
//             body: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: orgProvider.userOrgs.length,
//               itemBuilder: (context, index) {
//                 final org = orgProvider.userOrgs[index];
//                 final role = org['role'] ?? 'student';
//                 final status = org['status'] ?? 'active';
//
//                 // Role-based colors
//                 Color getRoleColor(String role) {
//                   switch (role.toLowerCase()) {
//                     case 'owner':
//                       return Colors.purple;
//                     case 'admin':
//                       return Colors.deepOrange;
//                     case 'moderator':
//                       return Colors.indigo;
//                     case 'teacher':
//                       return Colors.blue;
//                     default:
//                       return Colors.green;
//                   }
//                 }
//
//                 // Status badge
//                 Widget? getStatusBadge(String status) {
//                   if (status == 'invited' || status == 'pending') {
//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.orange.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.mail_outline,
//                             size: 12,
//                             color: Colors.orange.shade700,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'PENDING',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                   return null;
//                 }
//
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                     side: BorderSide(color: Colors.grey.withOpacity(0.2)),
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(16),
//                     onTap: () {
//                       orgProvider.switchOrganization(
//                         org['id'],
//                         org['name'],
//                         org['role'],
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: [
//                           // Organization Icon with gradient
//                           Container(
//                             width: 56,
//                             height: 56,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   getRoleColor(role).withOpacity(0.7),
//                                   getRoleColor(role),
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Icon(
//                               Icons.business_rounded,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//
//                           // Organization Info
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         org['name'],
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     if (getStatusBadge(status) != null)
//                                       getStatusBadge(status)!,
//                                   ],
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 3,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: getRoleColor(
//                                           role,
//                                         ).withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(6),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             _getRoleIcon(role),
//                                             size: 12,
//                                             color: getRoleColor(role),
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             role.toUpperCase(),
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                               color: getRoleColor(role),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           Icon(
//                             Icons.arrow_forward_ios_rounded,
//                             size: 16,
//                             color: Colors.grey.shade400,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             floatingActionButton: FloatingActionButton.extended(
//               onPressed: () => showCreateOrgDialog(context),
//               icon: const Icon(Icons.add),
//               label: const Text("New Organization"),
//             ),
//           );
//         }
//
//         //Default Empty State
//         return Scaffold(
//           body: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(32.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.business_center_outlined,
//                     size: 80,
//                     color: Theme.of(context).primaryColor.withOpacity(0.2),
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     "No Organizations Yet",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     "Organizations allow you to manage classes, programs, and teachers in a unified workspace.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   const SizedBox(height: 32),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: () => showCreateOrgDialog(context),
//                       child: const Text("Create Organization"),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: const Icon(Icons.vpn_key_outlined),
//                     label: const Text("Join with Invite Code"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   IconData _getRoleIcon(String role) {
//     switch (role.toLowerCase()) {
//       case 'owner':
//         return Icons.shield_rounded;
//       case 'admin':
//         return Icons.admin_panel_settings_rounded;
//       case 'moderator':
//         return Icons.verified_user_rounded;
//       case 'teacher':
//         return Icons.school_rounded;
//       default:
//         return Icons.person_rounded;
//     }
//   }
// }
