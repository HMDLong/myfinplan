import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/base_category.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/plan/distributor.dart';
import 'package:myfinplan/screens/accounts/accounts_screen.dart';
import 'package:myfinplan/screens/home/home_screen.dart';
import 'package:myfinplan/screens/personalize/personal_screen.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/screens/statistics/stats_screen.dart';
import 'package:myfinplan/services/notification/notification_service.dart';
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
  await HiveStorageService().initialize();

  // Init AwesomeNotification
  await NotificationService.initialize();
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

  _buildNavBarItem(String title, Icon icon) => PersistentBottomNavBarItem(
        icon: icon,
        title: title,
        activeColorPrimary: CupertinoColors.activeBlue,
        activeColorSecondary: CupertinoColors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      );

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        _buildNavBarItem("Tổng quan", const Icon(CupertinoIcons.home)),
        _buildNavBarItem("Thống kê", const Icon(CupertinoIcons.chart_bar_square)),
        _buildNavBarItem("Tài khoản", const Icon(Boxicons.bx_wallet)),
        _buildNavBarItem("Kế hoạch", const Icon(CupertinoIcons.graph_circle)),
        _buildNavBarItem("Cá nhân", const Icon(CupertinoIcons.bars)),
      ];

  void setupAppOnFirstLaunch() async {
    // check first launch
    final sharedRef = await SharedPreferences.getInstance();
    final isFirstLaunch = sharedRef.getBool("is_first_launch");
    dev.log("is_first_launch = $isFirstLaunch");
    if (isFirstLaunch != null) return; // not first launch, do nothing

    // is first lauch, setups:
    // 1. save pre defined categories
    dev.log("Start init...");
    for (var cateData in predefinedCategories) {
      final cate = Category(id: cateData[0], name: cateData[1], icon: CustomIconData.fromMaterialIconData(cateData[2]));
      ref.read(categoryNotifierProvider.notifier).addCategory(cate);
    }
    // 2. init accounts with 1 cash account
    await ref.read(accountsProvider.notifier).init();
    await ref.read(planDistNotifierProvider.notifier).init();
    dev.log("Done init");
    await sharedRef.setBool("is_first_launch", false);
  }

  @override
  void initState() {
    super.initState();
    NotificationService.initListeners();
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
