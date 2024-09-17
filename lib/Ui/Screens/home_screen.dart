// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../Consts/consts.dart';
import '../../Controllers/file_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/users_controller.dart';
import '../../Ui/Screens/cancer_screen.dart';
import '../../Ui/Screens/injuredScreen.dart';
import '../../Ui/Screens/kids_screen.dart';
import '../../Ui/Screens/statistics_screen.dart';
import '../../Ui/Screens/users_screen.dart';
import '../../Ui/Screens/woman_screen.dart';

import 'dead_screen.dart';
import 'main_screen.dart';

class HomeScreen extends StatelessWidget {
  final _controller = SideMenuController();
  final _pageCon = PageController();
  HomeScreen({super.key});
  final HomeController homeController = Get.find<HomeController>();
  final FileController fileController = Get.find<FileController>();
  final UsersController usersController = Get.find<UsersController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            GetBuilder<HomeController>(builder: (context) {
              return SideMenu(
                hasResizer: true,
                controller: _controller,
                backgroundColor: Consts.backgroundColor,
                mode: SideMenuMode.open,
                hasResizerToggle: false,
                builder: (data) {
                  return SideMenuData(
                    footer: ListTile(
                      selected: true,
                      onTap: () => Get.back(),
                      selectedTileColor: Consts.backgroundColor,
                      hoverColor: Colors.blue,
                      title: const Text(
                        'تسجيل خروج',
                        style:
                            TextStyle(color: Color(0xFFfef7ff), fontSize: 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      leading: SizedBox(
                        height: 50.h,
                        width: 30.w,
                        child: SvgPicture.asset('assets/icons/leave.svg',
                            color: const Color(0xFFfef7ff)),
                      ),
                      selectedColor: const Color(0xFFfef7ff),
                    ),
                    defaultTileData: const SideMenuItemTileDefaults(
                      hoverColor: Color(0xFFfef7ff),
                    ),
                    // animItems: const SideMenuItemsAnimationData(),
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 150,
                          maxWidth: 150,
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    items: [
                      const SideMenuItemDataDivider(
                          divider: Divider(
                        color: Color(0xFFfef7ff),
                      )),
                      SideMenuItemDataTile(
                        margin:
                            const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                        isSelected: homeController.index == 0,
                        onTap: () {
                          if (homeController.index != 0) {
                            _pageCon.jumpToPage(0);
                            homeController.index = 0;
                          }
                        },
                        title: 'الصفحة الرئيسية  ',
                        borderRadius: const BorderRadius.all(
                          Radius.circular(3),
                        ),
                        hoverColor: Colors.blue,
                        titleStyle: const TextStyle(
                            color: Color(0xFFfef7ff), fontSize: 16),
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/icons/home.svg',
                              color: const Color(0xFFfef7ff)),
                        ),
                        selectedIcon: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 1,
                            maxWidth: 1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/home.svg'),
                          ),
                        ),
                      ),
                      if (usersController.currentUser!.auths.contains(0))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 1,
                          onTap: () {
                            if (homeController.index != 1) {
                              _pageCon.jumpToPage(1);
                              homeController.index = 1;
                            }
                            fileController.filterItems(
                                '', fileController.daeds);
                            log('************* ${fileController.daeds?.length}');
                          },
                          title: 'الشهداء',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/dead.svg',
                                color: const Color(0xFFfef7ff)),
                          ),
                          selectedIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 1,
                              maxWidth: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset('assets/icons/dead.svg'),
                            ),
                          ),
                        ),
                      if (usersController.currentUser!.auths.contains(1))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 2,
                          onTap: () {
                            if (homeController.index != 2) {
                              _pageCon.jumpToPage(2);
                              homeController.index = 2;
                            }

                            fileController.filterItems(
                                '', fileController.injureds);
                          },
                          title: 'الجرحى',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              'assets/icons/Injured.svg',
                              color: const Color(0xFFfef7ff),
                              height: 20,
                            ),
                          ),
                          selectedIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: SvgPicture.asset('assets/icons/Injured.svg'),
                          ),
                        ),
                      if (usersController.currentUser!.auths.contains(2))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 3,
                          onTap: () {
                            if (homeController.index != 3) {
                              _pageCon.jumpToPage(3);
                              homeController.index = 3;
                            }
                            // fileController.getKidsFiles();
                            fileController.filterItems('', fileController.kids);
                          },
                          title: 'الاطفال',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SvgPicture.asset('assets/icons/kids.svg',
                                color: const Color(0xFFfef7ff)),
                          ),
                          selectedIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SvgPicture.asset('assets/icons/kids.svg'),
                          ),
                        ),
                      if (usersController.currentUser!.auths.contains(3))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 4,
                          onTap: () {
                            if (homeController.index != 4) {
                              _pageCon.jumpToPage(4);
                              homeController.index = 4;
                            }
                            fileController.filterItems(
                                '', fileController.womans);
                          },
                          title: 'نساء',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/woman.svg',
                                color: const Color(0xFFfef7ff)),
                          ),
                          selectedIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 1,
                              maxWidth: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset('assets/icons/woman.svg'),
                            ),
                          ),
                        ),
                      if (usersController.currentUser!.auths.contains(4))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 5,
                          onTap: () {
                            if (homeController.index != 5) {
                              _pageCon.jumpToPage(5);
                              homeController.index = 5;
                            }
                            fileController.filterItems(
                                '', fileController.cancers);
                          },
                          title: 'أورام',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/cancer.svg',
                                color: const Color(0xFFfef7ff)),
                          ),
                          selectedIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 1,
                              maxWidth: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  SvgPicture.asset('assets/icons/cancer.svg'),
                            ),
                          ),
                        ),
                      if (usersController.currentUser!.auths.contains(5))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 6,
                          onTap: () {
                            if (homeController.index != 6) {
                              _pageCon.jumpToPage(6);
                              homeController.index = 6;
                            }
                            usersController.filterItems(
                                '', usersController.users);
                          },
                          title: 'المستخدمين',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/users.svg',
                                color: const Color(0xFFfef7ff)),
                          ),
                          selectedIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 1,
                              maxWidth: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset('assets/icons/users.svg'),
                            ),
                          ),
                        ),
                      if (usersController.currentUser!.auths.contains(5))
                        SideMenuItemDataTile(
                          margin:
                              const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 0),
                          isSelected: homeController.index == 7,
                          onTap: () async {
                            if (homeController.index != 7) {
                              _pageCon.jumpToPage(7);
                              homeController.index = 7;
                            }
                            await fileController.loadData();
                          },
                          title: 'الإحصائيات',
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          hoverColor: Colors.blue,
                          titleStyle: const TextStyle(
                              color: Color(0xFFfef7ff), fontSize: 16),
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/icons/chart.svg',
                                color: const Color(0xFFfef7ff)),
                          ),
                          selectedIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 1,
                              maxWidth: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset('assets/icons/chart.svg'),
                            ),
                          ),
                        ),
                      // SideMenuItemDataTile(
                      //   margin: EdgeInsetsDirectional.fromSTEB(
                      //       4.w, 200.h, 4.h, 0.w),
                      //   isSelected: false,
                      //   onTap: () {
                      //     Get.back();
                      //   },
                      //   title: 'تسجيل خروج',
                      //   borderRadius: const BorderRadius.all(
                      //     Radius.circular(3),
                      //   ),
                      //   hoverColor: Colors.blue,
                      //   titleStyle: const TextStyle(
                      //       color: Color(0xFFfef7ff), fontSize: 16),
                      //   icon: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: SvgPicture.asset('assets/icons/leave.svg',
                      //         color: const Color(0xFFfef7ff)),
                      //   ),
                      //   selectedIcon: ConstrainedBox(
                      //     constraints: const BoxConstraints(
                      //       maxHeight: 1,
                      //       maxWidth: 1,
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: SvgPicture.asset('assets/icons/leave.svg'),
                      //     ),
                      //   ),
                      // ),
                    ],
                    // footer: const Text('Footer'),
                  );
                },
              );
            }),
            Expanded(
                child: PageView(
              controller: _pageCon,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                MainScreen(),
                DeadScreen(),
                Injuredscreen(),
                KidsScreen(),
                WomanScreen(),
                CancerScreen(),
                UserScreen(),
                StatisticsScreen()
              ],
            )),
          ],
        ),
      ),
    );
  }
}
