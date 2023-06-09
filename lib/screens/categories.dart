import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/screens/meals.dart';

import '../models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.availableMeal});

  final List<Meal> availableMeal;

  void _onSelectCategory(BuildContext context, Category items) {
    final filteredMeals = availableMeal
        .where((meal) => meal.categories.contains(items.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: items.title,
          mealList: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoryItem(
            item: category,
            onSelectCategory: () {
              _onSelectCategory(context, category);
            },
          )
      ],
    );
  }
}
