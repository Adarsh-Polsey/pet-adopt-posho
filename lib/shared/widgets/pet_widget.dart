import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';
import 'package:pet_adopt_posha/shared/widgets/pet_image.dart';

class PetWidget extends StatefulWidget {
  const PetWidget({
    super.key,
    this.onTap,
    required this.pet,
    required this.isAlreadyAdopted,
  });

  final GestureTapCallback? onTap;
  final Pet pet;
  final bool isAlreadyAdopted;

  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  bool _isPressed = false;

  void _updatePressed(bool pressed) {
    if (mounted) {
      setState(() => _isPressed = pressed);
      if (pressed) HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final cardWidth = isMobile ? double.infinity : 300.0;
    final cardHeight = isMobile ? 160.0 : 180.0;
    final imageSize = isMobile ? 100.0 : 120.0;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _updatePressed(true),
      onTapUp: (_) => _updatePressed(false),
      onTapCancel: () => _updatePressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildContent(context, imageSize, isMobile),
              if (widget.isAlreadyAdopted) _buildAdoptedBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double imageSize, bool isMobile) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildImage(imageSize),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitle(theme, isMobile),
                _buildChips(theme, isMobile),
                _buildDescription(theme, isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double size) {
    return Hero(
      tag: 'pet ${widget.pet.id}',
      createRectTween: (begin, end) {
        return MaterialRectArcTween(
          begin: begin,
          end: end,
        ); // Or your custom tween
      },
      child: Container(
        width: size,
        height: size * 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: PetImageWidget(imagePath: widget.pet.imageUrl),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.pet.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        Text(
          widget.pet.breed,
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildChips(ThemeData theme, bool isMobile) {
    Color categoryColor = widget.pet.category.toLowerCase() == 'dog'
        ? Colors.green
        : Colors.orange;
    IconData categoryIcon = widget.pet.category.toLowerCase() == 'dog'
        ? Icons.pets
        : Icons.pets;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        _buildChip(Icons.cake_outlined, '${widget.pet.age}y', Colors.teal),
        _buildChip(
          Icons.monitor_weight_outlined,
          '${widget.pet.weightKg}kg',
          Colors.blue,
        ),
        _buildChip(
          widget.pet.gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
          widget.pet.gender,
          Colors.purple,
        ),
        _buildChip(categoryIcon, widget.pet.category, categoryColor),
      ],
    );
  }

  Widget _buildChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme, bool isMobile) {
    return Text(
      widget.pet.description,
      style: theme.textTheme.bodySmall?.copyWith(
        fontSize: isMobile ? 9 : 10,
        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAdoptedBadge() {
    return Positioned(
      right: 12,
      top: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB74D), Color(0xFFFFA726)],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 10, color: Colors.white),
            SizedBox(width: 3),
            Text(
              'ADOPTED',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
