import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nimble/welcome.dart';
import 'CRUD.dart';
import 'DemoLocalizations.dart';
import 'signUP.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signIn extends StatefulWidget {
  int id = 0;
  signIn(this.id);
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  bool showSpinner = false;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await CRUD.getData();
    print("C");
  }

  @override
  void initState() {
    // TODO: implement initState
    loggedinuser();
    super.initState();
  }

  loggedinuser() async {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        //signed out
      } else if (firebaseUser != null) {
        //signed in
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome(2)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(
                    "assets/images/signup_bg.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 58.0),
                          child: Text(
                            AppLocalizations.of(context).translate('helo'),
                            style: TextStyle(
                                fontSize: CRUD.headingFont,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 58.0),
                          child: Text(
                            AppLocalizations.of(context).translate('wlcmbk'),
                            style: TextStyle(
                                fontSize: CRUD.headingFont,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text.rich(
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('signintxt'),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                children: <TextSpan>[
                                  TextSpan(
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => signUp()),
                                          );
                                        },
                                      text: AppLocalizations.of(context)
                                          .translate('signup'),
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      )),
                                  // can add more TextSpans here...
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: TextField(
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              onChanged: (String value) {
                                email = value.trim();
                              },
                              cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .translate('email'),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0087E3)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 13)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: TextField(
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              obscureText: true,
                              onChanged: (String value) {
                                password = value.trim();
                              },
                              cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)
                                      .translate('pass'),
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0087E3)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 13)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    color: Color(0xff1E90FF)),
                                child: FlatButton(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('signin'),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    onPressed: () async {
                                      if (email == null || password == null) {
                                        Fluttertoast.showToast(
                                          msg: "Fields cannot be empty",
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        return;
                                      }
                                      if (email.contains("@") == false) {
                                        print(email.contains("@"));
                                        Fluttertoast.showToast(
                                          msg: "Email not valid",
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        return;
                                      }

                                      if (email != null && password != null) {
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        try {
                                          FirebaseUser newuser = (await _auth
                                                  .signInWithEmailAndPassword(
                                                      email: email,
                                                      password: password))
                                              .user;

                                          if (newuser != null &&
                                              newuser.isEmailVerified == true) {
                                            CRUD.email = email;
                                            CRUD.password = password;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Welcome(widget.id)),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please Verify Your Email.",
                                                gravity: ToastGravity.CENTER);
                                          }
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        } catch (e) {
                                          print(e);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Incorrect email or password",
                                              gravity: ToastGravity.CENTER);

                                          setState(() {
                                            showSpinner = false;
                                          });
                                        }
                                      }
                                    }))),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                _asyncInputDialog(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('frgtpas'),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }
}

Future<String> _asyncInputDialog(BuildContext context) async {
  String email = '';
  return showDialog<String>(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Enter Your Email Address',
          style: TextStyle(color: Colors.black87),
        ),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              style: TextStyle(color: Colors.black87, fontSize: 20),
              cursorColor: Colors.black87,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: new InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Email : ',
                hintText: 'xyz@example.com',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                email = value;
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Cancel',
            ),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            color: Colors.green,
            child: Text(
              'Send',
            ),
            onPressed: () {
              if (email != null && email.contains("@")) {
                final _auth = FirebaseAuth.instance;
                _auth.sendPasswordResetEmail(email: email).then((onValue) {
                  Fluttertoast.showToast(
                    msg: "Email Sent",
                    toastLength: Toast.LENGTH_LONG,
                  );
                });

                Navigator.of(context).pop();
              } else {
                Fluttertoast.showToast(
                  msg: "Email not Valid",
                  toastLength: Toast.LENGTH_LONG,
                );
              }
              //Navigator.of(context).pop(newcardNo);
            },
          ),
        ],
      );
    },
  );
}
