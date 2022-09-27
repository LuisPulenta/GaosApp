class Cliente {
  int nrocliente = 0;
  String nombre = '';
  int? idempresa = 0;

  Cliente(
      {required this.nrocliente,
      required this.nombre,
      required this.idempresa});

  Cliente.fromJson(Map<String, dynamic> json) {
    nrocliente = json['nrocliente'];
    nombre = json['nombre'];
    idempresa = json['idempresa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nrocliente'] = nrocliente;
    data['nombre'] = nombre;
    data['idempresa'] = idempresa;
    return data;
  }
}
