import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/AuthController.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AuthController authController = Get.put(AuthController());
  await authController.loadToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrustGov',
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
