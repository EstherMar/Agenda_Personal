import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:miagendapersonal/db/classevento.dart';
import 'package:miagendapersonal/db/databaseeventos.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:miagendapersonal/eventos.dart';
import 'package:miagendapersonal/buscarEventos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(eventosCalendario()));
}

typedef SingleMarkerBuilder = Widget Function(BuildContext context, DateTime date, dynamic event);

DateTime fechareal;
bool icono = false;
var cogerfecha;
List fechasdeevento;

final Map<DateTime, List> Fiestas = {
  DateTime(2020, 1,1):    ['Año Nuevo'],
  DateTime(2020, 1,6):    ['Día de Reyes'],
  DateTime(2020, 4,10):   ['Viernes Santo'],
  DateTime(2020, 5,1):    ['Fiesta del Trabajo'],
  DateTime(2020, 10,12):  ['Día de la Hispanidad'],
  DateTime(2020, 11,1):   ['Todos los Santos'],
  DateTime(2020, 12,6):   ['Dia de la Constitución'],
  DateTime(2020, 12,8):   ['La Inmaculada Concepción'],
  DateTime(2020, 12,25):  ['Navidad'],
};

class eventosCalendario extends StatefulWidget {

  final DateTime FechaReal;
  final String Cogerfecha;

  eventosCalendario ({Key key, this.Cogerfecha, this.FechaReal}): super (key: key);

  _eventosCalendarioState createState() => _eventosCalendarioState();

}

class _eventosCalendarioState extends State<eventosCalendario> with TickerProviderStateMixin {

  Map<DateTime, List> _events;

  CalendarController _calendarController;
  AnimationController _animationController;

  void initState() {
    super.initState();
    
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this, duration: const Duration (milliseconds: 400),);
    _animationController.forward();
  }

  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime DateT, List events) {
    setState(() {
      cogerfecha ="Dia: ${DateT.day.toString()}, ${DateT.month.toString()}, ${ DateT.year.toString()}";
      print(cogerfecha);
      fechareal = DateT;
      print (DateT);
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', "ES")
      ],
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
              children: <Widget>[
                SizedBox(height: 30),
                Padding
                  (padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
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
                        child: TableCalendar(
                          locale: 'es_ES',
                          initialCalendarFormat: CalendarFormat.week,
                          events: _events,
                          formatAnimation: FormatAnimation.slide,
                          availableGestures: AvailableGestures.all,
                          calendarStyle: CalendarStyle(
                            todayColor: Colors.green,
                            selectedColor: Color(0xFFCCFF90),
                            todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,),
                            selectedStyle: TextStyle(
                              color: Colors.black,),),
                          headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                            formatButtonDecoration: BoxDecoration(
                              color: Color(0xFFCCFF90),
                              borderRadius: BorderRadius.circular(20.0),
                            ),),
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          onDaySelected: _onDaySelected,
                          builders: CalendarBuilders(
                            markersBuilder: (context, date, events, holidays) {
                              final children = <Widget>[];
                              if (_events.isNotEmpty) {
                                children.add(
                                  Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: _buildEventsMarker(date, events),
                                  ),
                                );
                              }
                              return children;
                            },
                          ),
                          calendarController: _calendarController,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: NuevoEvento(),),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Borrartodo(),),
                  ],
                ),
                Container(height: 20,),
                Expanded(
                  child: FutureBuilder<List<classevento>>(
                    future: EventosDatabaseProvider.db.getEventosWithFecha(cogerfecha),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<classevento>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            classevento item = snapshot.data[index];
                            var entrada = DateTime.parse(item.fechareal);
                            var entrada2 = DateTime.now();
                            print ("fecha calendario");
                            print (entrada);
                            print ("fecha real");
                            print (entrada2);
                            _events =  {
                              entrada: [snapshot.data.length],
                              entrada2: []
                            };
                            _animationController = AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 400),
                            );
                            _animationController.forward();
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
                                      bottomRight: Radius.circular(30),
                                    ),
                                    boxShadow: [BoxShadow(
                                      color: Colors.lightBlue[900],
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    )
                                    ]),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Container(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          if (item.tipoevento == "personal")
                                            Image.asset(
                                              "assets/images/personal.png",
                                              width: 65, height: 65,),
                                          if (item.tipoevento == "laboral")
                                            Image.asset(
                                              "assets/images/laboral.png",
                                              width: 65, height: 65,),
                                          if (item.tipoevento == "social")
                                            Image.asset(
                                              "assets/images/social.png",
                                              width: 65, height: 65,),
                                          if (item.tipoevento == "urgente")
                                            Image.asset(
                                              "assets/images/urgente.png",
                                              width: 65, height: 65,),
                                          if (item.tipoevento == "especial")
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Colors.white,
                                            iconSize: 24.0,
                                            tooltip: 'Editar este evento',
                                            onPressed: () {
                                              Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      eventos(true,
                                                          Classevento: item)
                                              )
                                              );
                                            },),
                                          IconButton(
                                            icon: Icon(
                                                Icons.delete_forever),
                                            color: Colors.white,
                                            iconSize: 24.0,
                                            tooltip: 'Eliminar este evento',
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (
                                                      BuildContext context) {
                                                    return AlertDialog(
                                                        title: new Text (
                                                          '¿Desea eliminar el evento?',
                                                          textAlign: TextAlign
                                                              .center,
                                                        ),
                                                        actions: <Widget>[
                                                          new FlatButton(
                                                            child: new Text (
                                                                "Cancelar"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },),
                                                          new FlatButton(
                                                              child: new Text (
                                                                  "Continuar"),
                                                              onPressed: () {
                                                                EventosDatabaseProvider
                                                                    .db
                                                                    .deleteEventosWithId(
                                                                    item.id);
                                                                setState(() {});
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                              }
                                                          ),
                                                        ]
                                                    );
                                                  }
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
                              backgroundColor: Colors.green,
                            )
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  NuevoEvento() {
    return MaterialButton(
      onPressed: () async {
        if (cogerfecha != null) {
          print(cogerfecha);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      eventos(false, Cogerfecha: cogerfecha, Fechareal: fechareal)));
        }
        else {
          mostrarmensaje();
        }
      },
      color: Color(0xFFCCFF90),
      elevation: 15.0,
      splashColor: Colors.yellow[200],
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(200.0),
        side: BorderSide(
            color: Colors.black),),
      child: Text("Añadir un evento"),
      height: 40,
    );
  }

  Borrartodo() {
    return MaterialButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => buscarEventos()));
      },
      color: Color(0xFFCCFF90),
      elevation: 15.0,
      splashColor: Colors.yellow[200],
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(200.0),
        side: BorderSide(
            color: Colors.black),),
      child: Text("Buscar evento"),
      height: 40,
    );
  }

  void mostrarmensaje() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text (
                'No has elegido una fecha',
                textAlign: TextAlign.center,
              ),
              content: new Text (
                "Para poder crear un nuevo evento es necesario que haya seleccionado una fecha en concreto",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text ("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]
          );
        }
    );
  }

  final estiloletra =
  TextStyle(
      fontFamily: 'Song',
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.white
  );
}

Widget _buildEventsMarker(DateTime date, List events) {
  return Icon(
    Icons.add_box,
    size: 20.0,
    color: Colors.blueGrey[800],
  );
}




