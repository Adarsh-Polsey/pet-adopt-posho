import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomImageViewer extends StatelessWidget {
  final String imageUrl;
  final String heroId;

  const CustomImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black87,
          child: Center(
            child: Hero(
              tag: heroId,
              child: PhotoView(
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image);
                },
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
