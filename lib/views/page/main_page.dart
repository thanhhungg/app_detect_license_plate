import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:camera/camera.dart';
import 'package:detect_license_plate_app/views/page/detect/detect_page.dart';
import 'package:detect_license_plate_app/views/page/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../config/constants/app_colors.dart';
import 'detect/camera_detect.dart';
import 'manage/manage_home.dart';
import 'train/train_page.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  final _page = [
    const ManageHome(),
    const DetectPage(),
    const TrainPage(),
    const ProfileScreen(),
  ];
  final iconList = <IconData>[
    Icons.save,
    Icons.screen_search_desktop_outlined,
    Icons.track_changes,
    Icons.settings_outlined,
  ];
  final titles = [
    'Manage',
    'Detect',
    'Train',
    'Profile',
  ];
  late List<CameraDescription> cameras;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blueMain,
        elevation: 4,
        onPressed: () async {
          cameras = await availableCameras();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraDetectPage(cameras: cameras)),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blueMain.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 8,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.camera_alt,
              color: AppColors.white,
              size: 32,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        backgroundColor: AppColors.white,
        tabBuilder: (index, isActive) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 4),
                Icon(
                  iconList[index],
                  size: 24,
                  color: isActive ? AppColors.blueMain : AppColors.gray,
                ),
                const SizedBox(height: 4),
                Text(
                  titles[index],
                  style: _bottomNavIndex == index
                      ? const TextStyle(color: AppColors.blueMain)
                      : const TextStyle(color: AppColors.gray),
                ),
              ],
            ),
          );
        },
        notchMargin: 8,
        activeIndex: _bottomNavIndex,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        blurEffect: true,
        onTap: (index) {
          setState(
            () => _bottomNavIndex = index,
          );
        },
      ),
      body: _page[_bottomNavIndex],
    );
  }
}
