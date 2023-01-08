import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/user.dart';
import '../models/itemModel.dart';

class productPage extends StatelessWidget {
  final itemModel item;
  final User user;

  const productPage({Key? key, required this.item, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("MIAGED"),
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  title: Text(item.titre),
                  subtitle: Text(
                      'Catégorie: ${item.Categorie} | Taille: ${item.Taille} | Marque: ${item.Marque}'),
                  trailing: Text('${item.Prix}€'),
                ),
              )),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  child: Text('Ajouter au panier'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .set({
                      'items': FieldValue.arrayUnion([
                        {
                          'image': item.image,
                          'titre': item.titre,
                          'Prix': item.Prix,
                          'Taille': item.Taille,
                        },
                      ]),
                    }, SetOptions(merge: true));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Article ajouté au panier !'),
                      duration: Duration(seconds: 2),
                    ));
                  },
                ),
              )
            ],
          ),
        ));
  }
}
