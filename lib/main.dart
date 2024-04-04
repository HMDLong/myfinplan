import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/presentation/accounts/accounts_screen.dart';
import 'package:myfinplan/presentation/home/home_screen.dart';
import 'package:myfinplan/presentation/personalize/personal_screen.dart';
import 'package:myfinplan/presentation/plan/plan_screen.dart';
import 'package:myfinplan/presentation/statistics/stats_screen.dart';
import 'package:myfinplan/services/storage/hive/hive_storage.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import "package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

Future<void> main() async {
  await initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initFlutter() async {
  // Init Hive
  await HiveStorageService().init();

  // Init AwesomeNotification
  // NotificationService.initialize();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() => [
        const HomeScreen(),
        const StatisticsScreen(),
        const AccountsScreen(),
        const PlanScreen(),
        const PersonalizeScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.home),
          title: "Tổng quan",
          activeColorPrimary: CupertinoColors.activeBlue,
          activeColorSecondary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.chart_bar_square),
          title: "Thống kê",
          activeColorPrimary: CupertinoColors.activeBlue,
          activeColorSecondary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Boxicons.bx_wallet),
          title: "Tài khoản",
          activeColorPrimary: CupertinoColors.activeBlue,
          activeColorSecondary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.graph_circle),
          title: "Kế hoạch",
          activeColorPrimary: CupertinoColors.activeBlue,
          activeColorSecondary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.bars),
          title: "Cá nhân",
          activeColorPrimary: CupertinoColors.activeBlue,
          activeColorSecondary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];

  void setupAppOnFirstLaunch() async {
    // check first launch
    final sharedRef = await SharedPreferences.getInstance();
    final isFirstLaunch = sharedRef.getBool("is_first_launch");
    dev.log("is_first_launch = $isFirstLaunch");
    if (isFirstLaunch != null) return; // not first launch, do nothing

    // is first lauch, setups:
    // 1. save pre defined categories
    dev.log("Start init");
    for (var cateData in predefinedCategories) {
      final cate = Category(id: cateData[0], name: cateData[1], icon: CustomIconData.fromMaterialIconData(cateData[2]));
      ref.read(categoryNotifierProvider.notifier).addCategory(cate);
    }
    // 2. init accounts with 1 cash account
    await ref.read(accountsProvider.notifier).init();
    dev.log("Done init");
    await sharedRef.setBool("is_first_launch", false);
  }

  @override
  void initState() {
    // NotificationService.initListeners();
    super.initState();
    setupAppOnFirstLaunch();
  }

  @override
  void dispose() async {
    HiveStorageService().close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersistentTabView(
        context,
        controller: _tabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style7,
      ),
    );
  }
}
