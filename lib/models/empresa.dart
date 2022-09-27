class Empresa {
  int idEmpresa = 0;
  String nombreempresa = '';
  String? direccion = '';
  String? telefono = '';
  String? carpetaImagenes = '';
  String? mensageSSHH = '';

  Empresa(
      {required this.idEmpresa,
      required this.nombreempresa,
      required this.direccion,
      required this.telefono,
      required this.carpetaImagenes,
      required this.mensageSSHH});

  Empresa.fromJson(Map<String, dynamic> json) {
    idEmpresa = json['idEmpresa'];
    nombreempresa = json['nombreempresa'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    carpetaImagenes = json['carpetaImagenes'];
    mensageSSHH = json['mensageSSHH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idEmpresa'] = idEmpresa;
    data['nombreempresa'] = nombreempresa;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['carpetaImagenes'] = carpetaImagenes;
    data['mensageSSHH'] = mensageSSHH;
    return data;
  }
}
