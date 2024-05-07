import 'package:detect_license_plate_app/views/page/detect/detect_page.dart';
import 'package:detect_license_plate_app/views/page/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/app_string.dart';
import 'manage/manage_page.dart';
import 'train/train_page.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  static const List<Widget> _page = <Widget>[
    ManagePage(),
    DetectPage(),
    TrainPage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.black,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            _selectedIndex = index;
          },
          children: _page,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.create : Icons.create_outlined,
              ),
              label: AppString.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.live_tv : Icons.live_tv_outlined,
              ),
              label: AppString.detect,
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2
                  ? Icons.table_rows
                  : Icons.table_rows_outlined),
              label: AppString.train,
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? Icons.account_circle_rounded
                  : Icons.account_circle_outlined),
              label: AppString.train,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.blueMain,
          unselectedItemColor: AppColors.gray1,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            });
          },
        ));
  }
}
