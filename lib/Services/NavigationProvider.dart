import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:diyet_ofisim/locator.dart';
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _bottomNavIndex = locator<AppSettings>().defaultNavIndex;

  CircularBottomNavigationController _navigationController =
      CircularBottomNavigationController(0);

  PageController _questionPageController = PageController(
    initialPage: 0,
  );

  List<Widget> _pageStack = [];

  void resetControllerIndex() {
    _navigationController.value = AppSettings().defaultNavIndex;
  }

  void refresh() {
    notifyListeners();
  }

  //ANCHOR Getters Here
  int getBottomNavIndex() => _bottomNavIndex;
  List<Widget> getPageStack() => _pageStack;
  PageController getQuestionPageController() => _questionPageController;
  CircularBottomNavigationController getNavController() =>
      _navigationController;

  //ANCHOR Setters Here
  void setBottomNavIndex(int index, {bool reFresh = true}) {
    _bottomNavIndex = index;
    if (reFresh) refresh();
  }

  void flushStack() {
    _pageStack.clear();
  }

  void pushPage(Widget page) {
    _pageStack.add(page);
  }

  void popPage() {
    _pageStack.removeLast();
    refresh();
  }
}
