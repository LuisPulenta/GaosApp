import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:gaosapp/components/loader_component.dart';
import 'package:gaosapp/helpers/api_helper.dart';
import 'package:gaosapp/models/models.dart';
import 'package:gaosapp/models/response.dart';

class ChangePasswordScreen extends StatefulWidget {
  final User user;
  const ChangePasswordScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _showLoader = false;

  String _currentPassword = '';
  String _currentPasswordError = '';
  bool _currentPasswordShowError = false;
  TextEditingController _currentPasswordController = TextEditingController();

  String _newPassword = '';
  String _newPasswordError = '';
  bool _newPasswordShowError = false;
  TextEditingController _newPasswordController = TextEditingController();

  String _confirmPassword = '';
  String _confirmPasswordError = '';
  bool _confirmPasswordShowError = false;
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cambio de Contraseña'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                _showCurrentPassword(),
                _showNewPassword(),
                _showConfirmPassword(),
                _showButtons(),
              ],
            ),
            _showLoader
                ? const LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

  Widget _showCurrentPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la contraseña actual...',
          labelText: 'Contraseña actual',
          errorText: _currentPasswordShowError ? _currentPasswordError : null,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _currentPassword = value;
        },
      ),
    );
  }

  Widget _showNewPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la nueva contraseña...',
          labelText: 'Nueva Contraseña',
          errorText: _newPasswordShowError ? _newPasswordError : null,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _newPassword = value;
        },
      ),
    );
  }

  Widget _showConfirmPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Confirmación de contraseña...',
          labelText: 'Confirmación de contraseña',
          errorText: _confirmPasswordShowError ? _confirmPasswordError : null,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _confirmPassword = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showChangePassword(),
        ],
      ),
    );
  }

  Widget _showChangePassword() {
    return Expanded(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock),
            SizedBox(
              width: 15,
            ),
            Text('Cambiar contraseña'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 24, 207, 36),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _save(),
      ),
    );
  }

  void _save() async {
    if (!validateFields()) {
      return;
    }
    _changePassword();
  }

  bool validateFields() {
    bool isValid = true;

    if (_currentPassword.length < 6) {
      isValid = false;
      _currentPasswordShowError = true;
      _currentPasswordError =
          'Debes ingresar tu Contraseña actual de al menos 6 caracteres';
    } else {
      _currentPasswordShowError = false;
    }

    if (_newPassword.length < 6) {
      isValid = false;
      _newPasswordShowError = true;
      _newPasswordError =
          'Debes ingresar una Contraseña de al menos 6 caracteres';
    } else {
      _newPasswordShowError = false;
    }

    if (_confirmPassword.length < 6) {
      isValid = false;
      _confirmPasswordShowError = true;
      _confirmPasswordError =
          'Debes ingresar una Confirmación de Contraseña de al menos 6 caracteres';
    } else {
      _confirmPasswordShowError = false;
    }

    if (_newPassword.length > 5 &&
        _confirmPassword.length > 5 &&
        _confirmPassword != _newPassword) {
      isValid = false;
      _newPasswordShowError = true;
      _confirmPasswordShowError = true;
      _newPasswordError = 'La contraseña y la confirmación no son iguales';
      _confirmPasswordError = 'La contraseña y la confirmación no son iguales';
    }
    // else {
    //   _newPasswordShowError = false;
    //   _confirmPasswordShowError = false;
    // }

    if (_currentPassword.toLowerCase() !=
        widget.user.contrasena.toLowerCase()) {
      isValid = false;
      _currentPasswordShowError = true;
      _currentPasswordError = 'Error en el ingreso de tu contraseña actual';
    } else {
      _currentPasswordShowError = false;
    }

    setState(() {});

    return isValid;
  }

  void _changePassword() async {
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
      'idusuario': widget.user.idUsuario,
      'password': _newPassword,
    };

    Response response = await ApiHelper.put(
        '/api/Account/', widget.user.idUsuario.toString(), request);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: 'Su contraseña ha sido cambiada con éxito.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ]);

    Navigator.pop(context, 'yes');
  }
}
