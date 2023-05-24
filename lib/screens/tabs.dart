import 'package:flutter/material.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

import '../models/meal.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedScreen = 0;
  var activePageTitle = 'Categories';
  List<Meal> favoriteMeal = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _onSelectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  void toggleFavoriteMeal(Meal item) {
    final isExisting = favoriteMeal.contains(item);
    if (isExisting) {
      setState(() {
        favoriteMeal.remove(item);
      });
      _showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        favoriteMeal.add(item);
      });
      _showInfoMessage('Marked as a favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: toggleFavoriteMeal,
    );

    if (_selectedScreen == 1) {
      activePage = MealsScreen(
        mealList: favoriteMeal,
        onToggleFavorite: toggleFavoriteMeal,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: const MainDrawer(),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreen,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
            backgroundColor: Colors.green,
          ),
        ],
        selectedItemColor: Colors.amber[800],
        onTap: _onSelectScreen,
      ),
    );
  }
}
