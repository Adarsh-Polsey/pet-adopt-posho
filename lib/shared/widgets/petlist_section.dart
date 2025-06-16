import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/config/firestore_exceptions.dart';
import 'package:pet_adopt_posha/feature/details/view/details_screen.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';
import 'package:pet_adopt_posha/shared/widgets/pet_widget.dart';

class PetListSection extends StatelessWidget {
  final AsyncValue<List<Pet>> petsState;
  final ScrollController? scrollController;

  const PetListSection({
    super.key,
    required this.petsState,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return petsState.when(
      data: (petsList) => _buildPetList(petsList, theme),
      loading: () => _buildLoadingState(theme),
      error: (error, _) => _buildErrorState(error, theme),
    );
  }

  Widget _buildPetList(List<Pet> petsList, ThemeData theme) {
    if (petsList.isEmpty) return _buildEmptyState(theme);

    return ListView.builder(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: petsList.length,
      itemBuilder: (context, index) => PetWidget(
        pet: petsList[index],
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailsScreen(petId: petsList[index].id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SizeTransition(sizeFactor: animation, child: child);
                },
          ),
        ),
        isAlreadyAdopted: petsList[index].isAdopted,
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets_outlined,
            size: 80,
            color: theme.primaryColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text('No pets found', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.primaryColor),
          const SizedBox(height: 16),
          Text('Finding pets for you...', style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('Oops! Something went wrong', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            error is FirestoreException
                ? error.message
                : 'Unexpected error occurred',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
