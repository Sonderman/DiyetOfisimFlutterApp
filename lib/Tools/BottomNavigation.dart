import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:diyet_ofisim/Models/Dietician.dart';
import 'package:diyet_ofisim/Pages/Patient/HomePage.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Tools/NavigationManager.dart';
import 'package:diyet_ofisim/Tools/PageComponents.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';

Widget getNavigatedPage(BuildContext context) {
  //ANCHOR stack de widget varsa o sayfayı döndürür yoksa default veya mevcut indexe göre sayfayı açar
  if (NavigationManager(context).getLastPage() == null) {
    NavigationManager(context).pushPage(const HomePage());
    return NavigationManager(context).getLastPage()!;
  } else {
    return NavigationManager(context).getLastPage()!;
  }
}

Widget bottomNavigationBar(BuildContext context, rootPageState) {
  NavigationManager navigation = NavigationManager(context);
  int currentPosition = navigation.getBottomNavIndex();
  var navController = navigation.nav.getNavController();

  currentPageSetter() {
    //ANCHOR - Burada hem RootPage Hemde içerideki page rebuild olur
    rootPageState.setState(() {
      navigation.setBottomNavIndex(currentPosition);
    });
  }

  if (locator<UserService>().userModel.runtimeType == Dietician) {
    /*return FancyBottomNavigation(
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
    */
    return CircularBottomNavigation(
      [
        TabItem(Icons.date_range_sharp, "Takvimim",
            Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
        TabItem(Icons.message_rounded, "Görüşmeler",
            Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
        TabItem(Icons.account_circle_rounded, "Profilim",
            Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
      ],
      controller: navController,
      barHeight: PageComponents(context).heightSize(6),
      barBackgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (position) {
        currentPosition = position!;
        currentPageSetter();
      },
    );
  } else {
    /* return BottomNavigationBar(
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
    );*/

    return CircularBottomNavigation(
      [
        TabItem(Icons.home, "Anasayfa", Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
        TabItem(Icons.date_range_sharp, "Randevularım",
            Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
        TabItem(Icons.message_rounded, "Görüşmeler",
            Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
        TabItem(Icons.account_circle_rounded, "Profilim",
            Colors.deepPurpleAccent.shade100,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.shade100,
            )),
      ],
      controller: navController,
      barHeight: PageComponents(context).heightSize(6),
      barBackgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (position) {
        currentPosition = position!;
        currentPageSetter();
      },
    );
  }
}
