import 'package:flutter/material.dart';

import 'package:flavour_quest/screens/categories.dart';
import 'package:flavour_quest/screens/meals.dart';
import 'package:flavour_quest/models/meal_model.dart';
import 'package:flavour_quest/widgets/main_drawer.dart';
import 'package:flavour_quest/screens/filters.dart';
import 'package:flavour_quest/data/dummy_data.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    final isExisting = _favouriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showInfoMessage('Meal removed from favourites.');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showInfoMessage('Meal added to favourites.');
    }
  }

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void _setScreen(String indentifier) async {
    Navigator.pop(context);
    if (indentifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(currentFilters: selectedFilters),
        ),
      );
      setState(() {
        selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal){
      if(selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if(selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if(selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if(selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    var activePageTitle = 'Categories';

    Widget activePage = CategoriesScreen(
      onTogglefavourite: _toggleMealFavouriteStatus,
      availableMeals: availableMeals,
    );
    if (selectedPageIndex == 1) {
      activePageTitle = 'Favourites';
      activePage = MealsScreen(
        meals: _favouriteMeals,
        onTogglefavourite: _toggleMealFavouriteStatus,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rate_rounded),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
