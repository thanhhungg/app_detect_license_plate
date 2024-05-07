import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../common/common_text.dart';
import 'new_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  late final TextEditingController _gmailController = TextEditingController();
  late final TextEditingController _fillKeyController = TextEditingController();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                controller: _gmailController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Gmail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              AppConstants.kSpacingItem16,
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                    Navigator.pop(context);
                  },
                  child: const Text('Gửi mã'),
                ),
              ),
              AppConstants.kSpacingItem16,
              TextFormField(
                controller: _fillKeyController,
                decoration: InputDecoration(
                  labelText: 'Nhập mã',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              AppConstants.kSpacingItem16,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(_focusNode);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPasswordPage()));
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
