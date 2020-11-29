enum Diseases { h1, h2 }

class AppSettings {
  final String appName = "DiyetOfisimApp";
  final int defaultNavIndex = 0;
  //final String _server = "Release";
  final String _server = "Development";
  //final String _server = "OpenTest";
  String getServer() => _server;

  List<String> diseases = ["Hastalık 1", "Hastalık 2"];
}
