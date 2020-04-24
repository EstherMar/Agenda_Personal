import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:miagendapersonal/db//registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formStateKey,
                          autovalidate: true,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                child: TextFormField(
                                  validator: validateEmail,
                                  onSaved: (value) {
                                    _emailId = value;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailIdController,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.green,
                                          width: 2,
                                          style: BorderStyle.solid),
                                    ),
                                    labelText: "Email",
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.green,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                child: TextFormField(
                                  validator: validatePassword,
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                    labelText: "Contraseña",
                                    icon: Icon(
                                      Icons.lock,
                                      color: Colors.green,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        (errorMessage != ''
                            ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                            : Container()),
                        // ignore: deprecated_member_use
                        ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formStateKey.currentState.validate()) {
                                    _formStateKey.currentState.save();
                                    signIn(_emailId, _password).then((user) {
                                      if (user != null) {
                                        print('Conexión satisfactoria');
                                        setState(() {
                                          successMessage =
                                          'Conexión establecida.\n';
                                        });
                                      } else {
                                        print('Ha surgido un error');
                                      }
                                    });
                                  }
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Crear cuenta',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => RegistrationPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                (successMessage != ''
                    ? Text(
                  successMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.green),
                )
                    : Container()),
                (!isGoogleSignIn
                    ? RaisedButton(
                  child: Text('Entrar con Google'),
                  onPressed: () {
                    googleSignin(context).then((user) {
                      if (user != null) {
                        print('Conectado correctamente');
                        setState(() {
                          isGoogleSignIn = true;
                          successMessage =
                          'Conectado correctamente.\nEmail : ${user.email}\n ';
                        });
                      } else {
                        print('Ha surgido un error en la autentificación');
                      }
                    });
                  },
                ): RaisedButton(
                  child: Text('Google Logout'),
                  onPressed: () {
                    googleSignout().then((response) {
                      if (response) {
                        setState(() {
                          isGoogleSignIn = false;
                          successMessage = '';
                        });
                      }
                    });
                  },
                )),
              ],
            ),
          )),
    );
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await auth.signInWithEmailAndPassword(
          email: email, password: password)) as FirebaseUser;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<FirebaseUser> googleSignin(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await auth.signInWithCredential(credential)) as FirebaseUser;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(currentUser);
      print("Nombre de usuario : ${currentUser.displayName}");
    } catch (e) {
      handleError(e);
    }
    return currentUser;
  }

  Future<bool> googleSignout() async {
    await auth.signOut();
    await googleSignIn.signOut();
    return true;
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'Usuario no registrado!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Contraseña erronea!!!';
        });
        break;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Introduce un correo válido!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Debes introducir tu contraseña!!!';
    }
    return null;
  }
}