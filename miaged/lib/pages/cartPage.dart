import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user.dart';

class cartPage extends StatefulWidget {
  final User userData;
  const cartPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  double _totalAmount = 0.0;
  late User _userData = widget.userData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_userData.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          if (snapshot.data?['items'] != null &&
              snapshot.data?['items'].isNotEmpty) {
            _totalAmount = 0.0;
            snapshot.data?['items'].forEach((item) {
              _totalAmount += item['Prix'];
            });
            return Column(
              children: [
                Text('Prix total: $_totalAmount€'),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?['items'].length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 120.0,
                                height: 120.0,
                                child: Image.network(
                                    snapshot.data?['items'][index]["image"]),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data?['items'][index]["titre"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'Taille: ${snapshot.data?['items'][index]["Taille"]}'),
                                  Text(
                                      'Prix: ${snapshot.data?['items'][index]["Prix"]}€'),
                                ],
                              ),
                              Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  final items =
                                      snapshot.data?['items'].toList();
                                  items.removeAt(index);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(_userData.uid)
                                      .update({
                                    'items': items,
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            _totalAmount = 0.0;
            return Center(
              child: Text('Votre panier est vide'),
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
