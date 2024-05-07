import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../services/firabase_email_pass_service.dart';
import '../../../common/show_toast.dart';
import '../../main_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isSigningUp = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppConstants.kSpacingItem120,
                const Icon(
                  Icons.radio_button_checked,
                  color: AppColors.blueMain,
                  size: 100,
                ),
                AppConstants.kSpacingItem16,
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'Tài khoản',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                AppConstants.kSpacingItem8,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Gmail',
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
                AppConstants.kSpacingItem8,
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _signUp();
                    },
                    child: const Text('Đăng kí'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSigningUp = true;
      });

      String username = _userNameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      setState(() {
        isSigningUp = false;
      });
      if (user != null) {
        showToast(message: "User is successfully created");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      } else {
        showToast(message: "Some error happend");
      }
    }
  }
}
