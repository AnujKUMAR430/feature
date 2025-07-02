import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:reel_section/bindings/app_bindings.dart';
import 'package:reel_section/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bluecs Limited',
      getPages: AppRoutes().getPages(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      initialBinding: AppBindings(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
