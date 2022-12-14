import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gaosapp/helpers/api_helper.dart';
import 'package:gaosapp/models/models.dart';
import 'package:gaosapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final Empresa empresa;

  const HomeScreen({Key? key, required this.user, required this.empresa})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  String _codigo = '';
  int? _nroConexion = 0;

  String direccion = '';

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//*****************************************************************************
//************************** INITSTATE *****************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff004f95),
        title: const Text('GaosApp'),
        centerTitle: true,
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    final alto = MediaQuery.of(context).size.height;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffffffff),
              Color(0xffffffff),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CachedNetworkImage(
                imageUrl: widget.empresa.logoFullPath.toString(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: alto * 0.1,
                placeholder: (context, url) => const Image(
                  image: AssetImage('assets/loading.gif'),
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   child: Image.asset(
            //     "assets/kplogo.png",
            //     height: alto * 0.1,
            //   ),
            // ),
            SizedBox(height: alto * 0.1),
            Text(
              'Bienvenido/a ${widget.user.fullName}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff004f95)),
            ),
            SizedBox(height: alto * 0.1),
            Text(
              'Empresa: ${widget.empresa.nombreempresa}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff004f95)),
            ),
          ],
        ));
  }

  Widget _getMenu() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff004f95),
              Color(0xff004f95),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // const Image(
                  //   image: AssetImage('assets/kplogo.png'),
                  //   width: 200,
                  // ),
                  CachedNetworkImage(
                    imageUrl: widget.empresa.logoFullPath.toString(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.contain,
                    width: 200,
                    height: 50,
                    placeholder: (context, url) => const Image(
                      image: AssetImage('assets/loading.gif'),
                      fit: BoxFit.cover,
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Usuario: ",
                        style: (TextStyle(
                            color: Color(0xff004f95),
                            fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        widget.user.fullName,
                        style: (const TextStyle(color: Color(0xff004f95))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            widget.user.habilitaSSHH == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.format_list_bulleted,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Inspecciones S&H',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            //guardarLocalizacion();
                            String? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InspeccionesMenuScreen(
                                  user: widget.user,
                                  empresa: widget.empresa,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: const Text('Configuraci??n',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      //guardarLocalizacion();
                      String? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AjustesScreen(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tileColor: const Color(0xff8c8c94),
              title: const Text('Cerrar Sesi??n',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOGOUT ************************************
//*****************************************************************************

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

//*****************************************************************************
//************************** METODO GETPOSITION **********************************
//*****************************************************************************

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localizaci??n est?? negado.'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localizaci??n est?? negado permanentemente. No se puede requerir este permiso.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _positionUser.latitude, _positionUser.longitude);
      direccion = placemarks[0].street.toString() +
          " - " +
          placemarks[0].locality.toString() +
          " - " +
          placemarks[0].country.toString();
      ;
    }
  }
}
