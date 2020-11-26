import 'package:diyet_ofisim/Services/AuthService.dart';
import 'package:diyet_ofisim/Services/Firebase.dart';
import 'package:diyet_ofisim/Services/Repository.dart';
import 'package:diyet_ofisim/Settings/AppSettings.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AppSettings>(AppSettings());
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<DatabaseWorks>(DatabaseWorks());
  locator.registerSingleton<StorageWorks>(StorageWorks());
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<MessagingService>(MessagingService());
  locator.registerSingleton<LoginRegisterService>(LoginRegisterService());
}

//Locator kullanacağın zaman
/*
UserWorks userWorker = locator<UserWorks>();
*/
