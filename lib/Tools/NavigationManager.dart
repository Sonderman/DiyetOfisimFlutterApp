import 'package:diyet_ofisim/Services/NavigationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationManager {
  late NavigationProvider nav;

  /*
  NOTE stackPage e sayfa eklemek için istediğin yerde bunu çağır :: NavigationManager(context).pushPage(Widget)
  NOTE geri gelmek için bunu çağır :: NavigationManager(context).popPage();
  */

  NavigationManager(BuildContext context) {
    nav = Provider.of<NavigationProvider>(context, listen: false);
  }

  bool onBackButtonPressed() {
    if (isEmpty()) {
      return false;
    } else {
      if (nav.getBottomNavIndex() == 0 &&
          nav.getQuestionPageController().page!.round() > 0) {
        nav.getQuestionPageController().previousPage(
            duration: const Duration(seconds: 1), curve: Curves.bounceOut);
        return true;
      } else {
        popPage();
        return true;
      }
    }
  }

  PageController getQuestionPageController() => nav.getQuestionPageController();

  bool isEmpty() {
    return nav.getPageStack().isEmpty;
  }

  Widget? getLastPage() {
    if (isEmpty()) {
      return null;
    } else {
      return nav.getPageStack().last;
    }
  }

  void popPage() {
    if (!isEmpty()) {
      nav.popPage();
    }
  }

  void pushPage(Widget page, {bool refresh = true}) {
    nav.pushPage(page);
    if (refresh) nav.refresh();
  }

  int getBottomNavIndex() {
    return nav.getBottomNavIndex();
  }

  void setBottomNavIndex(int newIndex, {bool reFresh = true}) {
    if (nav.getBottomNavIndex() != newIndex) {
      nav.setBottomNavIndex(newIndex, reFresh: reFresh);
      nav.flushStack();
    } else if (!isEmpty()) {
      nav.setBottomNavIndex(newIndex, reFresh: reFresh);
      nav.flushStack();
    }
  }
}
