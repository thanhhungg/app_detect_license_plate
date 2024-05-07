import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/models/result_detect.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:detect_license_plate_app/views/page/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../../config/constants/app_colors.dart';

class ResultDetectPage extends StatefulWidget {
  final List<LicensePlateResult> data;
  const ResultDetectPage({super.key, required this.data});

  @override
  State<ResultDetectPage> createState() => _ResultDetectPageState();
}

class _ResultDetectPageState extends State<ResultDetectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.blueMain,
        title: const Text(
          'Result Detect',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      widget.data[index].frame.toString(),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text('License Plate: ${widget.data[index].label}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.blueMain)),
                    subtitle: Column(
                      children: [
                        Text('Confidence: ${widget.data[index].confidence}'),
                        Text('Timestamp: ${widget.data[index].timestamp}')
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  btnText: "Manage",
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  },
                  sizeType: SizeType.large,
                  backgroundColor: AppColors.blueMain,
                  btnTextColorEnable: AppColors.white,
                ),
              ],
            ),
            AppConstants.kSpacingItem16,
          ],
        ),
      ),
    );
  }
}
