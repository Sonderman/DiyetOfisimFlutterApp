import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Firebase.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator({FirebaseApp app}) {
  locator.registerSingleton<AppSettings>(AppSettings());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<DatabaseWorks>(DatabaseWorks(app));
  locator.registerSingleton<StorageWorks>(StorageWorks());
  locator.registerSingleton<UserService>(UserService());

  //locator.registerSingleton<LoginRegisterService>(LoginRegisterService());
}

//Locator kullanacağın zaman
/*
UserWorks userWorker = locator<UserWorks>();
*/
