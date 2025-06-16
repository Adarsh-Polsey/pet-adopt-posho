import 'package:flutter/material.dart';
import 'package:pet_adopt_posha/utils/app_pallette.dart';

class CustomButton extends StatelessWidget {
  final Icon icon;
  final void Function() onTap;
  const CustomButton({super.key, required this.icon,required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onTap();},
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Pallete.primaryLight.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor.withValues(alpha: 0.4),
        ),
        child: icon,
      ),
    );
  }
}
