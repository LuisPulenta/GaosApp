class Empresa {
  int idEmpresa = 0;
  String nombreempresa = '';
  String? direccion = '';
  String? telefono = '';
  String? carpetaImagenes = '';
  String? mensageSSHH = '';
  bool activo = false;
  String? logoEmpresa = '';
  String? logoFullPath = '';

  Empresa(
      {required this.idEmpresa,
      required this.nombreempresa,
      required this.direccion,
      required this.telefono,
      required this.carpetaImagenes,
      required this.mensageSSHH,
      required this.activo,
      required this.logoEmpresa,
      required this.logoFullPath});

  Empresa.fromJson(Map<String, dynamic> json) {
    idEmpresa = json['idEmpresa'];
    nombreempresa = json['nombreempresa'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    carpetaImagenes = json['carpetaImagenes'];
    mensageSSHH = json['mensageSSHH'];
    activo = json['activo'];
    logoEmpresa = json['logoEmpresa'];
    logoFullPath = json['logoFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEmpresa'] = idEmpresa;
    data['nombreempresa'] = nombreempresa;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['carpetaImagenes'] = carpetaImagenes;
    data['mensageSSHH'] = mensageSSHH;
    data['activo'] = activo;
    data['logoEmpresa'] = logoEmpresa;
    data['logoFullPath'] = logoFullPath;
    return data;
  }
}
