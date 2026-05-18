import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/user/favorite_controller.dart';

import 'models/user/history_model.dart' as user_history;
import 'models/user/kos_model.dart';

import 'models/pemilikJasa/notifikasi_model.dart';
import 'models/pemilikKos/dashboard_model.dart' as kos_model;
import 'models/pemilikJasa/dashboard_model.dart' as jasa_model;

import 'models/admin/notifikasi/notifikasi_model.dart';

import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';

import 'views/User/booking/booking_view.dart' as user_booking;
import 'views/User/home/home_view.dart' as user_home;
import 'views/User/kos/kos_view.dart';
import 'views/User/kos/detailKos_view.dart';

import 'views/User/profile/profile_view.dart' as user_profile;
import 'views/User/profile/edit_profile_view.dart';
import 'views/User/profile/favorite_view.dart';
import 'views/User/profile/security_view.dart';

import 'views/User/history/history_view.dart';
import 'views/User/history/history_detail_view.dart';

import 'views/User/payment/personalInfo_view.dart';
import 'views/User/payment/invoice_view.dart';
import 'views/User/payment/qrisPayment_view.dart';

import 'views/pemilikKos/home/home_view.dart' as pemilik_kos_home;

import 'views/pemilikKos/home/detailKamar_view.dart';
import 'views/pemilikKos/home/tambahData_view.dart';

import 'views/pemilikKos/dashboard/dashboard_view.dart' as pemilik_kos_dashboard;

import 'views/pemilikKos/dashboard/payment_detail_view.dart';

import 'views/pemilikKos/booking/booking_view.dart' as pemilik_booking;

import 'views/pemilikKos/booking/detail_booking_view.dart' as pemilik_kos_detail_booking;

import 'views/pemilikKos/notifikasi/notifikasi_view.dart';

import 'views/pemilikJasa/home/home_view.dart' as pemilik_jasa_home;
import 'views/pemilikJasa/home/detailJasa_view.dart' as owner_jasa_detail;

import 'views/pemilikJasa/dashboard/dashboard_view.dart' as pemilik_jasa_dashboard;
import 'views/pemilikJasa/dashboard/pembayaran_detail_view.dart' as jasa_payment_detail;

import 'views/pemilikJasa/booking/booking_view.dart' as pemilik_jasa_booking;
import 'views/pemilikJasa/booking/detail_booking_view.dart' as pemilik_jasa_detail_booking;

import 'views/pemilikJasa/notifikasi/detail_notifikasi_view.dart';

import 'views/pemilikJasa/profile/profile_view.dart' as jasa_profile;

import 'views/admin/dashboard/dashboard_view.dart' as admin_dashboard;

import 'views/admin/history/history_view.dart';
import 'views/admin/jasa/jasa_management_view.dart';

import 'views/admin/kos/kos_approval_view.dart';
import 'views/admin/notifikasi/notifikasi_view.dart';
import 'views/admin/notifikasi/notifikasi_detail_view.dart';
import 'views/admin/notifikasi/notification_settings_view.dart';

import 'views/admin/profile/admin_profile_view.dart';
import 'views/admin/profile/profile_information_view.dart';
import 'views/admin/profile/ubah_password_admin_view.dart';
import 'views/admin/profile/app_settings_view.dart';
import 'views/admin/profile/help_support_view.dart';

import 'views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'https://tcxpimjgyutkcsdfhwbg.supabase.co',
    defaultValue: 'MISSING_SUPABASE_URL',
  );

  const supabaseAnonKey = String.fromEnvironment(
    'sb_publishable_QBW63CEkf5bh3CdBvDkdgg_wShXq-Ku',
    defaultValue: 'MISSING_SUPABASE_ANON_KEY',
  );

  final hasSupabaseConfig =
      supabaseUrl != 'MISSING_SUPABASE_URL' &&
      supabaseAnonKey != 'MISSING_SUPABASE_ANON_KEY';

  if (hasSupabaseConfig) {
    await Supabase.initialize(
      url: 'https://tcxpimjgyutkcsdfhwbg.supabase.co',
      anonKey: 'sb_publishable_QBW63CEkf5bh3CdBvDkdgg_wShXq-Ku',
    );

    await FavoriteController.init();
  }

  runApp(MyApp(hasSupabaseConfig: hasSupabaseConfig));
}

