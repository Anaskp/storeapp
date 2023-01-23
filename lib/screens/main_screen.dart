import 'package:badges/badges.dart';
import 'package:e_store/model/models.dart';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List _pages = [
    const HomeScreen(),
    const SearchScreen(),
    CartScreen(),
    const ProfileScreen(),
  ];

  var _selectedIndex = 0;
  int? _count;
  @override
  Widget build(BuildContext context) {
    final cp = Provider.of<CartProvider>(context, listen: true);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedIndex,
        items: [
          const BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Badge(
                elevation: 0,
                badgeContent: Text(
                  _count == null ? '0' : _count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const Icon(Icons.shopping_bag)),
          ),
          const BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  getData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final cp = Provider.of<CartProvider>(context, listen: false);
    await cp.fetchCart(context);

    _count = cp.count;
    print(_count);

    await ap.getUserData();
  }
}
