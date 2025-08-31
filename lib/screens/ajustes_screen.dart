import 'package:flutter/material.dart';
import 'package:gaosapp/models/models.dart';
import 'package:gaosapp/screens/screens.dart';

class AjustesScreen extends StatefulWidget {
  final User user;
  const AjustesScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  //*****************************************************************************
  //************************** DEFINICION DE VARIABLES **************************
  //*****************************************************************************

  //*****************************************************************************
  //************************** INIT STATE ***************************************
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Configuración'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.password_outlined, size: 28, color: Colors.black),
                  SizedBox(width: 35),
                  Text(
                    'Cambiar Contraseña',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 24, 207, 36),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangePasswordScreen(user: widget.user),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
