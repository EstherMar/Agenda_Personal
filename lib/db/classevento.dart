class classevento {
  int id;
  String fechareal;
  String fecha;
  String hora;
  String tipoevento;
  String titulo;
  String descripcion;

  classevento ({this.id, this.fechareal, this.fecha, this.hora, this.tipoevento, this.titulo, this.descripcion});

  Map<String, dynamic> toMap() => {
    "id" : id,
    "fechareal" : fechareal,
    "fecha" : fecha,
    "hora" : hora,
    "tipoevento" : tipoevento,
    "titulo": titulo,
    "descripcion" : descripcion,
  };

  factory classevento.fromMap (Map<String, dynamic> json) => new classevento (
    id : json ['id'],
    fechareal: json ['fechareal'],
    fecha: json ['fecha'],
    hora: json ['hora'],
    tipoevento: json ['tipoevento'],
    titulo: json ['titulo'],
    descripcion: json ['descripcion'],
  );
}
