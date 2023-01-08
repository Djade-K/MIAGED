import 'package:flutter/material.dart';
import 'user.dart';
import 'pages/buyPage.dart';
import 'pages/cartPage.dart';
import 'pages/profilePage.dart';

class homeScreen extends StatefulWidget {
  final User user;
  const homeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late User _userData = widget.user;
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return buyPage(userData: _userData);
        break;
      case 1:
        return cartPage(userData: _userData);
      case 2:
        return profilePage(userData: _userData);
      default:
        return buyPage(userData: _userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _selectedIndex == 0 ? null : AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("MIAGED"),
          ),
          body: getPage(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Acheter"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "Panier"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: "Profil"),
            ],
          ),
        ));
  }
}
