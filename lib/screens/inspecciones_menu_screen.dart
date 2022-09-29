import 'package:flutter/material.dart';
import 'package:gaosapp/models/models.dart';
import 'package:gaosapp/screens/screens.dart';

class InspeccionesMenuScreen extends StatefulWidget {
  final User user;
  final Empresa empresa;
  const InspeccionesMenuScreen(
      {Key? key, required this.user, required this.empresa})
      : super(key: key);

  @override
  _InspeccionesMenuScreenState createState() => _InspeccionesMenuScreenState();
}

class _InspeccionesMenuScreenState extends State<InspeccionesMenuScreen> {
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
      appBar: AppBar(
        title: const Text('Menú Inspecciones'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.format_list_bulleted,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 35,
                ),
                Text('Mis Inspecciones',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    )),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 24, 207, 36),
              minimumSize: const Size(100, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspeccionesListaScreen(
                    user: widget.user,
                    empresa: widget.empresa,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.photo_album,
                  size: 28,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 35,
                ),
                Text('Fotos Insp. últ. 72hs',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    )),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 24, 207, 36),
              minimumSize: const Size(100, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspeccionesFotosScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