class MyApp extends StatelessWidget {
  final bool hasSupabaseConfig;

  const MyApp({
    super.key,
    required this.hasSupabaseConfig,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) => generateRoute(settings, hasSupabaseConfig),
    );
  }
}

Route<dynamic>? generateRoute(
  RouteSettings settings,
  bool hasSupabaseConfig,
) {
  switch (settings.name) {
    // ================= SPLASH =================
    case '/':
      if (!hasSupabaseConfig) {
        return _noAnimation(
          const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Supabase config belum diset.\n\n'
                  'Jalankan dengan:\n'
                  '--dart-define=SUPABASE_URL=...\n'
                  '--dart-define=SUPABASE_ANON_KEY=...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          settings,
        );
      }

      return _noAnimation(
        const SplashScreen(),
        settings,
      );

    // ================= AUTH =================
    case '/login':
      return _noAnimation(const LoginView(), settings);

    case '/register':
      return _noAnimation(const RegisterView(), settings);

    // ================= USER =================
    case '/home':
      return _noAnimation(const user_home.HomeView(), settings);

    case '/kost':
      return _noAnimation(const KosView(), settings);

    case '/detail_kos':
      final argsDetail = settings.arguments;
      if (argsDetail is KostModel) {
        return _noAnimation(DetailKosView(kost: argsDetail), settings);
      }
      return _errorRoute(settings);

    case '/personal_info':
      final argsPersonal = settings.arguments;

      if (argsPersonal is KostModel) {
        return _noAnimation(PersonalInfoView(kost: argsPersonal), settings);
      }

      if (argsPersonal is Map<String, dynamic>) {
        return _noAnimation(
          PersonalInfoView(
            kost: argsPersonal['kost'] as KostModel,
            isJasa: argsPersonal['isJasa'] ?? false,
            fromLocation: argsPersonal['fromLocation'],
            toLocation: argsPersonal['toLocation'],
          ),
          settings,
        );
      }

      return _errorRoute(settings);

    case '/invoice':
      final argsInvoice = settings.arguments;
      if (argsInvoice is KostModel) {
        return _noAnimation(InvoiceView(kost: argsInvoice), settings);
      }
      return _errorRoute(settings);

    case '/payment':
      final argsPayment = settings.arguments;
      if (argsPayment is KostModel) {
        return _noAnimation(QrisPaymentView(kost: argsPayment), settings);
      }
      return _errorRoute(settings);

    case '/booking':
      return _noAnimation(const user_booking.BookingView(), settings);

    case '/history':
      return _noAnimation(const HistoryView(), settings);

    case '/history/detail':
      final argsHistoryDetail = settings.arguments;
      if (argsHistoryDetail is user_history.HistoryItem) {
        return _noAnimation(
          HistoryDetailView(item: argsHistoryDetail),
          settings,
        );
      }
      return _errorRoute(settings);

    case '/profile':
      return _noAnimation(const user_profile.ProfileView(), settings);

    case '/edit_profile':
      return _noAnimation(const EditProfileView(), settings);

    case '/favorite':
      return _noAnimation(const FavoriteView(), settings);

    case '/security':
      return _noAnimation(const SecurityView(), settings);

    // ================= PEMILIK KOS =================
    case '/pemilik_kos':
      return _noAnimation(const pemilik_kos_home.PemilikKosHomeView(), settings);

    case '/pemilik_kos/detail_kamar':
      final idKost = settings.arguments as String? ?? '';
      return _noAnimation(
        DetailKostView(idKost: idKost),
        settings,
      );

    case '/pemilik_kos/tambah_data':
      return _noAnimation(TambahDataView(), settings);

    case '/pemilik_kos/history':
      return _noAnimation(const pemilik_booking.OwnerBookingView(), settings);

    case '/pemilik_kos/detail_booking':
      final idBooking = settings.arguments as String? ?? '';
      return _noAnimation(
        pemilik_kos_detail_booking.DetailBookingView(idBooking: idBooking),
        settings,
      );

    case '/pemilik_kos/profile':
      return _noAnimation(const user_profile.ProfileView(), settings);

    case '/pemilik_kos/dashboard':
      return _noAnimation(const pemilik_kos_dashboard.DashboardView(), settings);

    case '/pemilik_kos/detail_pembayaran':
      final argsPembayaran = settings.arguments;
      if (argsPembayaran is kos_model.Dashboard) {
        return _noAnimation(
          PaymentDetailView(dashboard: argsPembayaran),
          settings,
        );
      }
      return _errorRoute(settings);

    case '/pemilik_kos/notifikasi':
      return _noAnimation(const OwnerNotificationView(), settings);

    // ================= PEMILIK JASA =================
    case '/pemilik_jasa':
      return _noAnimation(pemilik_jasa_home.PemilikJasaHomeView(), settings);

    case '/pemilik_jasa/profile':
      return _noAnimation(jasa_profile.PemilikJasaProfileView(), settings);

    case '/pemilik_jasa/dashboard':
      return _noAnimation(pemilik_jasa_dashboard.PemilikJasaDashboardView(), settings);

    case '/pemilik_jasa/dashboard/detail_pembayaran':
      final argsJasaPay = settings.arguments;
      if (argsJasaPay is jasa_model.JasaPaymentHistory || argsJasaPay == null) {
        return _noAnimation(
          jasa_payment_detail.PemilikJasaPembayaranDetailView(),
          settings,
        );
      }
      return _errorRoute(settings);

    case '/pemilik_jasa/booking':
      return _noAnimation(pemilik_jasa_booking.PemilikJasaBookingView(), settings);

    case '/pemilik_jasa/detail_booking':
      final tenantName = settings.arguments as String? ?? 'Budi Santoso';
      return _noAnimation(
        pemilik_jasa_detail_booking.DetailBookingView(tenantName: tenantName),
        settings,
      );

    case '/pemilik_jasa/detail_jasa':
      final vehicleName = settings.arguments as String? ?? 'Pickup';
      return _noAnimation(
        owner_jasa_detail.DetailJasaView(vehicleName: vehicleName),
        settings,
      );

    case '/pemilik_jasa/notifikasi/detail':
      final argsNotif = settings.arguments;
      if (argsNotif is OwnerNotification) {
        return _noAnimation(
          DetailOwnerJasaNotificationView(notification: argsNotif),
          settings,
        );
      }
      return _errorRoute(settings);

    // ================= ADMIN =================
    case '/admin':
    case '/admin/home':
      return _noAnimation(const admin_dashboard.AdminHomeView(), settings);

    case '/admin/history':
      return _noAnimation(const AdminHistoryView(), settings);

    case '/admin/jasa':
      return _noAnimation(AdminJasaManagementView(), settings);

    case '/admin/kos':
    case '/admin/kos_approval':
      return _noAnimation(const ApprovalView(), settings);

    case '/admin/notifikasi':
      return _noAnimation(const AdminNotificationView(), settings);

    case '/admin/notifikasi/detail':
      final argsAdminNotif = settings.arguments;
      if (argsAdminNotif is AdminNotification) {
        return _noAnimation(
          AdminNotificationDetailView(notification: argsAdminNotif),
          settings,
        );
      }
      return _errorRoute(settings);

    case '/admin/profile':
      return _noAnimation(const AdminProfileView(), settings);

    case '/admin/profile_information':
      return _noAnimation(const AdminProfileInformationView(), settings);

    case '/admin/ubah_password':
      return _noAnimation(const UbahPasswordAdminView(), settings);

    case '/admin/notifikasi_settings':
      return _noAnimation(const AdminNotificationSettingsView(), settings);

    case '/admin/app_settings':
      return _noAnimation(const AdminAppSettingsView(), settings);

    case '/admin/help_support':
      return _noAnimation(const AdminHelpSupportView(), settings);

    // ================= DEFAULT =================
    default:
      return _errorRoute(settings);
  }
}

PageRouteBuilder _noAnimation(Widget page, RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

Route<dynamic> _errorRoute(RouteSettings settings) {
  return MaterialPageRoute(
    settings: settings,
    builder: (_) => const Scaffold(
      body: Center(
        child: Text(
          'Page Not Found',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ),
  );
}
