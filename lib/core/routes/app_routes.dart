
import 'package:flutter/material.dart';
import 'package:products/core/routes/routes.dart';

import '../../features/cart/screens/cart_screen.dart';
import '../../features/main/screens/main_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRoutes<Routs> {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.main:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500), // Adjust duration as needed
        );
        case Routes.cart:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
                position: animation.drive(Tween(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                )),
                child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500), // Adjust duration as needed
        );

      default:
        return _undefineRoute();
    }
  }

  static Route<dynamic> _undefineRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center( // Added Center for better aesthetics
          child: Text("No route found"),
        ),
      ),
    );
  }
}
