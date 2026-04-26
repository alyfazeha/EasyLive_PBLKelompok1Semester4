import 'package:flutter/material.dart';
import '../../controllers/kos_controller.dart';
import '../../models/kos_model.dart';
import '../../widgets/kosPage/detail_kos_widgets.dart';
import '../../core/color.dart';

class DetailKosView extends StatefulWidget {
  final KostModel kost;
  const DetailKosView({super.key, required this.kost});

  @override
  State<DetailKosView> createState() => _DetailKosViewState();
}

class _DetailKosViewState extends State<DetailKosView> {
  final controller = KostController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DetailHeader(
            imagePath: 'assets/images/kamarKos.jpg',
            isFavorite: controller.isFavorite,
            heroTag:
                'kos_image_${widget.kost.name}', // <--- Tambahkan baris ini
            onBack: () => Navigator.pop(context),
            onFavorite: () => setState(() => controller.toggleFavorite()),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (_, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
                      "Rp.${widget.kost.price}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Specifications",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: (widget.kost.facilities ?? [])
                        .map((e) => FacilityChip(label: e))
                        .toList(),
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Select Room",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
