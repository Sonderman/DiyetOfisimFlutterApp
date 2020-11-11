import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/ChatPage.dart';
import 'package:diyet_ofisim/Pages/Dietician/MyCalendarPage.dart';
import 'package:diyet_ofisim/Pages/Dietician/ProfilePage.dart';
import 'package:diyet_ofisim/Pages/Patient/DieticianListPage.dart';
import 'package:diyet_ofisim/Pages/Patient/HomePage.dart';
import 'package:diyet_ofisim/Pages/SearchDatePage.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/assets/Colors.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

Widget getNavigatedPage(BuildContext context) {
  //ANCHOR stack de widget varsa o sayfayı döndürür yoksa default veya mevcut indexe göre sayfayı açar
  if (NavigationManager(context).getLastPage() != null) {
    return NavigationManager(context).getLastPage();
  } else {
    UserService userService = locator<UserService>();
    //ANCHOR hasta sayfaları burada
    List<Widget> patientPages = [
      HomePage(),
      SearchDatePage(),
      ChatPage(),
      DieticianListPage(),
    ];
    //ANCHOR diyetisyen sayfaları burada
    List<Widget> dieticianPages = [ChatPage(), MyCalendarPage(), ProfilePage()];

    if (userService.userModel.runtimeType == Dietician)
      return dieticianPages[NavigationManager(context).getBottomNavIndex()];
    else
      return patientPages[NavigationManager(context).getBottomNavIndex()];
  }
}

Widget bottomNavigationBar(BuildContext context, _rootPageState) {
  NavigationManager navigation = NavigationManager(context);
  int currentPosition = navigation.getBottomNavIndex();

  currentPageSetter() {
    //ANCHOR - Burada hem RootPage Hemde içerideki page rebuild olur
    _rootPageState.setState(() {
      navigation.setBottomNavIndex(currentPosition);
    });
  }

  if (locator<UserService>().userModel.runtimeType == Dietician)
    return FancyBottomNavigation(
      initialSelection: currentPosition,
      inactiveIconColor: MyColors().purpleContainer,
      circleColor: MyColors().purpleContainer,
      tabs: [
        TabData(
          iconData: Icons.chat,
          title: "Görüşmeler",
        ),
        TabData(
          iconData: Icons.calendar_today,
          title: "Takvim",
        ),
        TabData(iconData: Icons.assignment_ind, title: "Profil"),
      ],
      onTabChangedListener: (position) {
        currentPosition = position;
        currentPageSetter();
      },
    );
  else
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Anasayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Randevularım',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Mesajlar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_ind),
          label: 'Profilim',
        ),
      ],
      currentIndex: currentPosition,
      selectedItemColor: Colors.amber[800],
      onTap: (position) {
        currentPosition = position;
        currentPageSetter();
      },
    );
}
