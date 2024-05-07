import 'package:detect_license_plate_app/controller/authentication/authentication_cubit.dart';
import 'package:detect_license_plate_app/local_service.dart';
import 'package:detect_license_plate_app/views/page/authentication/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../config/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthenticationCubit _authenticationCubit;

  @override
  void initState() {
    _authenticationCubit = AuthenticationCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authenticationCubit,
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (user) {},
            error: (message) {},
            logOutSuccess: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blueMain,
            automaticallyImplyLeading: false,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, ${GetIt.instance.get<LocalService>().getUser()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _authenticationCubit.logout();
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
