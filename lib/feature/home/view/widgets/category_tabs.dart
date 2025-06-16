import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  final void Function(String)? onCategorySelected;

  const CategoryTabs({super.key, this.onCategorySelected});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  final List<String> categories = ['Dogs', 'All', 'Cats'];
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: categories.map((category) {
        final bool isSelected = selectedCategory == category;
        BorderRadius? borderRadius;
        if (category == categories.first) {
          borderRadius = const BorderRadius.horizontal(
            left: Radius.circular(20),
          );
        } else if (category == categories.last) {
          borderRadius = const BorderRadius.horizontal(
            right: Radius.circular(20),
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() => selectedCategory = category);
            widget.onCategorySelected?.call(category);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withAlpha(50)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.6)
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: borderRadius,
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
