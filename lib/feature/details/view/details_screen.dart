import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/details/viewmodel/detail_viewmodel.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';
import 'package:pet_adopt_posha/utils/app_pallette.dart';
import 'package:pet_adopt_posha/shared/widgets/custom_image_viewer.dart';
import 'package:pet_adopt_posha/shared/widgets/custom_widgets.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final int petId;
  const DetailsScreen({super.key, required this.petId});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  late ConfettiController _confettiController;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showConfettiAndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adoption Successful!'),
        content: const Text('Thank you for giving this pet a loving home!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() => _showConfetti = true);
              _confettiController.play();

              Future.delayed(const Duration(seconds: 5), () {
                setState(() => _showConfetti = false);
                _confettiController.stop();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(detailViewModelProvider(widget.petId));
    final notifier = ref.read(detailViewModelProvider(widget.petId).notifier);

    return Scaffold(
      body: petState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (pet) {
          if (pet == null) return const Center(child: Text('Pet not found'));
          return Stack(
            children: [
              PetDetailsContent(pet: pet, notifier: notifier),
              if (_showConfetti)
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -math.pi / 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 30,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 22,
                  ),
                  child: PetActionBar(
                    pet: pet,
                    notifier: notifier,
                    onAdopt: () async {
                      final success =
                          await ref
                              .read(detailViewModelProvider(pet.id).notifier)
                              .adoptPet(context: context) ??
                          false;

                      if (success) {
                        _showConfettiAndDialog(context);
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PetDetailsContent extends StatelessWidget {
  final Pet pet;
  final DetailViewModel notifier;

  const PetDetailsContent({
    super.key,
    required this.pet,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leadingWidth: 65,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.primaryLight.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(15),
                color: theme.colorScheme.onSurface.withAlpha(130),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          expandedHeight: 350,
          flexibleSpace: PetImageHeader(pet: pet),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PetDescriptionSection(pet: pet),
                const SizedBox(height: 24),
                PetAttributesGrid(pet: pet),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PetImageHeader extends StatelessWidget {
  final Pet pet;

  const PetImageHeader({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomImageViewer(
                imageUrl: pet.imageUrl,
                heroId: "pet-image-${pet.id}",
              ),
            ),
          ),
          child: Hero(
            tag: 'pet ${pet.id}',
            child: CachedNetworkImage(
              imageUrl: pet.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, __) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.pets, size: 100),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pet.breed,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "₹${pet.price}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PetDescriptionSection extends StatelessWidget {
  final Pet pet;

  const PetDescriptionSection({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About ${pet.name}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            pet.description.isEmpty
                ? "No description available."
                : pet.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class PetAttributesGrid extends StatelessWidget {
  final Pet pet;

  const PetAttributesGrid({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildAttributeCard(
          context,
          icon: Icons.cake,
          title: 'Age',
          value: '${pet.age} years',
          color: Colors.green,
        ),
        _buildAttributeCard(
          context,
          icon: Icons.wc,
          title: 'Gender',
          value: pet.gender,
          color: Colors.pink,
        ),
        _buildAttributeCard(
          context,
          icon: Icons.color_lens,
          title: 'Color',
          value: pet.color,
          color: Colors.teal,
        ),
        _buildAttributeCard(
          context,
          icon: Icons.vaccines,
          title: 'Vaccinated',
          value: pet.vaccinated ? 'Yes' : 'No',
          color: Colors.red,
        ),
        _buildAttributeCard(
          context,
          icon: Icons.monitor_weight,
          title: 'Weight',
          value: '${pet.weightKg} kg',
          color: Colors.blue,
        ),
        _buildAttributeCard(
          context,
          icon: Icons.category,
          title: 'Category',
          value: pet.category,
          color: Colors.cyan,
        ),
      ],
    );
  }

  Widget _buildAttributeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class PetActionBar extends StatelessWidget {
  final Pet pet;
  final DetailViewModel notifier;
  final VoidCallback onAdopt;

  const PetActionBar({
    super.key,
    required this.pet,
    required this.notifier,
    required this.onAdopt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomWidgets.filledButton(
            text: pet.isAdopted ? 'Already Adopted' : 'Adopt Me',
            isEnabled: !pet.isAdopted,
            onPressed: () {
              if (!pet.isAdopted) {
                onAdopt();
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Consumer(
          builder: (context, ref, _) {
            final wishlistProvider = ref.watch(isWishlistedProvider(pet.id));
            return wishlistProvider.when(
              data: (isWishlisted) {
                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(detailViewModelProvider(pet.id).notifier)
                          .toggleWishlist();
                      ref.invalidate(isWishlistedProvider(pet.id));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWishlisted
                          ? Colors.redAccent.withValues(alpha: 0.1)
                          : Theme.of(context).cardColor,
                      foregroundColor: isWishlisted
                          ? Colors.redAccent
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isWishlisted
                              ? Colors.redAccent
                              : Colors.grey.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                    ),
                    child: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                    ),
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return SizedBox.shrink();
              },
              loading: () {
                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      foregroundColor: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                    ),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
