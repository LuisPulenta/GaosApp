class Causante {
  int nroCausante = 0;
  String grupo = '';
  String codigo = '';
  String nombre = '';
  String apellido = '';
  bool? estado = false;
  String? direccion = '';
  int? numero = 0;
  String? piso = '';
  String? dpto = '';
  String? torre = '';
  String? ciudad = '';
  String? telefono = '';
  String? caracTelefono = '';
  String? codpos = '';
  String? encargado = '';
  String? email = '';
  String? fecha = '';
  int? tipoprov = 0;
  String? cuit = '';
  String? razonSocial = '';
  int? nivel = 0;
  String? barrio = '';
  String? fax = '';
  String? caracFax = '';
  String? provincia = '';
  String? notasCausantes = '';
  String? notas = '';
  int idEmpresa = 0;
  String? dni = '';

  Causante(
      {required this.nroCausante,
      required this.grupo,
      required this.codigo,
      required this.nombre,
      required this.apellido,
      required this.estado,
      required this.direccion,
      required this.numero,
      required this.piso,
      required this.dpto,
      required this.torre,
      required this.ciudad,
      required this.telefono,
      required this.caracTelefono,
      required this.codpos,
      required this.encargado,
      required this.email,
      required this.fecha,
      required this.tipoprov,
      required this.cuit,
      required this.razonSocial,
      required this.nivel,
      required this.barrio,
      required this.fax,
      required this.caracFax,
      required this.provincia,
      required this.notasCausantes,
      required this.notas,
      required this.idEmpresa,
      required this.dni});

  Causante.fromJson(Map<String, dynamic> json) {
    nroCausante = json['nroCausante'];
    grupo = json['grupo'];
    codigo = json['codigo'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    estado = json['estado'];
    direccion = json['direccion'];
    numero = json['numero'];
    piso = json['piso'];
    dpto = json['dpto'];
    torre = json['torre'];
    ciudad = json['ciudad'];
    telefono = json['telefono'];
    caracTelefono = json['caracTelefono'];
    codpos = json['codpos'];
    encargado = json['encargado'];
    email = json['email'];
    fecha = json['fecha'];
    tipoprov = json['tipoprov'];
    cuit = json['cuit'];
    razonSocial = json['razonSocial'];
    nivel = json['nivel'];
    barrio = json['barrio'];
    fax = json['fax'];
    caracFax = json['caracFax'];
    provincia = json['provincia'];
    notasCausantes = json['notasCausantes'];
    notas = json['notas'];
    idEmpresa = json['idEmpresa'];
    dni = json['dni'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroCausante'] = nroCausante;
    data['grupo'] = grupo;
    data['codigo'] = codigo;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['estado'] = estado;
    data['direccion'] = direccion;
    data['numero'] = numero;
    data['piso'] = piso;
    data['dpto'] = dpto;
    data['torre'] = torre;
    data['ciudad'] = ciudad;
    data['telefono'] = telefono;
    data['caracTelefono'] = caracTelefono;
    data['codpos'] = codpos;
    data['encargado'] = encargado;
    data['email'] = email;
    data['fecha'] = fecha;
    data['tipoprov'] = tipoprov;
    data['cuit'] = cuit;
    data['razonSocial'] = razonSocial;
    data['nivel'] = nivel;
    data['barrio'] = barrio;
    data['fax'] = fax;
    data['caracFax'] = caracFax;
    data['provincia'] = provincia;
    data['notasCausantes'] = notasCausantes;
    data['notas'] = notas;
    data['idEmpresa'] = idEmpresa;
    data['dni'] = dni;
    return data;
  }
}
