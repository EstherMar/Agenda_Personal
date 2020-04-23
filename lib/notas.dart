import 'dart:ui';
import 'package:miagendapersonal/db/classnota.dart';
import 'package:miagendapersonal/db/databasenotas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class notas extends StatefulWidget {
  final bool edit;
  final classnota Classnota;

  notas(this.edit, {this.Classnota})
      : assert(edit == true || Classnota ==null);

  _AddEditNotas createState() => _AddEditNotas();
}

class _AddEditNotas extends State<notas> {
  TextEditingController TituloTEC = TextEditingController();
  TextEditingController DescripcionTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    //if you press the button to edit it must pass to true,
    //instantiate the name and phone in its respective controller, (link them to each controller)
    if(widget.edit == true){
      TituloTEC.text = widget.Classnota.titulo;
      DescripcionTEC.text = widget.Classnota.descripcion;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.teal[600],
                Colors.teal[700],
                Colors.teal[800],
                Colors.teal[900],
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(top: 100, right: 20, left: 20),
                  elevation: 20,
                  color: Color (0xFFFFF9C4),
                  child: Column (
                      children: <Widget>[
                        Container (height: 20,),
                        Titulo(TituloTEC, "Titulo", "Inserta un titulo para la nota",
                            Icons.note, widget.edit ? widget.Classnota.titulo: "titulo"),
                        Descripcion(DescripcionTEC, "Descripcion", "Inserta una descripcion para tu nota",
                            Icons.note, widget.edit ? widget.Classnota.descripcion : "descripcion"),
                        Container (height: 20,),
                      ]),),
                Container(height: 30,),
                if(widget.edit == false)
                  Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                Scaffold.of (context).showSnackBar (
                                    SnackBar (
                                        content: Text ('Procesando datos')
                                    ));
                              }else{
                                await NotasDatabaseProvider.db.addNotasToDatabase(new classnota(
                                  titulo: TituloTEC.text,
                                  descripcion: DescripcionTEC.text,
                                ));
                                Navigator.pop(context);
                              }
                            },
                            color: Color(
                                0xFFCCFF90),
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.black),),
                            child: Text(
                                "Guardar en nueva nota"),
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Color(
                                0xFFCCFF90),
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.black),),
                            child: Text(
                                "Volver atrás"),
                            height: 40,
                          ),
                        ),
                      ]
                  ),
                Container(height: 30,),
                if (widget.edit == true)
                  Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()){
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Procesando datos'))
                                );} else {
                                NotasDatabaseProvider.db.updateNotas(new classnota(
                                    titulo: TituloTEC.text,
                                    descripcion: DescripcionTEC.text,
                                    id: widget.Classnota.id));
                                Navigator.pop(context);
                              }
                            },
                            color: Color(
                                0xFFCCFF90),
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.black),),
                            child: Text(
                                "Editar esta nota"),
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Color(
                                0xFFCCFF90),
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.black),),
                            child: Text(
                                "Volver atrás"),
                            height: 40,
                          ),
                        ),
                      ]
                  ),
                Container(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Titulo(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        validator: (value){
          if (value.isEmpty) {
            return 'No dejes este campo vacío';
          }
        },
        controller: t,
        maxLength: 30,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(iconData),
          labelText: 'Título',),
        style: TextStyle (
          fontFamily: 'Song',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Descripcion(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        validator: (value){
          if (value.isEmpty) {
            return 'No dejes este campo vacío';
          }
        },
        controller: t,
        maxLines: 10,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(iconData),
          labelText: 'Descripción',),
        style: TextStyle (
          fontFamily: 'Song',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

}