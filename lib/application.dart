import 'package:detect_license_plate_app/local_service.dart';
import 'package:detect_license_plate_app/views/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'views/page/authentication/login/login_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: GetIt.instance.get<LocalService>().getKeyAuth() == false
              ? const LoginPage()
              : const MainPage(),
        );
      },
    );
  }
}
