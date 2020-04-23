import 'dart:ui';
import 'package:miagendapersonal/eventosCalendario.dart';
import 'package:miagendapersonal/db/classevento.dart';
import 'package:miagendapersonal/db/databaseeventos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class eventos extends StatefulWidget {

  final bool edit;
  final classevento Classevento;

  eventos(this.edit,{this.Classevento, Cogerfecha, Fechareal}): assert(edit == true || Classevento == null);

  _AddEditEventos createState() => _AddEditEventos();
}

class _AddEditEventos extends State<eventos> {

  int select = 0;
  String tipoevento;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  final formating = TimeOfDayFormat.H_colon_mm;

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay
    picked = await showTimePicker(context: context, initialTime: _time,
    );
    setState(() {
      _time = picked;
    });
  }

  TextEditingController FechaTEC = TextEditingController();
  TextEditingController HoraTEC = TextEditingController();
  TextEditingController TituloTEC = TextEditingController();
  TextEditingController DescripcionTEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    if (widget.edit == true) {
      TituloTEC.text = widget.Classevento.titulo;
      DescripcionTEC.text = widget.Classevento.descripcion;
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
                Colors.cyanAccent[700],
                Colors.cyan[600],
                Colors.cyan[700],
                Colors.cyan[800],
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(height: 100,),
                Container(
                  width: 360,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: Colors.black,
                        blurRadius: 100,
                        offset: Offset(10, 0))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(height: 20,),
                        Text("Nuevo Evento", style: TextStyle(
                          color: Colors.cyan[900],
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Song',),
                          textAlign: TextAlign.center,),
                        Fecha(FechaTEC, Icons.date_range),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Indica la hora:", style: TextStyle(
                              color: Colors.cyan[900],
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Song',),
                              textAlign: TextAlign.center,),
                            IconButton(
                              icon: Icon(Icons.alarm, size: 50, color: Colors.cyan[900],),
                              onPressed: () {
                                selectTime(context);
                                print(_time);
                              },)
                          ],),
                        Hora(HoraTEC, "Hora", "Es necesaria una hora",
                            Icons.access_time,
                            widget.edit ? widget.Classevento.hora : "hora"),
                        TipoEvento(),
                      ]),
                ),
                Container(height: 20,),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(width: 30,),
                        Titulo(TituloTEC, "Titulo",
                            "Inserta un titulo para la nota",
                            Icons.title,
                            widget.edit ? widget.Classevento.titulo : "titulo"),
                        Container(width: 30,),
                        Descripcion(DescripcionTEC, "Descripcion",
                            "Inserta una descripcion para tu nota",
                            Icons.note, widget.edit
                                ? widget.Classevento.descripcion
                                : "descripcion"),
                      ]),
                ),
                Container(height: 30,),
                if(widget.edit == false)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Procesando datos')
                                    ));
                              }
                              if (tipoevento == null){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog (
                                      title: new Text ("No has especificado el tipo de evento",
                                        textAlign: TextAlign.center,),
                                    );
                              });
                              }
                              else {
                                await EventosDatabaseProvider.db.addEventosToDatabase(new classevento(
                                  fechareal: fechareal.toString(),
                                  fecha: cogerfecha,
                                  hora: _time.toString(),
                                  tipoevento: tipoevento,
                                  titulo: TituloTEC.text,
                                  descripcion: DescripcionTEC.text,
                                ));
                                print (fechareal);
                                print (cogerfecha);
                                print (_time.toString());
                                print (tipoevento);
                                print (TituloTEC.text);
                                print (DescripcionTEC.text);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            eventosCalendario()));
                              }
                            },
                            color: Colors.cyan[900],
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.white),),
                            child: Text(
                                "Guardar en nueva nota", style: estiloletra,),
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => eventosCalendario()));
                            },
                            color: Colors.cyan[900],
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.white),),
                            child: Text(
                              "Cancelar", style: estiloletra,),
                            height: 40,
                          ),
                        ),
                      ]
                  ),
                Container(height: 30,),
                if (widget.edit == true)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Procesando datos')
                                    ));
                              } else {
                                await EventosDatabaseProvider.db.updateEventos(new classevento(
                                  id: widget.Classevento.id,
                                  fechareal: fechareal.toString(),
                                  fecha: cogerfecha,
                                  hora: _time.toString(),
                                  tipoevento: tipoevento,
                                  titulo: TituloTEC.text,
                                  descripcion: DescripcionTEC.text,
                                ));
                                print (fechareal);
                                print (cogerfecha);
                                print (_time.toString());
                                print (tipoevento);
                                print (TituloTEC.text);
                                print (DescripcionTEC.text);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            eventosCalendario()));
                              }
                            },
                            color: Colors.cyan[900],
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.white),),
                            child: Text(
                              "Editar este evento", style: estiloletra,),
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0),
                          child: MaterialButton(
                            onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            eventosCalendario()));
                            },
                            color: Colors.cyan[900],
                            elevation: 15.0,
                            splashColor: Colors.yellow[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  200.0),
                              side: BorderSide(
                                  color: Colors.white),),
                            child: Text(
                              "Cancelar", style: estiloletra,),
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

  TipoEvento() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: <Widget>[
            ChoiceChip(
              selectedColor: Colors.green[600],
              backgroundColor: Colors.grey[500],
              label: Text("Personal", style: estiloletra),
              selected: select == 0,
              onSelected: (bool selected) {
                setState(() {
                  select = selected ? 0 : toString();
                  tipoevento = "personal";
                  print (tipoevento);
                });
              },
            ),
              ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Colors.blue[600],
                backgroundColor: Colors.grey[500],
                label: Text("Laboral", style: estiloletra),
                selected: select == 1,
                onSelected: (bool selected) {
                  setState(() {
                    select = selected ? 1 : toString();
                    tipoevento = "laboral";
                    print (tipoevento);
                  });
                },
              ),
              ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Colors.purple[600],
                backgroundColor: Colors.grey[500],
                label: Text("Social", style: estiloletra),
                selected: select == 2,
                onSelected: (bool selected) {
                  setState(() {
                    select = selected ? 2 : toString();
                    tipoevento = "social";
                    print(tipoevento);
                  });
                },
              ),
              ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Colors.deepOrange[600],
                backgroundColor: Colors.grey[500],
                label: Text("Urgente", style: estiloletra),
                selected: select == 3,
                onSelected: (bool selected) {
                  setState(() {
                    select = selected ? 3 : toString();
                    tipoevento = "urgente";
                    print (tipoevento);
                  });
                },
              ),
              ChoiceChip(
                pressElevation: 0.0,
                selectedColor: Colors.pink[600],
                backgroundColor: Colors.grey[500],
                label: Text("Evento Especial", style: estiloletra),
                selected: select == 4,
                onSelected: (bool selected) {
                  setState(() {
                    select = selected ? 4 : toString();
                    tipoevento = "especial" ;
                    print(tipoevento);
                  });
                },
              ),
    ])]);
  }

  Fecha(TextEditingController t, IconData iconData) {
    return Padding(
      padding: EdgeInsets.only(right: 60, left: 60, top: 20),
      child: TextFormField(
        readOnly: true,
        controller: t,
        maxLength: 30,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(iconData),
          hintText: cogerfecha,
          hintStyle: TextStyle(
            fontFamily: 'Song',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Hora(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Padding(
        padding: EdgeInsets.only(left: 110, right: 110, top: 20, bottom: 20),
        child: TextFormField(

          enabled: false,
          controller: t,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(iconData),
            labelText: _time.toString(),
            labelStyle: TextStyle(
              fontFamily: 'Song',
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
    );
  }

  Titulo(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Text("Titulo", style: estiloletra,),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.centerLeft,
            decoration: estilocontainer,
            height: 60,
            child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'No dejes este campo vacío';
                  }
                },
                style: estiloletra,
                controller: t,
                maxLength: 30,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 20),
                  prefixIcon: Icon(iconData),
                  hintText: 'Ingresa un título',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 15),)),
          )
        ]
    );
  }
}

Descripcion (TextEditingController t, String label, String hint,
    IconData iconData, String initialValue) {
  return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox (height: 30,),
        Text ( "Descripción", style: estiloletra,),
        SizedBox (height: 10,),
        Container (
          alignment: Alignment.centerLeft,
          decoration: estilocontainer,
          height: 100,
          child: TextFormField (
              validator: (value){
                if (value.isEmpty) {
                  return 'No dejes este campo vacío';
                }
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              style: estiloletra,
              controller: t,
              maxLength: 300,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 20),
                prefixIcon: Icon(iconData),
                hintText: 'Ingresa una descripción', hintStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 15),) ),
        )
      ]
  );
}

final estiloletra =
  TextStyle (
      fontFamily: 'Song',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.white
  );

final estilocontainer = BoxDecoration(
  color: Colors.cyan[900],
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);


