import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/profile_controller.dart';
import '../../../widgets/pemilikKos/profile/profile_header.dart';
import '../../../widgets/pemilikKos/profile/profile_menu_section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PemilikKosProfileView extends StatefulWidget {
  const PemilikKosProfileView({super.key});

  @override
  State<PemilikKosProfileView> createState() => _PemilikKosProfileViewState();
}

class _PemilikKosProfileViewState extends State<PemilikKosProfileView> {
  late PemilikKosProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = PemilikKosProfileController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<PemilikKosProfileController>(
        builder: (context, ctrl, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1E4A7A), Color(0xFF1E4A7A)],
                ),
              ),
              child: ctrl.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Stack(
                          children: [
                            PemilikKosProfileHeader(controller: ctrl),
                            Positioned(
                              top: 50,
                              right: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.yellow.withOpacity(0.35),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => _logout(context),
                                  icon: const Icon(
                                    Icons.logout,
                                    color: AppColors.background,
                                  ),
                                  tooltip: 'Logout',
                                  padding: const EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkBlue.withOpacity(0.12),
                                  blurRadius: 22,
                                  offset: const Offset(0, -8),
                                ),
                              ],
                            ),
                            child: PemilikKosProfileMenuSection(
                              controller: ctrl,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}