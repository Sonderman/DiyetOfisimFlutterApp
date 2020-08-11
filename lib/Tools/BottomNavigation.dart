import 'package:diyet_ofisim/Pages/DieticianListPage.dart';
import 'package:diyet_ofisim/Pages/LoginPage.dart';
import 'package:diyet_ofisim/Pages/SearchDatePage.dart';
import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget getNavigatedPage(BuildContext context) {
  //ANCHOR stack de widget varsa o sayfayı döndürür yoksa default veya mevcut indexe göre sayfayı açar
  if (NavigationManager(context).getLastPage() != null) {
    return NavigationManager(context).getLastPage();
  } else {
    UserService userService = locator<UserService>();
    List<Widget> pages = [
      SearchDatePage(),
      DieticianListPage(),
    ];
    return pages[NavigationManager(context).getBottomNavIndex()];
  }
}

Widget bottomNavigationBar(BuildContext context) {
  NavigationManager navigation = NavigationManager(context);
  int currentPosition = navigation.getBottomNavIndex();

  currentPageSetter() {
    navigation.setBottomNavIndex(currentPosition);
  }

  return FancyBottomNavigation(
    initialSelection: currentPosition,
    inactiveIconColor: MyColors().purpleContainer,
    circleColor: MyColors().purpleContainer,
    tabs: [
      TabData(
          iconData: Icons.search,
          title: "Randevu Ara",
          onclick: currentPageSetter),
      TabData(
          iconData: Icons.list,
          title: "Randevularım",
          onclick: currentPageSetter),
      /*TabData(
          iconData: Icons.search, title: "Keşfet", onclick: currentPageSetter),
      TabData(
          iconData: Icons.assignment_ind,
          title: "Profil",
          onclick: currentPageSetter),*/
    ],
    onTabChangedListener: (position) {
      currentPosition = position;
      navigation.setBottomNavIndex(position);
    },
  );
}
