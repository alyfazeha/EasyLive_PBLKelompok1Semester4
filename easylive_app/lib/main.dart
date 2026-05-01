import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/user/history_model.dart';
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'views/User/booking/booking_view.dart';
import 'views/User/history/history_detail_view.dart';
import 'views/User/history/history_view.dart';
import 'views/User/home/home_view.dart';
import 'views/User/kos/kos_view.dart';
import 'views/User/profile/profile_view.dart';
import 'views/User/profile/edit_profile_view.dart';
import 'views/User/profile/favorite_view.dart';
import 'views/User/profile/security_view.dart';
import 'views/pemilikKos/home/pemilik_kos_dashboard_view.dart';
import 'views/splash/splash_view.dart';
import 'views/User/kos/detailKos_view.dart';
import 'models/user/kos_model.dart';
import 'views/User/payment/personalInfo_view.dart';
import 'views/User/payment/invoice_view.dart';
import 'views/User/payment/qrisPayment_view.dart';

void main() async {
  // Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tcxpimjgyutkcsdfhwbg.supabase.co',
    anonKey: 'sb_publishable_QBW63CEkf5bh3CdBvDkdgg_wShXq-Ku',
  );

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
        return _noAnimation(const BookingView(), settings);

      case '/history':
        return _noAnimation(const HistoryView(), settings);

      case '/history/detail':
        final item = settings.arguments as HistoryItem;
        return _noAnimation(HistoryDetailView(item: item), settings);

      case '/profile':
        return _noAnimation(const ProfileView(), settings);

      case '/edit_profile':
        return _noAnimation(const EditProfileView(), settings);

      case '/favorite':
        return _noAnimation(const FavoriteView(), settings);

      case '/security':
        return _noAnimation(const SecurityView(), settings);

      case '/pemilik_kos':
        return _noAnimation(const PemilikKosDashboardView(), settings);

      default:
        return null;
    }
  }

  static PageRouteBuilder _noAnimation(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, _, _) => page,
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
