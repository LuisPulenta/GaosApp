import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gaosapp/components/loader_component.dart';
import 'package:gaosapp/helpers/api_helper.dart';
import 'package:gaosapp/models/obra.dart';
import 'package:gaosapp/models/response.dart';
import 'package:gaosapp/models/user.dart';

class ObrasScreen extends StatefulWidget {
  final User user;
  final int opcion;
  final int cliente;
  const ObrasScreen({
    Key? key,
    required this.user,
    required this.opcion,
    required this.cliente,
  }) : super(key: key);

  @override
  _ObrasScreenState createState() => _ObrasScreenState();
}

class _ObrasScreenState extends State<ObrasScreen> {
  //*****************************************************************************
  //************************** DEFINICION DE VARIABLES **************************
  //*****************************************************************************

  List<Obra> _obras = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  Obra obraSelected = Obra(
    nroObra: 0,
    nombreObra: '',
    elempep: '',
    observaciones: '',
    finalizada: 0,
    supervisore: '',
    codigoEstado: '',
    modulo: '',
    grupoAlmacen: '',
    obrasDocumentos: [],
    idCliente: 0,
    central: '',
    direccion: '',
  );

  //*****************************************************************************
  //************************** INIT STATE ***************************************
  //*****************************************************************************

  @override
  void initState() {
    super.initState();
    _getObras();
  }

  //*****************************************************************************
  //************************** PANTALLA *****************************************
  //*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: widget.user.habilitaSSHH == 0
            ? widget.user.modulo == 'ObrasTasa'
                  ? const Text('Obras Tasa')
                  : Text('Obras ' + widget.user.modulo)
            : const Text('Obras'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter,
                  icon: const Icon(Icons.filter_none),
                )
              : IconButton(
                  onPressed: _showFilter,
                  icon: const Icon(Icons.filter_alt),
                ),
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO FILTER --------------------------
  //-----------------------------------------------------------------------------

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Obra> filteredList = [];
    for (var obra in _obras) {
      if (obra.nombreObra.toLowerCase().contains(_search.toLowerCase()) ||
          obra.elempep.toLowerCase().contains(_search.toLowerCase()) ||
          obra.modulo!.toLowerCase().contains(_search.toLowerCase()) ||
          obra.nroObra.toString().toLowerCase().contains(
            _search.toLowerCase(),
          )) {
        filteredList.add(obra);
      }
    }

    setState(() {
      _obras = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO REMOVEFILTER --------------------------
  //-----------------------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getObras();
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO SHOWFILTER --------------------------
  //-----------------------------------------------------------------------------

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Obras'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Nombre o N° de Obra o en OP/N° de Fuga o en Módulo: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _filter(),
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO GETCONTENT --------------------------
  //-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showObrasCount(),
        Expanded(child: _obras.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO SHOWOBRASCOUNT ------------------------
  //-----------------------------------------------------------------------------

  Widget _showObrasCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            "Cantidad de Obras: ",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _obras.length.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO NOCONTENT -----------------------------
  //-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Obras con ese criterio de búsqueda'
              : 'No hay Obras registradas',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ METODO GETLISTVIEW ---------------------------
  //-----------------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getObras,
      child: ListView(
        children: _obras.map((e) {
          return Card(
            color: const Color.fromARGB(255, 221, 221, 239),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                obraSelected = e;
                _goInfoObra(e);
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "N° Obra: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff004f95),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          e.nroObra.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const Text(
                                        "Def. Proy.: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff004f95),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          e.elempep,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Nombre: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff004f95),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.nombreObra,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Dirección: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff004f95),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: e.direccion != null
                                            ? Text(
                                                e.direccion!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            : const Text(''),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Supervisor: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff004f95),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: e.supervisore != null
                                            ? Text(
                                                e.supervisore!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            : const Text(''),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        "Central: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff004f95),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: e.central != null
                                            ? Text(
                                                e.central!,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            : const Text(''),
                                      ),
                                      // const SizedBox(
                                      //   width: 20,
                                      // ),
                                      // const Text("Fotos y Doc: ",
                                      //     style: TextStyle(
                                      //       fontSize: 12,
                                      //       color: Color(0xff004f95),
                                      //       fontWeight: FontWeight.bold,
                                      //     )),
                                      // Text(e.obrasDocumentos.length.toString(),
                                      //     style: const TextStyle(
                                      //       fontSize: 12,
                                      //     )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //*****************************************************************************
  //************************** METODO GETOBRAS **********************************
  //*****************************************************************************

  Future<void> _getObras() async {
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
        message: 'Verifica que estés conectado a Internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = Response(isSuccess: false);

    //****** 23/8/2022 se vuelve atrás esto y se deja como estaba antes ******
    // if (widget.user.habilitaSSHH == 1) {
    //   response = await ApiHelper.getObrasTodas();
    // } else {
    //   response = await ApiHelper.getObras(widget.user.modulo);
    // }

    response = await ApiHelper.getObras(widget.cliente);

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
        ],
      );
      return;
    }

    setState(() {
      _obras = response.result;
      _obras.sort((a, b) {
        return a.nombreObra.toString().toLowerCase().compareTo(
          b.nombreObra.toString().toLowerCase(),
        );
      });
    });
  }

  //*****************************************************************************
  //************************** METODO GOINFOOBRA ********************************
  //*****************************************************************************

  void _goInfoObra(Obra obra) async {
    if (widget.opcion == 1) {
      // String? result = await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ObraInfoScreen(
      //               user: widget.user,
      //               obra: obra,
      //             ),
      //             ));
      // if (result == 'yes' || result != 'yes') {
      //   _getObras();
      //   setState(() {});
      // }
    }
    if (widget.opcion == 2) {
      Navigator.pop(context, obra);
    }
  }
}
