import 'package:miagendapersonal/correo.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'eventosCalendario.dart';
import 'login.dart';
import 'notasRapidas.dart';

void main() {
  runApp(MaterialApp(
    title: 'Inicio',
    home: Principal(
    ),
  ));
}

class Principal extends StatefulWidget {
  MyApp createState() => MyApp();
}

class MyApp extends State<Principal> {

  VideoPlayerController _controller;

  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/images/principalwp.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox (height: 20,),
                    Align (
                      alignment: Alignment.topLeft,
                      child: Text (" Agenda \n  Personal",
                      style: TextStyle (
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Unicornio',
                          shadows: [ Shadow(
                            blurRadius: 10.0,
                            color: Colors.blueGrey[400],
                            offset: Offset(
                                5.0, 5.0),),]),),),
                    SizedBox(height: 260,),
                    Column(
                      children: <Widget>[
                        Center (child: BotonAgenda(),),
                        Center ( child: BotonNotasRapidas(),),
                        Center ( child: BotonCopiasSeguridad(),),],),
                    SizedBox(height: 30,),
                    ContactarconDesarrollador(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BotonAgenda() {
    return RaisedButton (
        color: Color(0),
        elevation: 15.0,
        splashColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(
              200.0),
          side: BorderSide(
              color: Color(0)),
        ),
        padding: const EdgeInsets.all(
            10.0),
        child: const Text (
          "Calendario de Eventos",
          style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Song',
              shadows: [ Shadow(
                blurRadius: 10.0,
                color: Colors.redAccent,
                offset: Offset(
                    5.0, 5.0),
              ),
              ]),),
        onPressed: () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => eventosCalendario()),);
        }
    );
  }

  BotonNotasRapidas() {
    return RaisedButton (
        color: Color(0),
        elevation: 15.0,
        splashColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(
              200.0),
          side: BorderSide(
              color: Color(0)),
        ),
        padding: const EdgeInsets.all(
            10.0),
        child: const Text (
          "Anotaciones Rápidas",
          style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Song',
              shadows: [ Shadow(
                blurRadius: 10.0,
                color: Colors.redAccent,
                offset: Offset(
                    5.0, 5.0),
              ),
              ]),),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Notasrapidas()),);
        }
    );
  }

  BotonCopiasSeguridad () {
    return RaisedButton (
        color: Color(0),
        elevation: 15.0,
        splashColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(
              200.0),
          side: BorderSide(
              color: Color(0)),
        ),
        padding: const EdgeInsets.all(
            10.0),
        child: const Text (
          "Copias de Seguridad",
          style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Song',
              shadows: [ Shadow(
                blurRadius: 10.0,
                color: Colors.redAccent,
                offset: Offset(
                    5.0, 5.0),
              ),
              ]),),
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),);
        }
    );
  }

  ContactarconDesarrollador() {
    return Align (
      alignment: Alignment.bottomRight,
      child: FlatButton (
          textColor: Colors.redAccent,
          child: const Text (
            "Contactar con desarrollador",
            style: TextStyle(
                fontSize: 20),),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MandarCorreo()),);
          }
      ),
    );
  }
}
