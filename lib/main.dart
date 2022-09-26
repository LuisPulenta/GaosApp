import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaosapp/models/models.dart';
import 'package:gaosapp/models/user.dart';
import 'package:gaosapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
  late User _user;
  int _nroConexion = 0;

  @override
  void initState() {
    super.initState();
    _getHome();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Rowing App',
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Color.fromARGB(255, 24, 207, 36),
            ),
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 24, 207, 36),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff004f95), foregroundColor: Colors.white),
      ),
      home: _isLoading
          ? const WaitScreen()
          : _showLoginPage
              ? const LoginScreen()
              : HomeScreen(
                  user: _user,
                  nroConexion: _nroConexion,
                ),
    );
  }

  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRemembered = prefs.getBool('isRemembered') ?? false;

    if (isRemembered) {
      String? userBody = prefs.getString('userBody');
      String date = prefs.getString('date').toString();
      int nroConexion = prefs.getInt('nroConexion') as int;
      String dateAlmacenada = date.substring(0, 10);
      String dateActual = DateTime.now().toString().substring(0, 10);
      if (userBody != null) {
        var decodedJson = jsonDecode(userBody);
        _user = User.fromJson(decodedJson);
        _nroConexion = nroConexion;
        if (dateAlmacenada != dateActual) {
          _showLoginPage = true;
        } else {
          _showLoginPage = false;
        }
      }
    }

    _isLoading = false;
    setState(() {});
  }
}
