import 'package:flutter/material.dart';

import 'package:flavour_quest/data/dummy_data.dart';
import 'package:flavour_quest/widgets/category_grid_item.dart';
import 'package:flavour_quest/screens/meals.dart';
import 'package:flavour_quest/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals.where((meal) => meal.categories.contains(category.id)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              definedCategory: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      );
  }
}
