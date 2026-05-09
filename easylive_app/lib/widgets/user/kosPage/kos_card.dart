import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../models/user/kos_model.dart';
import '../../../controllers/user/favorite_controller.dart';

class KostCard extends StatefulWidget {
  final KostModel kost;
  final int index;
  const KostCard({super.key, required this.kost, required this.index});

  @override
  State<KostCard> createState() => _KostCardState();
}

class _KostCardState extends State<KostCard> {
  bool _isFavorite = false;

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
    final viewers = widget.kost.price != null && widget.kost.price! > 1000000
        ? '1,3 K'
        : '15 K';

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail_kos', arguments: widget.kost);
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.all(9),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Hero(
                  tag: 'kos_image_${widget.kost.name}_${widget.index}',
                  child: Image.asset(
                    widget.kost.image,
                    height: 92,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                  // Title & Favorite
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
                            color: AppColors.darkBlue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey(_isFavorite),
                            color: _isFavorite
                                ? Colors.red
                                : AppColors.darkBlue,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Address
                  Text(
                    widget.kost.address,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 8,
                      color: Colors.black54,
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Stats (Viewers | Verified)
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        viewers,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("|", style: TextStyle(color: Colors.grey)),
                      ),
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price & More Button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.golden,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            "Rp ${_formatPrice(widget.kost.price ?? 0)},-",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 9.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                        size: 22,
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
