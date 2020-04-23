import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class MandarCorreo extends StatefulWidget {
  @override
  _MandarCorreoState createState() => _MandarCorreoState();
}

class _MandarCorreoState extends State<MandarCorreo> {
  List<String> attachments = [];
  bool isHTML = false;

  final _recipientController = TextEditingController(
    text: 'phoenixapp@outlook.es',
  );

  final _subjectController = TextEditingController(text: '');

  final _bodyController = TextEditingController(
    text: '',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Gracias por enviarnos tu sugerencia';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Phoenixapp',),
          actions: <Widget>[
            IconButton(
              onPressed: send,
              icon: Icon(Icons.send),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          children: <Widget>[
                            SizedBox(height: 30,),
                            Text ("En PhoenixApp, \n nos adaptamos a tus necesidades \n para hacer tu vida más sencilla",
                              textAlign: TextAlign.center,
                              style: TextStyle (
                                fontSize: 16,
                              ),),
                            SizedBox(height: 15,),
                            Text ("Si nos envías \n comentarios y sugerencias \n podremos ayudarte mejor",
                              textAlign: TextAlign.center,
                              style: TextStyle (
                                fontSize: 16,
                              ),)
                          ]),
                      Image.asset("assets/images/phoenix.jpg",
                        height: 150,
                        width: 100,),
                    ]),
                SizedBox (height: 50,),
                Padding (
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _recipientController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                        labelText: 'Contactar con',
                      enabled: false
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Asunto',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _bodyController,
                    maxLines: 10,
                    decoration: InputDecoration(
                        labelText: 'Cuentanos tu problema', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
