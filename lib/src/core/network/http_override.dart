import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  // Preventing connection issues when initiating api calls.
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
