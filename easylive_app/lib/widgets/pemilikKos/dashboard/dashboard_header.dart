import 'package:flutter/material.dart';
import '../../../core/color.dart';

class DashboardHeader extends StatelessWidget {
  final String ownerName;
  final int totalKost;
  final int kamarTersedia;
  final int bookingBaru;
  final String pendapatan;

  const DashboardHeader({
    super.key,
    required this.ownerName,
    required this.totalKost,
    required this.kamarTersedia,
    required this.bookingBaru,
    required this.pendapatan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xff2c3e50),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 21,
                    backgroundColor: AppColors.yellow,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.darkBlue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $ownerName', // ← dari Supabase
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text.rich(
                        TextSpan(
                          text: 'Welcome to ',
                          children: [
                            TextSpan(
                              text: 'EasyLive !',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, '/pemilik_kos/notifikasi'),
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _statItem(
                  Icons.home,
                  "Total Kost",
                  '$totalKost Kost', // ← dari Supabase
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statItem(
                  Icons.bed,
                  "Kamar Tersedia",
                  '$kamarTersedia Kamar', // ← dari Supabase
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _statItem(
                  Icons.calendar_today,
                  "Booking Baru",
                  '$bookingBaru Booking', // ← dari Supabase
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statItem(
                  Icons.attach_money,
                  "Pendapatan",
                  pendapatan, // ← dari Supabase
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}