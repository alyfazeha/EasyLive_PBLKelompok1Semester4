import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/user/favorite_controller.dart';

import 'models/pemilikJasa/notifikasi_model.dart';
import 'models/user/history_model.dart';
import 'models/user/kos_model.dart';

import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';

import 'views/User/booking/booking_view.dart' as user_booking;
import 'views/User/home/home_view.dart';
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

import 'views/pemilikKos/home/detailKamar_view.dart';
import 'views/pemilikKos/home/home_view.dart';
import 'views/pemilikKos/home/tambahData_view.dart';
import 'views/pemilikKos/dashboard/dashboard_view.dart';
import 'views/pemilikKos/dashboard/payment_detail_view.dart';
import 'models/pemilikKos/dashboard_model.dart'; // Dashboard

import 'views/pemilikKos/booking/booking_view.dart' as pemilik_booking;
import 'views/pemilikKos/booking/detail_booking_view.dart'
    as pemilik_kos_detail_booking;
import 'views/pemilikKos/notifikasi/notifikasi_view.dart';

import 'views/pemilikJasa/home/home_view.dart';
import 'views/pemilikJasa/home/detailJasa_view.dart' as owner_jasa_detail;
import 'views/pemilikJasa/dashboard/dashboard_view.dart';
import 'views/pemilikJasa/dashboard/payment_detail_view.dart'
    as jasa_payment_detail;
import 'models/pemilikJasa/payment_detail_model.dart';

import 'views/pemilikJasa/booking/booking_view.dart' as pemilik_jasa_booking;
import 'views/pemilikJasa/booking/detail_booking_view.dart'
    as pemilik_jasa_detail_booking;
import 'views/pemilikJasa/notifikasi/notifikasi_view.dart';
import 'views/pemilikJasa/notifikasi/detail_notifikasi_view.dart';
import 'views/pemilikJasa/profile/profile_view.dart' as jasa_profile;

import 'views/admin/dashboard/dashboard_view.dart';
import 'views/admin/history/history_view.dart';
import 'views/admin/kos/kos_approval_view.dart';

import 'views/splash/splash_view.dart';
import 'models/pemilikJasa/payment_detail_model.dart'; // Dashboard
import 'models/pemilikJasa/dashboard_model.dart';
import 'models/admin/kos_model.dart';
import 'views/admin/kos/detail_approvalKos.dart';
import 'views/admin/kos/kos_approval_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tcxpimjgyutkcsdfhwbg.supabase.co',
    anonKey: 'sb_publishable_QBW63CEkf5bh3CdBvDkdgg_wShXq-Ku',
  );

  await FavoriteController.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: generateRoute,
    );
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _noAnimation(const SplashScreen(), settings);

      case '/login':
        return _noAnimation(const LoginView(), settings);

      case '/register':
        return _noAnimation(const RegisterView(), settings);

      case '/home':
        return _noAnimation(const HomeView(), settings);

      case '/kost':
        return _noAnimation(const KosView(), settings);

      case '/detail_kos':
        final kost = settings.arguments as KostModel;
        return _noAnimation(DetailKosView(kost: kost), settings);

      case '/personal_info':
        final args = settings.arguments;
        if (args is KostModel) {
          return _noAnimation(PersonalInfoView(kost: args), settings);
        } else {
          final map = args as Map<String, dynamic>;
          return _noAnimation(
            PersonalInfoView(
              kost: map['kost'] as KostModel,
              isJasa: map['isJasa'] as bool? ?? false,
              fromLocation: map['fromLocation'] as String?,
              toLocation: map['toLocation'] as String?,
            ),
            settings,
          );
        }

      case '/invoice':
        final kost = settings.arguments as KostModel;
        return _noAnimation(InvoiceView(kost: kost), settings);

      case '/payment':
        final kost = settings.arguments as KostModel;
        return _noAnimation(QrisPaymentView(kost: kost), settings);

      case '/booking':
        return _noAnimation(const user_booking.BookingView(), settings);

      case '/history':
        return _noAnimation(const HistoryView(), settings);

      case '/history/detail':
        final item = settings.arguments as HistoryItem;
        return _noAnimation(HistoryDetailView(item: item), settings);

      case '/profile':
        return _noAnimation(const user_profile.ProfileView(), settings);

      case '/edit_profile':
        return _noAnimation(const EditProfileView(), settings);

      case '/favorite':
        return _noAnimation(const FavoriteView(), settings);

      case '/security':
        return _noAnimation(const SecurityView(), settings);

      case '/pemilik_kos':
        return _noAnimation(const PemilikKosHomeView(), settings);

      case '/pemilik_kos/detail_kamar':
        final idKost = settings.arguments as String? ?? '';
        return _noAnimation(DetailKostView(idKost: idKost), settings);

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
        return _noAnimation(const DashboardView(), settings);

      case '/pemilik_kos/detail_pembayaran':
        final args = settings.arguments;
        if (args is Dashboard) {
          return _noAnimation(PaymentDetailView(dashboard: args), settings);
        }
        return null;

      case '/pemilik_kos/notifikasi':
        return _noAnimation(const OwnerNotificationView(), settings);

      case '/pemilik_jasa':
        return _noAnimation(PemilikJasaHomeView(), settings);

      case '/pemilik_jasa/profile':
        return _noAnimation(
          const jasa_profile.PemilikJasaProfileView(),
          settings,
        );

      case '/pemilik_jasa/dashboard':
        return _noAnimation(PemilikJasaDashboardView(), settings);

      case '/pemilik_jasa/dashboard/detail_pembayaran':
        final history = settings.arguments as JasaPaymentHistory;

        return _noAnimation(
          jasa_payment_detail.PaymentDetailView(history: history),
          settings,
        );

      case '/pemilik_jasa/booking':
        return _noAnimation(
          pemilik_jasa_booking.PemilikJasaBookingView(),
          settings,
        );

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
        final notification = settings.arguments as OwnerNotification;
        return _noAnimation(
          DetailOwnerJasaNotificationView(notification: notification),
          settings,
        );

      case '/admin':
        return _noAnimation(const AdminHomeView(), settings);

      case '/admin/home':
        return _noAnimation(const AdminHomeView(), settings);

      case '/admin/history':
        return _noAnimation(const AdminHistoryView(), settings);

      case '/admin/kos_approval':
        return _noAnimation(const ApprovalView(), settings);

      case '/admin/kos_approval/detail':
        final approval = settings.arguments as ApprovalModel;

        return _noAnimation(
          ApprovalDetailView(
            approval: approval, // kirim seluruh object dummy
          ),
          settings,
        );

      default:
        return null;
    }
  }

  static PageRouteBuilder _noAnimation(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => page,
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
