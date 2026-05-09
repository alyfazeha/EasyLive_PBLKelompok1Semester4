import 'package:flutter/material.dart';
import 'dart:async';
import '../../../controllers/user/home_controller.dart';
import '../../../models/user/kos_model.dart';
import '../../../widgets/user/home/bottom_navbar.dart';
import '../../../widgets/user/home/item_card.dart';
import '../../../views/User/kos/kos_view.dart';
import '../../../views/User/jasa/jasa_view.dart';
import '../../../views/User/notification/notification_view.dart';
import 'package:easylive_app/views/User/kos/detailKos_view.dart';
import '../../../core/color.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showAll = false;
  final PageController _recommendedController = PageController(
    viewportFraction: 0.88,
  );
  Timer? _recommendedTimer;
  int _currentRecommended = 0;

  @override
  void initState() {
    super.initState();
    _startRecommendedAutoPlay();
  }

  void _startRecommendedAutoPlay() {
    _recommendedTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final kostList = HomeController.getKostList();
      final sliderCount = kostList.length > 3 ? 3 : kostList.length;
      if (!_recommendedController.hasClients || sliderCount <= 1) return;

      final nextPage = (_currentRecommended + 1) % sliderCount;
      _recommendedController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _recommendedTimer?.cancel();
    _recommendedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userName = HomeController.getUserName();
    final List<KostModel> kostList = HomeController.getKostList();

    int displayCount = _showAll
        ? kostList.length
        : (kostList.length > 4 ? 4 : kostList.length);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 252,
                  decoration: const BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 172,
                  child: Container(height: 250, color: AppColors.background),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
                  child: _buildHeader(userName),
                ),
                if (kostList.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 118,
                    child: _buildRecommendedCarousel(kostList),
                  ),
              ],
            ),
            const SizedBox(height: 128),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildCategorySection(),
            ),
            const SizedBox(height: 30),
            const _BookingBanner(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'See All Kost',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  kostList.isEmpty
                      ? const Center(child: Text("No Data Available"))
                      : GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayCount,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.82,
                              ),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailKosView(kost: kostList[index]),
                                ),
                              );
                            },
                            child: ItemCard(kost: kostList[index]),
                          ),
                        ),
                  const SizedBox(height: 30),
                  if (kostList.length > 4)
                    Center(
                      child: InkWell(
                        onTap: () => setState(() => _showAll = !_showAll),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Text(
                            _showAll ? "Show Less" : "See More",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: AppColors.darkBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/history');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/booking');
          }
        },
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.yellow,
            child: Icon(
              Icons.person_rounded,
              color: AppColors.darkBlue,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $name,',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.background,
                ),
              ),
              const Text(
                'Welcome to EasyLive !',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationView()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.notifications,
              color: AppColors.darkBlue,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KosView()),
            ),
            borderRadius: BorderRadius.circular(25),
            child: const _CategoryBtn(icon: Icons.home_rounded, label: 'Kost'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JasaView()),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: const _CategoryBtn(
              icon: Icons.local_shipping_rounded,
              label: 'Jasa Pindah',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCarousel(List<KostModel> kostList) {
    final sliderItems = kostList.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 38),
          child: Text(
            '#Recommended For You!',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.background,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 192,
          child: PageView.builder(
            controller: _recommendedController,
            itemCount: sliderItems.length,
            onPageChanged: (index) {
              setState(() => _currentRecommended = index);
            },
            itemBuilder: (context, index) {
              return _RecommendedCard(
                kost: sliderItems[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailKosView(kost: sliderItems[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            sliderItems.length,
            (index) => _CarouselDot(active: _currentRecommended == index),
          ),
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final KostModel kost;
  final VoidCallback onTap;

  const _RecommendedCard({required this.kost, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            kost.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _CarouselDot extends StatelessWidget {
  final bool active;

  const _CarouselDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 8 : 6,
      height: active ? 8 : 6,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        color: active ? AppColors.darkBlue : AppColors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _BookingBanner extends StatelessWidget {
  const _BookingBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135,
      color: AppColors.darkBlue,
      child: const Stack(
        children: [
          Positioned(
            top: 25,
            left: 30,
            child: Text(
              'BOOKING',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w900,
                fontSize: 38,
                color: AppColors.background,
                height: 0.9,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 30,
            child: Text(
              'NOW!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w900,
                fontSize: 62,
                color: AppColors.golden,
                height: 0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KostGridCard extends StatefulWidget {
  final KostModel kost;
  const _KostGridCard({required this.kost});

  @override
  State<_KostGridCard> createState() => _KostGridCardState();
}

class _KostGridCardState extends State<_KostGridCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    String formattedPrice = widget.kost.price != null
        ? 'Rp ${_formatPrice(widget.kost.price!)}'
        : 'Rp 0';
    final viewers = widget.kost.price != null && widget.kost.price! > 1000000
        ? '1,3 K'
        : '15 K';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailKosView(kost: widget.kost)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        onTap: () => setState(() => isFavorite = !isFavorite),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppColors.red : AppColors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
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
    return result;
  }
}

class _CategoryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CategoryBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.darkBlue),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
