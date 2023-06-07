import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_detail.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.mealList,
  });

  final String? title;
  final List<Meal> mealList;

  @override
  Widget build(BuildContext context) {
    void onSelectMeal(BuildContext context, Meal item) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MealDetails(
            item: item,
          ),
        ),
      );
    }

    Widget content = ListView.builder(
      itemCount: mealList.length,
      itemBuilder: (context, index) => MealItem(
          item: mealList[index],
          onSelectMeal: () {
            onSelectMeal(context, mealList[index]);
          }),
    );

    if (mealList.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sorry!!! Nothing here.',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Try another category.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
