class ObrasDocumento {
  int nroregistro = 0;
  int nroobra = 0;
  String? observacion = '';
  String? link = '';
  String? fecha = '';
  String? imageFullPath = '';

  ObrasDocumento(
      {required this.nroregistro,
      required this.nroobra,
      required this.observacion,
      required this.link,
      required this.fecha,
      required this.imageFullPath});

  ObrasDocumento.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nroobra = json['nroobra'];
    observacion = json['observacion'];
    link = json['link'];
    fecha = json['fecha'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nroregistro'] = nroregistro;
    data['nroobra'] = nroobra;
    data['observacion'] = observacion;
    data['link'] = link;
    data['fecha'] = fecha;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}
