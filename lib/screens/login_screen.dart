import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaosapp/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:gaosapp/helpers/api_helper.dart';
import 'package:gaosapp/helpers/constants.dart';
import 'package:gaosapp/components/loader_component.dart';
import 'package:gaosapp/models/models.dart';
import 'package:device_information/device_information.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gaosapp/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _isRunning = false;

  // String _email = '';
  // String _password = '';
  String _email = 'LNUNEZ';
  String _password = 'LNUNEZ';
  TextEditingController _passwordController = TextEditingController();

  String _emailError = '';
  bool _emailShowError = false;
  late Empresa _empresa;

  String _passwordError = '';
  bool _passwordShowError = false;

  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

  bool _rememberme = true;
  bool _passwordShow = false;
  bool _showLoader = false;

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
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _isRunning = false;
    _empresa = Empresa(
        idEmpresa: 0,
        nombreempresa: '',
        direccion: '',
        telefono: '',
        carpetaImagenes: '',
        mensageSSHH: '',
        activo: false,
        logoEmpresa: '',
        logoFullPath: '');
    initPlatformState();
    _getPosition();
    setState(() {});
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff8c8c94),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 0),
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
                  SizedBox(
                    height: alto * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Image.asset(
                      "assets/kplogo.png",
                      height: alto * 0.1,
                    ),
                  ),
                  SizedBox(
                    height: alto * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.version,
                        style: const TextStyle(
                            fontSize: 20, color: Color(0xff004f95)),
                      ),
                    ],
                  ),
                ],
              )),
          Transform.translate(
            offset: Offset(0, -alto * 0.1),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: alto * 0.2, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _showEmail(),
                        _showPassword(),
                        const SizedBox(
                          height: 10,
                        ),
                        _showRememberme(),
                        _showButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: alto * 0.8,
            left: 100,
            right: 100,
            child: Container(
              width: 100,
              height: 100,
              child: BackGround(
                child: Container(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWEMAIL --------------------------
//-----------------------------------------------------------------

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Color.fromARGB(255, 24, 207, 36),
        ),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 24, 207, 36))),
              hintText: 'Usuario...',
              labelText: 'Usuario',
              errorText: _emailShowError ? _emailError : null,
              prefixIcon: const Icon(Icons.person),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          onChanged: (value) {
            _email = value;
          },
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWPASSWORD -----------------------
//-----------------------------------------------------------------

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        controller: _passwordController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    width: 1, color: const Color.fromARGB(255, 24, 207, 36))),
            hintText: 'Contraseña...',
            labelText: 'Contraseña',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _passwordShow
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordShow = !_passwordShow;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWREMEMBERME ---------------------
//-----------------------------------------------------------------

  _showRememberme() {
    return CheckboxListTile(
      title: const Text('Recordarme:'),
      value: _rememberme,
      activeColor: Color.fromARGB(255, 24, 207, 36),
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTONS ------------------------
//-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Iniciar Sesión'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 24, 207, 36),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _login(),
            ),
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOGIN *************************************
//*****************************************************************************

  void _login() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    setState(() {
      _passwordShow = false;
    });

    if (!validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Email': _email,
      'password': _password,
    };

    var url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
        _showLoader = false;
      });
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var user = User.fromJson(decodedJson);

    if (user.contrasena.toLowerCase() != _password.toLowerCase()) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
      });
      return;
    }

    if (user.habilitaAPP != 1) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Usuario no habilitado';
      });
      return;
    }

    Response response2 = await ApiHelper.getEmpresa(user.idEmpresa);
    _empresa = response2.result;

    var body2 = jsonEncode(_empresa.toJson());

    if (_rememberme) {
      _storeUser(body, body2);
    }

    // Agregar registro a  websesion

    Random r = Random();
    int resultado = r.nextInt((99999999 - 10000000) + 1) + 10000000;
    double hora = (DateTime.now().hour * 3600 +
            DateTime.now().minute * 60 +
            DateTime.now().second +
            DateTime.now().millisecond * 0.001) *
        100;

    WebSesion webSesion = WebSesion(
        nroConexion: resultado,
        usuario: user.idUsuario.toString(),
        iP: _imeiNo,
        loginDate: DateTime.now().toString(),
        loginTime: hora.round(),
        modulo: 'App-${user.codigoCausante}',
        logoutDate: "",
        logoutTime: 0,
        conectAverage: 0,
        id_ws: 0,
        versionsistema: Constants.version);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nroConexion', resultado);

    // Si hay internet subir al servidor websesion

    connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await _postWebSesion(webSesion);
    }

    //Guarda ubicación del Usuario en Tabla UsuariosGeos
    _isRunning = true;

    setState(() {
      _showLoader = false;
    });

    if (user.contrasena == "123456") {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Es la primera vez que ingresa a la App. Deber cambiar su Contraseña,',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      _password = '';
      _passwordController.text = '';
      setState(() {});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(
            user: user,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
            empresa: _empresa,
            nroConexion: webSesion.nroConexion,
          ),
        ),
      );
    }
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Usuario';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else if (_password.length < 6) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'La Contraseña debe tener al menos 6 caracteres';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValid;
  }

  void _storeUser(String body, String body2) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
    await prefs.setString('empresaBody', body2);
    await prefs.setString('date', DateTime.now().toString());
  }

//*****************************************************************************
//******************** METODO POSTWEBSESION ***********************************
//*****************************************************************************

  Future<void> _postWebSesion(WebSesion webSesion) async {
    Map<String, dynamic> requestWebSesion = {
      'nroConexion': webSesion.nroConexion,
      'usuario': webSesion.usuario,
      'iP': webSesion.iP,
      'loginDate': webSesion.loginDate,
      'loginTime': webSesion.loginTime,
      'modulo': webSesion.modulo,
      'logoutDate': webSesion.logoutDate,
      'logoutTime': webSesion.logoutTime,
      'conectAverage': webSesion.conectAverage,
      'id_ws': webSesion.id_ws,
      'versionsistema': webSesion.versionsistema,
    };

    Response response =
        await ApiHelper.post('/api/WebSesions/', requestWebSesion);
  }

//*****************************************************************************
//************************** METODO INITPLATFORMSTATE *************************
//*****************************************************************************

  Future<void> initPlatformState() async {
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.

    var status = await Permission.phone.status;

    if (status.isDenied) {
      await showDialog(
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
                        'La App necesita que habilite el Permiso de acceso al teléfono para registrar el IMEI del celular con que se loguea.'),
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
      openAppSettings();
      //exit(0);
    }

    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;
    } on PlatformException catch (e) {
      platformVersion = '${e.message}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = "Running on :$platformVersion";
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
      _apiLevel = apiLevel;
      _deviceName = deviceName;
      _productName = productName;
      _cpuType = cpuType;
      _hardware = hardware;
    });
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
                      Text('El permiso de localización está negado.'),
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
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
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
    }
  }
}
