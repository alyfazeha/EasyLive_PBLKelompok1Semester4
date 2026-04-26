import 'package:flutter/material.dart';
import '../../widgets/home/header_slider.dart';
import '../../controllers/home_controller.dart';
import '../../models/kos_model.dart';
import '../../widgets/home/bottom_navbar.dart';
import '../../views/kos/kos_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    // Pastikan HomeController mengembalikan list yang benar
    final String userName = HomeController.getUserName() ?? "User";
    final List<KostModel> kostList = HomeController.getKostList() ?? [];

    int displayCount = _showAll 
        ? kostList.length 
        : (kostList.length > 4 ? 4 : kostList.length);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, 
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- SECTION 1: HEADER & SLIDER ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3E50),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 25,
                  right: 25,
                  child: _buildHeader(userName),
                ),
                const Positioned(
                  top: 175,
                  left: 0,
                  right: 0,
                  child: HeaderSlider(),
                ),
              ],
            ),

            const SizedBox(height: 190),

            // --- SECTION 2: CATEGORY ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildCategorySection(),
            ),

            const SizedBox(height: 30),

            // --- SECTION 3: BANNER ---
            const _BookingBanner(),

            // --- SECTION 4: KOST GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'See All Kost',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3E50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Proteksi jika list kosong
                  kostList.isEmpty 
                  ? const Center(child: Text("No Data Available"))
                  : GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayCount, 
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.65, 
                    ),
                    itemBuilder: (context, index) => _KostGridCard(kost: kostList[index]),
                  ),
                  
                  const SizedBox(height: 30),

                  if (kostList.length > 4)
                    InkWell(
                      onTap: () => setState(() => _showAll = !_showAll),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          _showAll ? "Show Less" : "See More",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Color(0xFF2D3E50),
                            decoration: TextDecoration.underline,
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
      // PERBAIKAN: Hapus 'const' dan tambahkan fungsi onTap
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const KosView()));
          }
        },
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage('assets/images/alyfa.jpeg'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi $name,', style: const TextStyle(fontFamily: 'Montserrat', fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
              const Text('Welcome to EasyLive !', style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.white70)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFFFD141), borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.notifications, color: Color(0xFF2D3E50), size: 28),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KosView())),
            borderRadius: BorderRadius.circular(25),
            child: const _CategoryBtn(icon: Icons.home_rounded, label: 'Kost'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur Jasa Pindah segera hadir!")),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: const _CategoryBtn(icon: Icons.local_shipping_rounded, label: 'Jasa Pindah'),
          ),
        ),
      ],
    );
  }
}

// --- CLASS PENDUKUNG TETAP SAMA NAMUN PASTIKAN TIPE DATA SESUAI ---

class _BookingBanner extends StatelessWidget {
  const _BookingBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135,
      color: const Color(0xFF2D3E50),
      child: const Stack(
        children: [
          Positioned(
            top: 25, left: 30,
            child: Text('BOOKING', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w900, fontSize: 38, color: Colors.white, height: 0.9)),
          ),
          Positioned(
            bottom: 20, right: 30,
            child: Text('NOW!', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w900, fontSize: 62, color: Color(0xFFFFD141), height: 0.9)),
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
    // Format price dengan titik sebagai pemisah ribuan
    String formattedPrice = widget.kost.price != null 
        ? 'Rp ${_formatPrice(widget.kost.price!)}' 
        : 'Rp 0';
    
    // Dummy viewers untuk tampilan (bisa diganti dengan data dari model)
    final viewers = widget.kost.price != null && widget.kost.price! > 1000000 ? '1,3 K' : '15 K';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2), 
        borderRadius: BorderRadius.circular(30)
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
                height: 100, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(height: 100, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
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
                        widget.kost.name, 
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900, 
                          fontSize: 13,
                          color: Color(0xFF2D3E50),
                        ), 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isFavorite = !isFavorite),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border, 
                        color: isFavorite ? Colors.red : Colors.black, 
                        size: 20
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
                    color: Colors.black54
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Stats (Viewers | Verified)
                Row(
                  children: [
                    Text(
                      viewers,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        color: Color(0xFF2D3E50),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("|", style: TextStyle(color: Colors.grey)),
                    ),
                    const Icon(Icons.verified_user_outlined, size: 18, color: Colors.black87),
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
                    const Icon(Icons.more_horiz, color: Colors.grey, size: 24),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Fungsi untuk format price dengan titik
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
        color: const Color(0xFFFFD141),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF2D3E50)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ],
      ),
    );
  }
}