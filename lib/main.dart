import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:products/core/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/routes.dart';
import 'features/home/logic/cart_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  SystemChrome.setPreferredOrientations([ // Add these lines
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const FruitApp());
  });
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        // Filled in based on recent files
        initialRoute: Routes.splash,
      ),
    );
  }
}
