import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miagendapersonal/db/classnota.dart';
import 'package:miagendapersonal/db/databasenotas.dart';

import 'notas.dart';

void main() => runApp(Notasrapidas());

class Notasrapidas extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<MyHomePage> {

  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
          title: Text ("Notas Rápidas"),
          flexibleSpace: Container (
            decoration: BoxDecoration (
              gradient: LinearGradient (
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                  colors: <Color>[
                    Colors.teal,
                    Colors.deepOrange
                  ]
              )
            )
          ),
          actions: <Widget>[
            FlatButton (
              onPressed: () {
                mensajeborrar ( );
                setState (() {});} ,
              child: Text (
                "Eliminar todo" ,
                style: new TextStyle(
                    fontWeight: FontWeight.bold ,
                    fontSize: 14.0 ,
                    color: Colors.white
                ) ,
              ) ,
            )
          ]
      ) ,

      body:
      FutureBuilder<List<classnota>> (
        future: NotasDatabaseProvider.db.getAllNotas () ,
        builder: (BuildContext context ,
            AsyncSnapshot<List<classnota>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder (
              physics: BouncingScrollPhysics (
              ) ,
              itemCount: snapshot.data.length ,
              itemBuilder: (BuildContext context , int index) {
                classnota item = snapshot.data[index];
                return Dismissible (
                  key: UniqueKey (
                  ) ,
                  background: Container (
                      color: Colors.red
                  ) ,
                  onDismissed: (direction) {
                    showDialog (
                        context: context , builder: (BuildContext context) {
                      return AlertDialog (
                        title: new Text ('¿Eliminar la nota?',
                          textAlign: TextAlign.center,),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text ('No: Eliminará la nota de la lista pero no del registro (volverá a ser visible en su próximo acceso)'),
                            onPressed: () {Navigator.of (context).pop ();}, ),
                          new FlatButton(child: new Text ('Si: Eliminará la nota del registro de forma inmediata e irreversible'),
                            onPressed: () {
                              NotasDatabaseProvider.db.deleteNotasWithId (item.id);
                              Navigator.of(context).pop();
                            },),
                        ],
                      );
                    }
                    );
                  } ,
                  child: Card (
                    color: Color (0xFFFFF9C4) ,
                    elevation: 20.0 ,
                    child: Padding (
                      padding: const EdgeInsets.only (
                          top: 30.0 , bottom: 30 , left: 15.0 , right: 15.0) ,
                      child: ListTile (
                        title: Text (
                          item.titulo ,
                          style: TextStyle (
                            fontSize: 25 ,
                            fontWeight: FontWeight.bold ,
                            fontFamily: 'Song' ,) ,
                          textAlign: TextAlign.center ,) ,
                        subtitle: Text (
                          item.descripcion ,
                          style: TextStyle (
                              fontSize: 20 ,
                              fontFamily: 'Song' ,
                              color: Colors.black) ,
                          maxLines: 2 ,
                          overflow: TextOverflow.ellipsis ,
                          textAlign: TextAlign.center ,
                        ) ,
                        leading: CircleAvatar (
                            backgroundImage: AssetImage ("assets/images/test.png") ,
                            backgroundColor: Colors.white ,
                            child: Text (item.id.toString () ,
                              style: TextStyle (
                                  color: Colors.black ,
                                  fontWeight: FontWeight.bold
                              ) ,
                            )
                        ) ,
                        onTap: () {
                          Navigator.push (
                              context, MaterialPageRoute (
                              builder: (context) =>
                                  notas(true, Classnota: item)
                          )
                          );
                        } ,
                      ) ,
                    ) ,
                  ) ,
                ); //Now we paint the list with all the records, which will have a number, name, phone
              } ,
            );
          } else {
            return Center (
                child: CircularProgressIndicator (
                  backgroundColor: Colors.teal ,
                )
            );
          }
        } ,
      ) ,
      floatingActionButton: FloatingActionButton (
        backgroundColor: Colors.teal ,
        onPressed: () {
          Navigator.push (
            context , MaterialPageRoute (
              builder: (context) =>
                  notas(false)
          ) ,
          );
        } ,
        child: Icon (Icons.add) ,
      ) ,
    );
  }

  void mensajeborrar() {
    showDialog (
        context: context ,
        builder: (BuildContext context) {
          return AlertDialog (
              title: new Text (
                'Borrar todas las notas' ,
                textAlign: TextAlign.center ,
              ) ,
              content: new Text (
                'Esta acción borrará todas sus notas rápidas de forma irreversible' ,
                textAlign: TextAlign.center ,
              ) ,
              actions: <Widget>[
                new FlatButton(
                  child: new Text ("Cancelar") ,
                  onPressed: () {
                    Navigator.of (context).pop ();
                  } ,
                ) ,
                new FlatButton(
                    child: new Text ("Continuar") ,
                    onPressed: () {
                      NotasDatabaseProvider.db.deleteAllNotas ();
                      setState (() {});
                      Navigator.of (context).pop ();
                    }
                ) ,
              ]
          );
        }
    );
  }
}
