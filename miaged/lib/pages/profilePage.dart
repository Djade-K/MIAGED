import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../user.dart';
import '../loginPage.dart';

class profilePage extends StatefulWidget {
  final User userData;

  const profilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late User _userData = widget.userData;
  final _formKey = GlobalKey<FormState>();
  final _formKeyCloth = GlobalKey<FormState>();

  late String _uid;
  late String _password;
  late String _zipCode;
  late String _city;
  late String _address;
  late String _birthDate;

  late String _cat;
  late String _marque;
  late String _prix;
  late String _taille;
  late String _url;
  late String _titre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_userData.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var user = snapshot.data;
                _uid = user?['uid'];
                _password = user?['password'];
                _birthDate = user?['birthday'];
                _zipCode = user?['zipCode'];
                _address = user?['adress'];
                _city = user?['city'];

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                          initialValue: _uid,
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Login'),
                          onChanged: (value) => setState(() => _uid = value),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                            initialValue: _password,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                            onChanged: (value) =>
                                setState(() => _password = value),
                            onSaved: (String? val) {
                              _password = val!;
                            }),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                            enabled: true,
                            initialValue: _birthDate,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Anniversaire'),
                            onChanged: (value) =>
                                setState(() => _birthDate = value),
                            onSaved: (String? val) {
                              _birthDate = val!;
                            }),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                            initialValue: _address,
                            decoration: InputDecoration(labelText: 'Adresse'),
                            onChanged: (value) =>
                                setState(() => _address = value),
                            onSaved: (String? val) {
                              _address = val!;
                            }),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                            initialValue: _zipCode,
                            decoration:
                                InputDecoration(labelText: 'Code Postal'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) =>
                                setState(() => _zipCode = value),
                            onSaved: (String? val) {
                              _zipCode = val!;
                            }),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                            initialValue: _city,
                            decoration: InputDecoration(labelText: 'Ville'),
                            onChanged: (value) => setState(() => _city = value),
                            onSaved: (String? val) {
                              _city = val!;
                            }),
                      ),
                      ListTile(
                          contentPadding:
                              EdgeInsets.all(20), //change for side padding
                          title: Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.save();
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(_userData.uid)
                                      .update({
                                    'password': _password,
                                    'birthday': _birthDate,
                                    'city': _city,
                                    'adress': _address,
                                    'zipCode': _zipCode
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Changements vailidés !'),
                                    duration: Duration(seconds: 1),
                                  ));
                                },
                                child: Text('Valider'),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => loginPage()));
                                },
                                child: Text('Se déconnecter'),
                              ),
                            ],
                          )),
                      FloatingActionButton.extended(
                        label: Text('Ajouter un vêtement'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                          child: Form(
                                              key: _formKeyCloth,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Catégorie"),
                                                        onChanged: (value) =>
                                                            setState(() =>
                                                                _cat = value),
                                                        onSaved: (String? val) {
                                                          _zipCode = val!;
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Marque"),
                                                        onChanged: (value) =>
                                                            setState(() =>
                                                                _marque =
                                                                    value),
                                                        onSaved: (String? val) {
                                                          _marque = val!;
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        decoration: const InputDecoration(
                                                            labelText: "Prix"),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <
                                                            TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        onChanged: (value) =>
                                                            setState(() =>
                                                                _prix = value),
                                                        onSaved: (String? val) {
                                                          _prix = val!;
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Taille"),
                                                        onChanged: (value) =>
                                                            setState(() =>
                                                                _taille =
                                                                    value),
                                                        onSaved: (String? val) {
                                                          _taille = val!;
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "URL"),
                                                        onChanged: (value) =>
                                                            setState(() =>
                                                                _url = value),
                                                        onSaved: (String? val) {
                                                          _url = val!;
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    "Titre"),
                                                        onChanged: (value) =>
                                                            setState(() =>
                                                                _titre = value),
                                                        onSaved: (String? val) {
                                                          _titre = val!;
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                      child: Text("Ajouter"),
                                                      onPressed: () {
                                                        _formKeyCloth
                                                            .currentState!
                                                            .save();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'clothes')
                                                            .add({
                                                          'Catégorie': _cat,
                                                          'Marque': _marque,
                                                          'Prix': double.parse(
                                                              _prix),
                                                          'Taille': _taille,
                                                          'image': _url,
                                                          'titre': _titre,
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Produit ajouté !'),
                                                          duration: Duration(
                                                              seconds: 1),
                                                        ));
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )))
                                    ],
                                  ),
                                );
                              });
                        },
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
