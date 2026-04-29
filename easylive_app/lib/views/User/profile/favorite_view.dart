import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/favorite_controller.dart';
import '../../../models/kos_model.dart';
import '../../../widgets/profile/favorite.dart';
import '../kos/detailKos_view.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<KostModel> favorites = FavoriteController.getFavorites();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Favorit"),
        backgroundColor: AppColors.darkBlue,
      ),

      body: favorites.isEmpty
          ? const FavoriteEmpty()
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                childAspectRatio: 0.90,
              ),
              itemBuilder: (context, index) {
                final kost = favorites[index];

                return FavoriteCard(
                  kost: kost,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailKosView(kost: kost),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
