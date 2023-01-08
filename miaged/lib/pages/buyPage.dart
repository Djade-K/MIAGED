import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user.dart';
import 'productPage.dart';
import '../models/itemModel.dart';

class buyPage extends StatefulWidget {
  final User userData;
  const buyPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<buyPage> createState() => _buyPageState();
}

class _buyPageState extends State<buyPage> {
  late User _userData = widget.userData;
  List<String> _categories = ['Tous', 'Haut', 'Bas', 'Baskets', 'Accessoires'];
  String _selectedCategory = 'Tous';

  Stream<QuerySnapshot> _getStream(String category) {
  if (category == 'Tous') {
    return FirebaseFirestore.instance.collection('clothes').snapshots();
  }
  return FirebaseFirestore.instance.collection('clothes').where('Catégorie', isEqualTo: category).snapshots();
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _categories.length,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("MIAGED"),
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  _selectedCategory = _categories[index];
                });
              },
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
          body: TabBarView(
          children: _categories.map((category) {
            return StreamBuilder<QuerySnapshot>(
              stream: _getStream(category),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (category == "Tous") {
                  return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1 / 1.15,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs
                      .map((document) =>
                          _buildGridItem(context, document, _userData))
                      .toList(),
                );
                }

                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1 / 1.15,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs
                      .map((document) =>
                          _buildGridItem(context, document, _userData))
                      .toList(),
                );
              },
            );
          }).toList(),
        ),
      ),);
        
  }

  Widget _buildGridItem(
      BuildContext context, DocumentSnapshot document, User userData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return productPage(
              item: itemModel(
                  document['image'],
                  document['titre'],
                  document['Catégorie'],
                  document['Marque'],
                  document['Prix'].toDouble(),
                  document['Taille']),
              user: userData);
        }));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 120.0,
              height: 120.0,
              child: Image.network(document['image']),
            ),
            Text(document['titre'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
            Text(document['Taille'],
                style: Theme.of(context).textTheme.subtitle2),
            Text(document['Prix'].toString() + '€',
                style: Theme.of(context).textTheme.bodyText2),
            Padding(padding: EdgeInsets.only(bottom: 10))
          ],
        ),
      ),
    );
  }
}
