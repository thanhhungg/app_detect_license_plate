import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final Function()? onPress;
  final String iconPath;
  final String buttonText;

  const SignInButton(
      {Key? key,
      this.onPress,
      required this.iconPath,
      required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        onPress?.call();
      },
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26.0,
              height: 26.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
              ),
              child: Image.asset(
                iconPath,
                width: 16.0,
                height: 16.0,
              ),
            ),
            const SizedBox(width: 14.0),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
