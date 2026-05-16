import 'package:flutter/material.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> photos;

  const PhotoGallery({
    super.key,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const Text(
        'No photos available',
        style: TextStyle(color: Colors.grey),
      );
    }

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              photos[index],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}