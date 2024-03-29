import 'dart:io';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nimble/CRUD.dart';
import 'package:path/path.dart' as Path;
import 'DemoLocalizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'customDrawer.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool showSpinner = false;

  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: CustomDrawer.buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: IconButton(
              onPressed: () {
                _key.currentState.openDrawer();
              },
              icon: ImageIcon(
                AssetImage("assets/images/menu.png"),
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Edit Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff0087E3),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
//                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/write');
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showSpinner = true;
                  });
                  addData();
                  setState(() {
                    showSpinner = false;
                  });
//                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/write');
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0, right: 10),
                  child: Text(AppLocalizations.of(context).translate('savevtn'),
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: new Stack(children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/bg_option2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
//                      SafeArea(
//
//                        child: Padding(
//
//                          padding: const EdgeInsets.symmetric(
//                              horizontal: 10, vertical: 30),
//
//                          child: Row(
//
//
//                            crossAxisAlignment: CrossAxisAlignment.end,
//
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                            children: <Widget>[
//
//
//                              ImageIcon(
//
//                                AssetImage("assets/images/menu.png"), size: 30,
//
//                                color: Colors.white,
//
//                              ),
//
//                              Text(AppLocalizations.of(context).translate(
//                                  'edtprfile'),
//
//                                style: TextStyle(
//                                    color: Colors.white, fontSize: 22),),
//
//
//                              Row(children: <Widget>[
//
//
//                                GestureDetector(
//                                  onTap: () {
//                                    setState(() {
//                                      showSpinner = true;
//                                    });
//                                    addData();
//                                    setState(() {
//                                      showSpinner = false;
//                                    });
//                                  },
//                                  child: Text(
//                                      AppLocalizations.of(context).translate(
//                                          'savevtn'),
//                                      style: TextStyle(
//                                          color: Colors.white, fontSize: 18)),
//                                ),
//
//
//                              ],)
//
//                              ,
//
//
//                            ],),
//
//                        ),
//
//                      ),

                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          chooseFile();
                          setState(() {
                            showSpinner = false;
                          });
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(CRUD.imgUrl),
                          backgroundColor: Colors.transparent,
                          radius: 65,
                        ),
                      ),
                      Positioned.fill(
                        bottom: 8,
                        right: 20,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        // physics: BouncingScrollPhysics(),
                        //  padding: EdgeInsets.only(bottom: 200),
                        children: <Widget>[
                          _info(AppLocalizations.of(context).translate('name'),
                              1, CRUD.name, true),
                          _info(AppLocalizations.of(context).translate('email'),
                              2, CRUD.email, false),
                          _info('Number', 3, CRUD.Number, true),
                          _info('Occupation', 4, CRUD.Occupation, true),
                          _info(AppLocalizations.of(context).translate('bio'),
                              5, CRUD.bio, true),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('social'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              )),
                          _info2(
                              4,
                              AppLocalizations.of(context).translate('yutub'),
                              "assets/images/youtube.png",
                              CRUD.youtube),
                          _info2(
                              5,
                              AppLocalizations.of(context).translate('wtsp'),
                              "assets/images/whatsapp.png",
                              CRUD.whatsapp),
                          _info2(
                              6,
                              AppLocalizations.of(context).translate('twter'),
                              "assets/images/twitter.png",
                              CRUD.twitter),
                          _info2(
                              7,
                              AppLocalizations.of(context).translate('tktok'),
                              "assets/images/tiktok.png",
                              CRUD.tiktok),
                          _info2(
                              8,
                              AppLocalizations.of(context)
                                  .translate('soundcld'),
                              "assets/images/soundcloud.png",
                              CRUD.soundcloud),
                          _info2(
                              9,
                              AppLocalizations.of(context).translate('snpcht'),
                              "assets/images/snapchat.png",
                              CRUD.snapchat),
                          _info2(
                              10,
                              AppLocalizations.of(context).translate('pypl'),
                              "assets/images/paypal.png",
                              CRUD.paypal),
                          _info2(
                              11,
                              AppLocalizations.of(context).translate('msc'),
                              "assets/images/music.png",
                              CRUD.music),
                          _info2(
                              12,
                              AppLocalizations.of(context).translate('lnk'),
                              "assets/images/linkedin.png",
                              CRUD.linkendin),
                          _info2(
                              13,
                              AppLocalizations.of(context).translate('insta'),
                              "assets/images/instagram.png",
                              CRUD.instagram),
                          _info2(
                              14,
                              AppLocalizations.of(context).translate('fb'),
                              "assets/images/facebook.png",
                              CRUD.facebook),
                          _info2(
                              15,
                              AppLocalizations.of(context).translate('cash'),
                              "assets/images/cashapp.png",
                              CRUD.cashapp),
                          _info2(
                              16,
                              AppLocalizations.of(context).translate('venmo'),
                              "assets/images/venmo.png",
                              CRUD.venmo),
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    height: 10,
                    color: Colors.black,
                    thickness: 1,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void chooseFile() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);

    this.setState(() {
      _image = selected;
      print(_image);
    });

    setState(() {
      showSpinner = true;
    });

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Recent/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        print(fileURL);
        CRUD.imgUrl = fileURL;
        showSpinner = false;
      });
    });
  }

  void addData() async {
    final _auth = FirebaseAuth.instance;
    FirebaseUser loggedinUser;
    String myuserid;
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.uid);
        myuserid = loggedinUser.uid;
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      showSpinner = true;
    });

    final databaseReference = FirebaseDatabase.instance.reference();

    await databaseReference.child("users").child(myuserid).update({
      'Name': CRUD.name,
      'email': CRUD.email,
      'img_url': CRUD.imgUrl,
      'password': CRUD.password,
      'Number': CRUD.Number,
      'Occupation': CRUD.Occupation,
      'bio': CRUD.bio,
      'youtube_un': CRUD.youtube,
      'whatsapp_un': CRUD.whatsapp,
      'twitter_un': CRUD.twitter,
      'soundcloud_un': CRUD.soundcloud,
      'snapchat_un': CRUD.snapchat,
      'paypal_un': CRUD.paypal,
      'music_un': CRUD.music,
      'linkedin_un': CRUD.linkendin,
      'instagram_un': CRUD.instagram,
      'facebook_un': CRUD.facebook,
      'cashapp_un': CRUD.cashapp,
      'venmo_un': CRUD.venmo,
      'tiktok_un': CRUD.tiktok
    });
    setState(() {
      showSpinner = false;
    });

    Fluttertoast.showToast(
        msg: "Data updated successfully",
        backgroundColor: Colors.blue,
        gravity: ToastGravity.CENTER);
  }
}

