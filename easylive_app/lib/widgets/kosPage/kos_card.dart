import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../models/kos_model.dart';

class KostCard extends StatelessWidget {
  final KostModel kost;
  final int index;

  const KostCard({super.key, required this.kost, required this.index});

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
    final viewers = kost.price != null && kost.price! > 1000000
        ? '1,3 K'
        : '15 K';

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detail_kos', arguments: kost);
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Hero(
                  tag: 'kos_image_${kost.name}_$index',
                  child: Image.asset(
                    kost.image,
                    height: 105,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Favorite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          kost.name,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Color(0xFF2D3E50),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Color(0xFF2D3E50),
                        size: 20,
                      ),
                    ],
                  ),

                  // Address
                  Text(
                    kost.address,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 8.5,
                      color: Colors.black54,
                      height: 1.2,
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 8),

                  // Stats (Viewers | Verified)
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        viewers,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
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

                  // Price & More Button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD141),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Rp ${_formatPrice(kost.price ?? 0)},-",
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
