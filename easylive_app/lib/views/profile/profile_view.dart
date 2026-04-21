import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import '../../core/color.dart';
import '../../models/user_model.dart';
import '../../widgets/home/botton_navbar.dart';
import '../../widgets/profile/profile_menu_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = ProfileController.getUserProfile();
    final menus = ProfileController.getProfileMenus();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight - MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                Container(
                  height: 290,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3DEC1),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(46),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 190,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(260, 90),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                                return;
                              }
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.title1,
                              size: 30,
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.title1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: 142,
                            height: 142,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF6D7782),
                                  Color(0xFF2B3037),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 84,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: -4,
                            top: 8,
                            child: InkWell(
                              onTap: () => _showInfoMessage(
                                context,
                                'Edit profile belum tersedia.',
                              ),
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  size: 22,
                                  color: AppColors.title1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.title1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Expanded(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: menus.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final menu = menus[index];
                            final title = menu['title'] as String;
                            return ProfileMenuTile(
                              title: title,
                              icon: menu['icon'] as IconData,
                              onTap: () => _handleMenuTap(context, title),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  void _handleMenuTap(BuildContext context, String title) {
    if (title == 'Logout') {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return;
    }
    _showInfoMessage(context, '$title belum tersedia.');
  }

  void _showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
