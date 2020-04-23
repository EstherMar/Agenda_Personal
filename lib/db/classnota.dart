class classnota {
  int id;
  String titulo;
  String descripcion;

  classnota ({this.id, this.titulo, this.descripcion});

  Map<String, dynamic> toMap() => {
    "id" : id,
    "titulo" : titulo,
    "descripcion" : descripcion
  };

  factory classnota.fromMap (Map<String, dynamic> json) => new classnota(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion']
  );
}