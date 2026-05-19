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

  double _scaleForWidth(double width) {
    // Di GridView user/kos_view: crossAxisCount 2 dan childAspectRatio 0.82.
    // Saat layar HP mengecil, card jadi lebih sempit -> gunakan scale agar tidak overflow.
    final w = width.clamp(160.0, 220.0);
    return w / 220.0;
  }

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

    if (!mounted) return;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = _scaleForWidth(constraints.maxWidth);

        final imageHeight = (92 * scale).clamp(70.0, 92.0);
        final titleSize = (13 * scale).clamp(11.0, 13.0);
        final addressSize = (8 * scale).clamp(7.0, 8.0);
        final statsSize = (10 * scale).clamp(9.0, 10.0);
        final priceFontSize = (9.5 * scale).clamp(8.0, 9.5);

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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (8 * scale).clamp(6.0, 8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all((9 * scale).clamp(7.0, 9.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: 'kos_image_${widget.kost.name}_${widget.index}',
                        child: Image.asset(
                          widget.kost.image,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      (12 * scale).clamp(10.0, 12.0),
                      0,
                      (12 * scale).clamp(10.0, 12.0),
                      (12 * scale).clamp(8.0, 12.0),
                    ),
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
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w900,
                                  fontSize: titleSize,
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
                                  size: (20 * scale).clamp(18.0, 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Address
                        Text(
                          widget.kost.address,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: addressSize,
                            color: Colors.black54,
                            height: 1.15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: (6 * scale).clamp(5.0, 6.0)),

                        // Stats (Viewers | Verified)
                        Row(
                          children: [
                            SizedBox(width: (5 * scale).clamp(4.0, 5.0)),
                            Text(
                              viewers,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                                fontSize: statsSize,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "|",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 16,
                              color: Colors.black87,
                            ),
                          ],
                        ),

                        SizedBox(height: (8 * scale).clamp(7.0, 8.0)),

                        // Price & More
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: (8 * scale).clamp(6.0, 8.0),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.golden,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  "Rp ${_formatPrice(widget.kost.price ?? 0)},-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                    fontSize: priceFontSize,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: (6 * scale).clamp(5.0, 6.0)),
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
          ),
        );
      },
    );
  }
}
