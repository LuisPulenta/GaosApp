class User {
  int idUsuario = 0;
  String codigoCausante = '';
  String login = '';
  String contrasena = '';
  String? nombre = '';
  String? apellido = '';
  int? estado = 0;
  int? habilitaAPP = 0;
  int? habilitaFotos = 0;
  int? habilitaReclamos = 0;
  int? habilitaSSHH = 0;
  String modulo = '';
  int? habilitaMedidores = 0;
  int? habilitaFlotas = 0;
  String? codigogrupo = '';
  String? codigocausante = '';
  String fullName = '';
  int? fechaCaduca = 0;
  int? intentosInvDiario = 0;
  int? opeAutorizo = 0;
  int idEmpresa = 0;

  User(
      {required this.idUsuario,
      required this.codigoCausante,
      required this.login,
      required this.contrasena,
      required this.nombre,
      required this.apellido,
      required this.estado,
      required this.habilitaAPP,
      required this.habilitaFotos,
      required this.habilitaReclamos,
      required this.habilitaSSHH,
      required this.modulo,
      required this.habilitaMedidores,
      required this.habilitaFlotas,
      required this.codigogrupo,
      required this.codigocausante,
      required this.fullName,
      required this.fechaCaduca,
      required this.intentosInvDiario,
      required this.opeAutorizo,
      required this.idEmpresa});

  User.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    codigoCausante = json['codigoCausante'];
    login = json['login'];
    contrasena = json['contrasena'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    estado = json['estado'];
    habilitaAPP = json['habilitaAPP'];
    habilitaFotos = json['habilitaFotos'];
    habilitaReclamos = json['habilitaReclamos'];
    habilitaSSHH = json['habilitaSSHH'];
    modulo = json['modulo'];
    habilitaMedidores = json['habilitaMedidores'];
    habilitaFlotas = json['habilitaFlotas'];
    codigogrupo = json['codigogrupo'];
    codigocausante = json['codigocausante'];
    fullName = json['fullName'];
    fechaCaduca = json['fechaCaduca'];
    intentosInvDiario = json['intentosInvDiario'];
    opeAutorizo = json['opeAutorizo'];
    idEmpresa = json['idEmpresa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUsuario'] = idUsuario;
    data['codigoCausante'] = codigoCausante;
    data['login'] = login;
    data['contrasena'] = contrasena;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['estado'] = estado;
    data['habilitaAPP'] = habilitaAPP;
    data['habilitaFotos'] = habilitaFotos;
    data['habilitaReclamos'] = habilitaReclamos;
    data['habilitaSSHH'] = habilitaSSHH;
    data['modulo'] = modulo;
    data['habilitaMedidores'] = habilitaMedidores;
    data['habilitaFlotas'] = habilitaFlotas;
    data['codigogrupo'] = codigogrupo;
    data['codigoCausante'] = codigocausante;
    data['fullName'] = fullName;
    data['fechaCaduca'] = fechaCaduca;
    data['intentosInvDiario'] = intentosInvDiario;
    data['opeAutorizo'] = opeAutorizo;
    data['idEmpresa'] = idEmpresa;

    return data;
  }
}
