import 'package:flutter/material.dart';

<<<<<<< HEAD
import '../../../controllers/admin/profile/change_password_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/common/back_button_widget.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';

class UbahPasswordAdminView extends StatefulWidget {
  const UbahPasswordAdminView({super.key});

  @override
  State<UbahPasswordAdminView> createState() => _UbahPasswordAdminViewState();
}

class _UbahPasswordAdminViewState extends State<UbahPasswordAdminView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@easyjasa.com');
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _controller = ChangeAdminPasswordController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await _controller.changePassword(
        email: _emailController.text,
        currentPassword: _currentPassController.text,
        newPassword: _newPassController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password admin berhasil diubah'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ColoredBox(
        color: const Color(0xFF243447),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 44, height: 44),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Ubah Password Admin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/admin/notifikasi'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.notifications, color: Color(0xFF243447)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: BackButtonWidget(
                          backgroundColor: Colors.white,
                          iconColor: const Color(0xFF243447),
                          size: 44,
                          iconSize: 20,
                          borderRadius: 12,
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.06),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Keamanan Akun',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (v) {
                                          final value = (v ?? '').trim();
                                          if (value.isEmpty) return 'Email wajib diisi';
                                          if (!value.contains('@')) return 'Email tidak valid';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _currentPassController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password Saat Ini',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (v) {
                                          final value = (v ?? '').trim();
                                          if (value.isEmpty) return 'Password saat ini wajib diisi';
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _newPassController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password Baru',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (v) {
                                          final value = (v ?? '').trim();
                                          if (value.isEmpty) return 'Password baru wajib diisi';
                                          if (value.length < 6) {
                                            return 'Password minimal 6 karakter';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _confirmPassController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Konfirmasi Password Baru',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (v) {
                                          final value = (v ?? '').trim();
                                          if (value.isEmpty) return 'Konfirmasi password wajib diisi';
                                          if (value != _newPassController.text.trim()) {
                                            return 'Konfirmasi password tidak cocok';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: _isSubmitting ? null : _submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFF6BE00),
                                            foregroundColor: const Color(0xFF243447),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: _isSubmitting
                                              ? const SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                )
                                              : const Text(
                                                  'Simpan Perubahan',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index == 4) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/admin/history');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/admin/kos');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/admin/jasa');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

=======
class UbahPasswordAdminView extends StatelessWidget {
  const UbahPasswordAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ubah Password Admin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
>>>>>>> rafi
