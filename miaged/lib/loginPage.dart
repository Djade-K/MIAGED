import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'user.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<dynamic> signIn(String name, String password) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(name)
        .get()
        .then((user) {
      if (user.exists && user.data()!["password"] == password) {
        return user.data();
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("MIAGED"),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Entrez le nom d\'utilisateur';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nom d'utilisateur",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Entrez le mot de passe';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    signIn(usernameController.text, passwordController.text)
                        .then((value) => {
                              if (value != null)
                                {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (_) {
                                      return homeScreen(
                                          user: User(
                                              value['adress'],
                                              value['birthday'],
                                              value['city'],
                                              value['name'],
                                              value['password'],
                                              value['surname'],
                                              value['uid']));
                                    },
                                  )),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.transparent,
                                    behavior: SnackBarBehavior.floating,
                                    elevation: 0,
                                    content: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.all(15),
                                          height: 70,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFb89fd3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'Une erreur est survenue',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      'Nom d\'utilisateur ou mot de passe incorrect',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                }
                            });
                  }
                },
                child: Text('Se connecter'),
              ),
            ),
            Spacer(),
            SizedBox(
              height: 130,
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: Text('Nouvel utilisateur ? Créez un compte')),
          ],
        ),
      ),
    );
  }
}