class _info extends StatelessWidget {
  String heading;
  int id;
  String imgPath;
  bool flag = false;
  String placeholderText;
  _info(this.heading, this.id, this.placeholderText, this.flag);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text(
                  heading,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Material(
            elevation: 1.0,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: TextField(
              enabled: flag,
              controller: TextEditingController()..text = placeholderText,
              // controller: TextEditingController()..text = myval,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              onChanged: (String value) {
                //email=value.trim();

                if (id == 1) {
                  CRUD.name = value;
                } else if (id == 2) {
                  CRUD.email = value;
                } else if (id == 3) {
                  CRUD.Number = value;
                } else if (id == 4) {
                  CRUD.Occupation = value;
                } else if (id == 5) {
                  CRUD.bio = value;
                }
              },
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
//                  prefixIcon:  ImageIcon(
//
//                    AssetImage("assets/images/youtube.png"),
//
//                    //color: Colors.black87,
//
//                  ),
                  // hintText: "Password",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff0087E3)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class _info2 extends StatelessWidget {
  String hintText;
  int id;
  String imgPath;
  String placeHolderText;

  _info2(@required this.id, this.hintText, this.imgPath, this.placeHolderText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        children: <Widget>[
          Material(
            elevation: 1.0,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: TextField(
              controller: TextEditingController()..text = placeHolderText,
              textAlign: TextAlign.center,
              onChanged: (String value) {
                if (!value.contains(".com") == true) {
                  //email=value.trim();
                  if (id == 4) {
                    CRUD.youtube = "www.youtube.com/" + value;
                    print(value);
                  } else if (id == 5) {
                    CRUD.whatsapp = "www.whatsapp.com/" + value;
                  } else if (id == 6) {
                    CRUD.twitter = "www.twitter.com/" + value;
                  } else if (id == 7) {
                    CRUD.tiktok = "www.tiktok.com/" + value;
                  } else if (id == 8) {
                    CRUD.soundcloud = "www.soundcloud.com/" + value;
                  } else if (id == 9) {
                    CRUD.snapchat = "www.snapchat.com/" + value;
                  } else if (id == 10) {
                    CRUD.paypal = "www.paypal.com/" + value;
                  } else if (id == 11) {
                    CRUD.music = "www.music.com/" + value;
                  } else if (id == 12) {
                    CRUD.linkendin = "www.linkedin.com/" + value;
                  } else if (id == 13) {
                    CRUD.instagram = "www.instagram.com/" + value;
                  } else if (id == 14) {
                    CRUD.facebook = "www.facebook.com/" + value;
                  } else if (id == 15) {
                    CRUD.cashapp = "www.cashapp.com/" + value;
                  } else if (id == 16) {
                    CRUD.venmo = "www.venmo.com/" + value;
                  }
                } else {
                  if (id == 4) {
                    CRUD.youtube = value;
                  } else if (id == 5) {
                    // CRUD.whatsapp="www.whatsapp.com/"+value;
                    CRUD.whatsapp = value;
                  } else if (id == 6) {
                    CRUD.twitter = value;
                  } else if (id == 7) {
                    CRUD.tiktok = value;
                  } else if (id == 8) {
                    CRUD.soundcloud = value;
                  } else if (id == 9) {
                    CRUD.snapchat = value;
                  } else if (id == 10) {
                    CRUD.paypal = value;
                  } else if (id == 11) {
                    CRUD.music = value;
                  } else if (id == 12) {
                    CRUD.linkendin = value;
                  } else if (id == 13) {
                    CRUD.instagram = value;
                  } else if (id == 14) {
                    CRUD.facebook = value;
                  } else if (id == 15) {
                    CRUD.cashapp = value;
                  } else if (id == 16) {
                    CRUD.venmo = value;
                  }
                }
              },
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.1),
//                  prefixIcon:  ImageIcon(
//
//                    AssetImage(imgPath),
//
//                    //color: Colors.black87,
//
//                  ),

                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      imgPath,
                      width: 20,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 22, vertical: 13)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
