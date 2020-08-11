import 'package:diyet_ofisim/Services/Firebase.dart';
import 'package:diyet_ofisim/locator.dart';

class EventSettings {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  List<String> categoryItems;
  List<List<String>> subCategoryItems;
  EventSettings() {
    getCategories();
    getSubCategories();
  }
  void getCategories() async {
    //categoryItems = await firebaseDatabaseWorks.getEventCategories();
  }

  void getSubCategories() async {
    //subCategoryItems = await firebaseDatabaseWorks.getEventSubCategories();
  }
}
