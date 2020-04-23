import 'package:miagendapersonal/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
class Crearcuenta extends StatefulWidget {

  _CrearcuentaState createState() => _CrearcuentaState();
}

class _CrearcuentaState extends State<Crearcuenta> {

  String email;
  String password;
  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo[600],
                Colors.indigo[700],
                Colors.indigo[800],
                Colors.indigo[900],
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 100
            ),
            child: Padding (
              padding: const EdgeInsets.all(20.0),
              child: Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/firebaseimg.png"),
                    Text (
                      'Crea una nueva cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,),),
                    SizedBox(height: 30,),
                    Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Email', style: LabelStyle,),
                          SizedBox(height: 10,),
                          Container (
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecorationStyle,
                            height: 60.0,
                            child: TextFormField(
                              validator: (value){
                                if (value.isEmpty) {
                                  return "No dejes este campo vacío";
                                }
                                if (value.length < 6) {
                                  return "La contraseña debe de contener más de 6 carácteres";
                                }
                              },
                              onSaved: (value) => email = value,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle (
                                color: Colors.white,
                                fontFamily: 'OpenSans',),
                              decoration: InputDecoration (
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14.0),
                                  prefixIcon: Icon (Icons.email, color: Colors.white),
                                  hintText: "Debes ingresar un correo electrónico",
                                  hintStyle: HintTextStyle),),),]),
                    SizedBox (height: 30,),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Contraseña',
                            style: LabelStyle,),
                          SizedBox(height: 10),
                          Container (
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecorationStyle,
                            height: 60,
                            child: TextFormField (
                              validator: (value){
                                if (value.isEmpty) {
                                  return 'El campo contraseña no puede estar vacío';
                                }
                              },
                              onSaved: (value) => password = value,
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,),
                                hintText: 'Ingresa tu contraseña de inicio',
                                hintStyle: HintTextStyle,),),),]),
                    SizedBox(height: 50,),
                    Container (
                      padding: EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 5,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Colors.white,
                        child: Text ("Registrar nueva cuenta",
                          style: TextStyle (
                            color: Colors.indigo,
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',),),
                        onPressed: () async {
                          validaryentrar();
                        },),),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void validaryentrar() async {
    if (validaryguardar()) {
      try {
        AuthResult usuario = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        print("Register donne: ${usuario}");
        mensajeREGOK();
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          });
        });
      }
      catch (e) {
        print("Error $e");
        mensajeERROR();
      }
    }
  }

  final HintTextStyle = TextStyle(
      color: Colors.white54,
      fontFamily: 'OpenSans',
      fontSize: 16
  );

  final LabelStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'OpenSans',
      fontSize: 16
  );

  final BoxDecorationStyle = BoxDecoration(
    color: Colors.indigo[900],
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  bool validaryguardar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;}

  void mensajeERROR() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text (
              'No ha sido posible realizar el registro',
              textAlign: TextAlign.center,
            ),
            content: Text ("Revise que la dirección de correo no esté en uso y de que la contraseña sea mayor de 6 carácteres",
              textAlign: TextAlign.justify,
            ),
          );
        });
  }

  void mensajeREGOK() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text (
              'Usuario creado con éxito',
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}