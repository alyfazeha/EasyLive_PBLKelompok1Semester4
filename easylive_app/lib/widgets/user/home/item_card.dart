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

  void _toggleFavorite() async {
    await FavoriteController.toggleFavorite(widget.kost.name);
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
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive sizing untuk mencegah overflow di HP (khususnya saat grid sempit)
            final cardWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            // Pakai ukuran lebih kecil saat grid menjadi sempit supaya tidak overflow.
            final imageHeight = (cardWidth * 0.30).clamp(62.0, 86.0);
            final nameFontSize = (cardWidth * 0.043).clamp(11.0, 13.0);
            final addressFontSize = (cardWidth * 0.0205).clamp(6.5, 8.0);
            final priceFontSize = (cardWidth * 0.0255).clamp(8.5, 9.5);
            final viewersFontSize = (cardWidth * 0.0245).clamp(8.5, 10.0);
            final favIconSize = (cardWidth * 0.055).clamp(16.5, 20.0);
            final moreIconSize = (cardWidth * 0.080).clamp(19.0, 22.0);
            final verifiedIconSize = (cardWidth * 0.090).clamp(13.5, 16.0);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.kost.image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: imageHeight,
                        color: AppColors.lightGreyAlt,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.kost.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                fontSize: nameFontSize,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleFavorite,
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite
                                  ? AppColors.red
                                  : AppColors.black,
                              size: favIconSize,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.kost.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: addressFontSize,
                          height: 1.15,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              viewers,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                                fontSize: viewersFontSize,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "|",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Icon(
                            Icons.verified_user_outlined,
                            size: verifiedIconSize,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.golden,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                formattedPrice,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w900,
                                  fontSize: priceFontSize,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                            size: moreIconSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
