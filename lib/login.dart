import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miagendapersonal/crearcuenta.dart';
import 'package:miagendapersonal/copiasdeseguridad.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var name;
var uid;
class LoginScreen extends StatefulWidget {

  var Name;
  var Uid;

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email;
  String password;

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

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
                    Colors.teal[600],
                    Colors.teal[700],
                    Colors.teal[800],
                    Colors.teal[900],
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text (
                          'Accede a tu cuenta',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,),),
                        SizedBox (height: 30,),
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
                                  // ignore: missing_return
                                  validator: (value){
                                    if (value.isEmpty) {
                                      return 'No dejes este campo vacío';
                                    }
                                  },
                                  controller: emailTEC,
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
                                  // ignore: missing_return
                                  validator: (value){
                                    if (value.isEmpty) {
                                      return 'El campo contraseña no puede estar vacío';
                                    }
                                  },
                                  controller: passwordTEC,
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
                        Container (
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {},
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text ('¿Has olvidado la contraseña?',
                              style: LabelStyle,),),),
                        SizedBox (height: 20,),
                        SizedBox(height: 90,),
                        Container (
                          padding: EdgeInsets.symmetric(vertical: 25),
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 5,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.white,
                            child: Text ("Entrar",
                              style: TextStyle (
                                color: Colors.teal,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',),),
                            onPressed: () async{
                              if (!formKey.currentState.validate()){
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Procesando datos'))
                                );} else {
                                FirebaseUser usuario;
                                try {
                                  usuario = (await _auth.signInWithEmailAndPassword(
                                      email: emailTEC.text, password: passwordTEC.text)).user;
                                  name = usuario.email;
                                  uid = usuario.uid;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => copiasdeseguridad()),);
                                } catch (e) {
                                  print (e.toString());
                                } finally {
                                  if (usuario != null) {
                                  } else {
                                    print('sign in Not');
                                  }
                                }
                              }},),),
                        SizedBox(height: 30,),
                        Container (
                          alignment: Alignment.bottomCenter,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text ('¿No tienes aún cuenta? ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,),),
                                FlatButton (
                                  child: Text (" Crea una",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,),),
                                  onPressed: () {
                                    setState(() {
                                     Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Crearcuenta()),);
                                    });
                                  },
                                )
                              ]),
                        ),
                      ]),
                ),
              )
          ),
        )
    );
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
    color: Colors.teal[900],
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}


