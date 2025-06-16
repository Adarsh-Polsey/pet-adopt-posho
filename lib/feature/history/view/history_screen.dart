import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/history/viewmodel/history_viewmodel.dart';
import 'package:pet_adopt_posha/shared/widgets/petlist_section.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsState = ref.watch(historyViewModelProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(10),
        centerTitle: true,
        title: Text(
          'Your Adopted Pets',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, top: 8),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Icon(Icons.arrow_back_ios_new, size: 24),
            ),
          ),
        ),
      ),
      body: SafeArea(child: PetListSection(petsState: petsState)),
    );
  }
}
