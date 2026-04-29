import 'package:flutter/material.dart';
import '../../../controllers/kos_controller.dart';
import '../../../models/kos_model.dart';
import '../../../widgets/kosPage/detail_kos_widgets.dart';
import '../../../core/color.dart';

class DetailKosView extends StatefulWidget {
  final KostModel kost;
  const DetailKosView({super.key, required this.kost});

  @override
  State<DetailKosView> createState() => _DetailKosViewState();
}

class _DetailKosViewState extends State<DetailKosView> {
  final controller = KostController();

  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = '.$result';
      }
      result = priceStr[i] + result;
      count++;
    }
    return 'Rp $result,-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                DetailHeader(
                  imagePath: 'assets/images/kamarKos.jpg',
                  isFavorite: controller.isFavorite,
                  heroTag: 'kos_image_${widget.kost.name}',
                  onBack: () => Navigator.pop(context),
                  onFavorite: () => setState(() => controller.toggleFavorite()),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 0.95,
                  builder: (_, scrollController) => Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(25),
                      children: [
                        Text(
                          widget.kost.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.kost.description ?? "No description",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _formatPrice(widget.kost.price ?? 0),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Specifications",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (widget.kost.specifications ?? [])
                                  .map((e) => Text(e))
                                  .toList(),
                            ),
                            Text("Rooms: ${widget.kost.availableRooms ?? 0}"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Facilities",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.kost.facilities?.length ?? 0,
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return FacilityChip(
                                label: widget.kost.facilities![index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/personal_info',
                    arguments: widget.kost,
                  );
                },
                child: const Text(
                  "Select Room",
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
