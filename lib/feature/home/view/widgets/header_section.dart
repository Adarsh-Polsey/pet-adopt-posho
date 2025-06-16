import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/history/view/history_screen.dart';
import 'package:pet_adopt_posha/feature/home/view/widgets/bookmark_button.dart';
import 'package:pet_adopt_posha/feature/wishlist/view/wishlist_screen.dart';
import 'package:pet_adopt_posha/utils/theme.dart';

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello! 👋',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Find Your Perfect Pet',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Spacer(),
          CustomButton(
            icon: Icon(Icons.brightness_6),
            onTap: () {
              final current = ref.read(themeNotifierProvider);
              final notifier = ref.read(themeNotifierProvider.notifier);

              notifier.setTheme(
                current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          SizedBox(width: 10),
          CustomButton(
            icon: Icon(Icons.favorite_outline),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishlistScreen()),
            ),
          ),
          SizedBox(width: 10),
          CustomButton(
            icon: Icon(Icons.history),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
