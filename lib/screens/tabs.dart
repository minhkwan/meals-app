import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/provider/favorites_provider.dart';
import 'package:meals_app/provider/meals_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/screens/filters.dart';

import 'package:riverpod/riverpod.dart';

import '../models/meal.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lacosteFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false
};

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedScreen = 0;
  var activePageTitle = 'Categories';

  Map<Filter, bool> _chosenFilter = kInitialFilters;

  void _onSelectScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(
              builder: (ctx) => FiltersScreen(currentFilters: _chosenFilter)));
      setState(() {
        _chosenFilter = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealProvider);
    final _availableMeals = meals.where((meal) {
      if (_chosenFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_chosenFilter[Filter.lacosteFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_chosenFilter[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_chosenFilter[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      availableMeal: _availableMeals,
    );

    if (_selectedScreen == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        mealList: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
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
