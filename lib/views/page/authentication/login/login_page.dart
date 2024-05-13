import 'package:detect_license_plate_app/controller/authentication/authentication_cubit.dart';
import 'package:detect_license_plate_app/views/page/authentication/login/signIn_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../config/constants/assets.dart';
import '../../../../services/firabase_email_pass_service.dart';
import '../../../common/show_toast.dart';
import '../../main_page.dart';
import '../forgot_password/forgot_password_page.dart';
import '../signup/sign_up.dart';
import 'build_modal_about.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final FocusNode _focusNode = FocusNode();
  late AuthenticationCubit _authenticationCubit;
  late final WebViewController controllerPrivacy;
  late final WebViewController controllerTos;
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isSigning = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controllerPrivacy = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(AppConstants.privacyURL),
      );
    controllerTos = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(AppConstants.termUrl),
      );
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
              loading: () {
                // showDialog(
                //   context: context,
                //   builder: (context) => const AlertDialog(
                //     elevation: 0,
                //     backgroundColor: Colors.transparent,
                //     content: Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           CircularProgressIndicator(
                //             color: AppColors.white,
                //           ),
                //           SizedBox(
                //             height: 16,
                //           ),
                //           Text(
                //             "Loading...",
                //             style: TextStyle(color: AppColors.white),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );
              },
              success: (data) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                );
              },
              logOutSuccess: () {},
              error: (e) {});
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppConstants.kSpacingItem68,
                    const Icon(
                      Icons.radio_button_checked,
                      color: AppColors.blueMain,
                      size: 100,
                    ),
                    AppConstants.kSpacingItem68,
                    SignInButton(
                      onPress: () {
                        // sign();
                        _authenticationCubit.signInWithGoogle();
                      },
                      iconPath: Assets.icGoogle,
                      buttonText: 'Đăng nhập với Google',
                    ),
                    AppConstants.kSpacingItem24,
                    Container(
                      height: 1,
                      color: AppColors.lightBlack,
                    ),
                    AppConstants.kSpacingItem24,
                    TextFormField(
                      controller: _emailController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: 'Tài khoản',
                        hintText: 'Nhập tài khoản',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        if (!value.contains('@')) {
                          return 'Email không hợp lệ';
                        }
                        return null; // Trả về null nếu không có lỗi
                      },
                    ),
                    AppConstants.kSpacingItem16,
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        hintText: 'Nhập mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu cần ít nhất 6 ký tự';
                        }
                        return null; // Trả về null nếu không có lỗi
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => throw Exception(),
                          child: const Text("Throw Test Exception"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordPage()));
                          },
                          child: const Text('Quên mật khẩu?'),
                        ),
                      ],
                    ),
                    AppConstants.kSpacingItem8,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _signIn();
                      },
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Bạn chưa có tài khoản?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: const Text("Đăng kí"),
                        ),
                      ],
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                color: AppColors.blueMain,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  buildModalAbout(context, controllerPrivacy);
                                },
                            ),
                            const TextSpan(
                              text: ' And ',
                              style: TextStyle(color: AppColors.black),
                            ),
                            TextSpan(
                              text: 'Terms of Use',
                              style: const TextStyle(
                                color: AppColors.blueMain,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  buildModalAbout(context, controllerTos);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSigning = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      User? user = await _auth.signInWithEmailAndPassword(email, password);

      setState(() {
        _isSigning = false;
      });

      if (user != null) {
        showToast(message: "User is successfully signed in");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } else {
        showToast(message: "Sign in failed");
      }
    }
  }
}

sign() async {
  GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication?.accessToken,
    idToken: googleSignInAuthentication?.idToken,
  );
  await FirebaseAuth.instance.signInWithCredential(credential);
}
