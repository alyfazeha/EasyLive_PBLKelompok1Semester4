import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../models/user/kos_model.dart';
import '../../../controllers/user/favorite_controller.dart';

class ItemCard extends StatefulWidget {
  final KostModel kost;
  final VoidCallback? onTap;
  const ItemCard({super.key, required this.kost, this.onTap});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = FavoriteController.isFavorite(widget.kost.name);
  }

  void _toggleFavorite() {
    FavoriteController.toggleFavorite(widget.kost.name);
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? "${widget.kost.name} ditambahkan ke favorit"
              : "${widget.kost.name} dihapus dari favorit",
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: _isFavorite ? Colors.green : Colors.red,
      ),
    );
  }

  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = '.' + result;
      }
      result = priceStr[i] + result;
      count++;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final viewers = widget.kost.price != null && (widget.kost.price! > 1000000)
        ? '1,3 K'
        : '15 K';
    final formattedPrice = 'Rp ${_formatPrice(widget.kost.price ?? 0)}';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  widget.kost.image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    color: AppColors.lightGreyAlt,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Favorite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.kost.name,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? AppColors.red : AppColors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  // Address
                  Text(
                    widget.kost.address,
                    maxLines: 1,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 8,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Viewers | Verified
                  Row(
                    children: [
                      Text(
                        viewers,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("|", style: TextStyle(color: Colors.grey)),
                      ),
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Price Badge & More
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.golden,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            formattedPrice,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
