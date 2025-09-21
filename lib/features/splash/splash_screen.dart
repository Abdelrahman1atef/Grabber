import 'package:flutter/material.dart';

import '../../core/routes/routes.dart' show Routes;
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Animations for the full 'logo.svg'
  late Animation<double> _fullLogoFadeInAnimation;
  late Animation<double> _fullLogoScaleAnimation;
  late Animation<Offset> _fullLogoSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Setup for the logo animation (2 seconds)
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Fade-in animation
    _fullLogoFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Bouncy scale animation
    _fullLogoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    // Slide-up animation
    _fullLogoSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    // Navigate after the animation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.main);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return SlideTransition(
              position: _fullLogoSlideAnimation,
              child: Opacity(
                opacity: _fullLogoFadeInAnimation.value,
                child: Transform.scale(
                  scale: _fullLogoScaleAnimation.value,
                  child: Assets.logo.logo.svg(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
