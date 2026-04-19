import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/homePage.dart'; 

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyLive',
      // MENGUBAH initialRoute menjadi rute splash
      initialRoute: '/', 
      onGenerateRoute: (settings) {
        Widget builder;
        switch (settings.name) {
          case '/':
            
            builder = const SplashScreen(); 
            break;
          case '/login':
            builder = LoginScreen();
            break;
          case '/register':
            builder = RegisterScreen();
            break;
          case '/home': 
            builder = const HomePage(); 
            break;
          default:
            return null;
        }

        
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => builder,
          settings: settings, 
          transitionDuration: Duration.zero, 
          reverseTransitionDuration: Duration.zero,
        );
      },
    );
  }
}