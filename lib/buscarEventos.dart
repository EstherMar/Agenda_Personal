import 'package:miagendapersonal/eventos.dart';
import 'package:miagendapersonal/eventosCalendario.dart';
import 'package:flutter/material.dart';

import 'db/classevento.dart';
import 'db/databaseeventos.dart';

class buscarEventos extends StatefulWidget
{

  _buscarEventosState createState() => _buscarEventosState();
}

class _buscarEventosState extends State<buscarEventos>
{
  int select = 0;
  String tipoevento;
  String titulo;
  TextEditingController BusquedaTEC = TextEditingController();

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[100],
                Colors.blue[200],
                Colors.blue[300],
                Colors.blue[400],
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40,),
                Text ( "Busqueda por tipo de evento", style: estiloletra,),
                SizedBox(height: 20,),
                Wrap (
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
                          select = selected ? 0 : null;
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
                          select = selected ? 1 : null;
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
                          select = selected ? 2 : null;
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
                          select = selected ? 3 : null;
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
                          select = selected ? 4 : null;
                          tipoevento = "especial" ;
                          print(tipoevento);
                        });
                      },
                    ),
                  ]
                ),
            Expanded(
                child: FutureBuilder<List<classevento>>(
                    future: EventosDatabaseProvider.db.getEventosWithTipo(tipoevento),
                    builder: (BuildContext context,
                    AsyncSnapshot<List<classevento>> snapshot) {
                    if (snapshot.hasData) {
                    icono = true;
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                          classevento item = snapshot.data[index];
                          return Padding(
                          padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                image: DecorationImage(
                                image: AssetImage(
                                "assets/images/fondoeventos.jpg"),
                                fit: BoxFit.cover,),
                                borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),),
                                boxShadow: [BoxShadow(
                                color: Colors.lightBlue[900],
                                blurRadius: 12,
                                offset: Offset(0, 6),)]),
                                  child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Container(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                              if (item.tipoevento =="personal")
                                                Image.asset(
                                                "assets/images/personal.png",
                                                width: 65, height: 65,),
                                                if (item.tipoevento =="laboral")
                                                Image.asset(
                                                "assets/images/laboral.png",
                                                width: 65, height: 65,),
                                                if (item.tipoevento =="social")
                                                Image.asset(
                                                "assets/images/social.png",
                                                width: 65, height: 65,),
                                                if (item.tipoevento =="urgente")
                                                Image.asset(
                                                "assets/images/urgente.png",
                                                width: 65, height: 65,),
                                                if (item.tipoevento =="especial")
                                                Image.asset(
                                                "assets/images/especial.png",
                                                width: 65, height: 65,),
                                                Column(children: <Widget>[
                                                      Text(
                                                      item.fecha, style: TextStyle(
                                                      fontFamily: 'Song',
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .bold,),),
                                                      Text(
                                                      item.hora, style: TextStyle(
                                                      fontFamily: 'Song',
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .bold,)),
                                                      Text(item.titulo,
                                                      style: TextStyle(
                                                      fontFamily: 'Song',
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .bold,)),
                                                      ]),
                                                    ],
                                                 ),
                                          Padding(
                                          padding: EdgeInsets.only(
                                          top: 20, right: 20, left: 20),
                                          child: Text(item.descripcion,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                          fontFamily: 'Song',
                                          fontSize: 25,
                                          color: Colors.white),),
                                          ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(Icons.edit),
                                                      color: Colors.white,
                                                      iconSize: 24.0,
                                                      tooltip: 'Editar este evento',
                                                      onPressed: () {
                                                      Navigator.push (
                                                      context, MaterialPageRoute (
                                                      builder: (context) =>
                                                        eventos(true, Classevento: item)));},),
                                                  IconButton(
                                                      icon: Icon(
                                                      Icons.delete_forever),
                                                      color: Colors.white,
                                                      iconSize: 24.0,
                                                      tooltip: 'Eliminar este evento',
                                                      onPressed: () {
                                                      showDialog (
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                              title: new Text (
                                                              '¿Desea eliminar el evento?',
                                                              textAlign: TextAlign.center ,
                                                              ),
                                                              actions: <Widget>[
                                                                new FlatButton(
                                                                child: new Text ("Cancelar") ,
                                                                onPressed: () {
                                                                Navigator.of (context).pop ();},) ,
                                                                new FlatButton(
                                                                child: new Text ("Continuar") ,
                                                                onPressed: () {
                                                                EventosDatabaseProvider.db.deleteEventosWithId(item.id);
                                                                setState (() {});
                                                                  Navigator.of (context).pop ();}),]);}
                                                                  );
                                                          },),
                                                      ],
                                                    )
                                                  ],
                                                 ),
                                               ),
                                             ),
                                            );
                                           },
                                         );
                                            } else {
                                            return Center(
                                                child: CircularProgressIndicator(
                                                backgroundColor: Colors.green,));
                      }
                    },
                ),
              )
            ]
          ),
        ),
      )
    );
  }

  final estiloletra =
  TextStyle (
      fontFamily: 'Song',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black
  );

  final estiloletra2 =
  TextStyle (
      fontFamily: 'Song',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.white
  );

  final estilocontainer = BoxDecoration(
      color: Colors.lightBlue[600],
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),),],
  );
}

