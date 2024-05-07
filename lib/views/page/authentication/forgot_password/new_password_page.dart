import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../common/common_text.dart';
import '../login/login_page.dart';

class NewPasswordPage extends StatefulWidget {
  NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  late final TextEditingController _accountController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  late final FocusNode _focusNode = FocusNode();
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
          child: Column(
            children: [
              AppConstants.kSpacingItem120,
              const CommonText(
                'Quên mật khẩu',
                textColor: AppColors.black,
                variant: Variant.h6,
                fontStyle: FontStyle.bold,
              ),
              AppConstants.kSpacingItem16,
              TextFormField(
                controller: _accountController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Tài khoản',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
              ),
              AppConstants.kSpacingItem8,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Đặt lại mật khẩu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
