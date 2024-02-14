import 'package:flutter/material.dart';

import 'package:flavour_quest/screens/categories.dart';
import 'package:flavour_quest/screens/meals.dart';

class TabsScreen extends StatefulWidget{
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPageIndex = 0;

  void selectPage(int index){
    setState(() {
      selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var activePageTitle = 'Categories';

    Widget activePage = const CategoriesScreen();
    if(selectedPageIndex == 1){
      activePageTitle = 'Favourites';
      activePage = const MealsScreen(meals: []);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal_rounded), label: 'Categories',),
          BottomNavigationBarItem(icon: Icon(Icons.star_rate_rounded), label: 'Favourites',),
        ],
      ),
    );
  }
}