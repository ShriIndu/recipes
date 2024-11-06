import 'package:flutter/material.dart';
import 'home_page/home_page.dart';
import 'Package:recipes/home/collections_page.dart';
import 'Package:recipes/home/shop_page.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  BottomNavigation({required this.selectedIndex});
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomePage(),
    FavoriteRecipesPage(),
    Shop(selectedIndex: 2),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void onTabTapped(int index) {
    setState(() {
    _currentIndex = index;
  });
 }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _tabs[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blue,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
         icon: Icon(Icons.shopping_cart),
         label: 'Shop',
        ),
      ],
    ),
  );
}
}



