import 'package:flutter/material.dart';
import 'package:products/core/routes/routes.dart';

import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/ui/screens/checkout_screen.dart';
import '../../features/main/screens/main_screen.dart';
import '../../features/payment/ui/screens/payment_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../utils/const_val.dart';
import '../model/payment_method_model.dart';

class AppRoutes<Routs> {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.main:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  CurvedAnimation(
                    parent: animation,
                    curve: ConstVal.customCurve,
                    // curve: Curves.easeOutBack,
                  ).drive(
                    Tween<Offset>(
                      begin: const Offset(1.7, 0.0),
                      end: Offset.zero,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700), // 👈 not 3000!
        );
      case Routes.cart:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CartScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.7, 0.0),
                  end: const Offset(0.0, 0.0),
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      case Routes.checkout:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CheckoutScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.7, 0.0),
                  end: const Offset(0.0, 0.0),
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
      case Routes.payment:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PaymentScreen(
                paymentMethods: settings.arguments as List<PaymentMethodModel>,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.7, 0.0),
                  end: const Offset(0.0, 0.0),
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );

      default:
        return _undefineRoute();
    }
  }

  static Route<dynamic> _undefineRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          // Added Center for better aesthetics
          child: Text("No route found"),
        ),
      ),
    );
  }
}
