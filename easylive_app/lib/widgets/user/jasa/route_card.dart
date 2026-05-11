import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/color.dart';
import '../../../controllers/user/home_controller.dart';
import '../../../models/user/kos_model.dart';
import 'location_picker_view.dart';

import '../../../widgets/user/home/bottom_navbar.dart';

class UserJasaRouteView extends StatefulWidget {
  final KostModel kost;
  const UserJasaRouteView({super.key, required this.kost});

  @override
  State<UserJasaRouteView> createState() => _UserJasaRouteViewState();
}

class _UserJasaRouteViewState extends State<UserJasaRouteView> {
  String? _fromLocation = 'Lowokwaru, Malang';
  String? _toLocation = 'Sawojajar, Malang';
  DateTime _selectedDate = DateTime.now();

  void _showLocationPicker({
    required String title,
    required ValueChanged<String> onSelected,
  }) {
    final locations = [
      'Lowokwaru, Malang',
      'Sawojajar, Malang',
      'Sukun, Malang',
      'Blimbing, Malang',
      'Klojen, Malang',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                ...locations.map(
                  (location) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.darkBlue,
                    ),
                    title: Text(
                      location,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      onSelected(location);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _continueBooking() {
    Navigator.pushNamed(
      context,
      '/personal_info',
      arguments: {
        'kost': widget.kost,
        'isJasa': true,
        'fromLocation': _fromLocation,
        'toLocation': _toLocation,
      },
    );
  }

  void _navigateBottomNav(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/history');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/booking');
    }
  }

  String get _maxLoad {
    final name = widget.kost.name.toLowerCase();
    if (name.contains('truck')) return 'max: 500kg';
    if (name.contains('van')) return 'max: 300kg';
    return 'max: 100kg';
  }

  @override
  Widget build(BuildContext context) {
    final userName = HomeController.getUserName();

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 225,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
                  decoration: const BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                  ),
                  child: _UserJasaRouteHeader(userName: userName),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Positioned(
              left: 48,
              right: 48,
              top: 90,
              child: UserJasaRouteCard(
                fromLocation: _fromLocation,
                toLocation: _toLocation,
                selectedDate: _selectedDate,
                onLocationIconTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UserJasaLocationPickerView(kost: widget.kost),
                    ),
                  );
                },
                onFromTap: () => _showLocationPicker(
                  title: 'Pilih Lokasi Jemput',
                  onSelected: (value) {
                    setState(() => _fromLocation = value);
                  },
                ),
                onToTap: () => _showLocationPicker(
                  title: 'Pilih Lokasi Tujuan',
                  onSelected: (value) {
                    setState(() => _toLocation = value);
                  },
                ),
                onDateChanged: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
            ),
            Positioned.fill(
              top: 420,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(48, 0, 48, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Choose the car for moving',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SelectedVehicleCard(
                      name: widget.kost.name,
                      maxLoad: _maxLoad,
                      image: widget.kost.image,
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'Please check again before continue to payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Color(0xFF5D6B7A),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 205,
                      height: 59,
                      child: ElevatedButton(
                        onPressed: _continueBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: AppColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadowColor: Colors.black.withOpacity(0.22),
                          elevation: 8,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onTap: _navigateBottomNav,
      ),
    );
  }
}

class _UserJasaRouteHeader extends StatelessWidget {
  final String userName;
  const _UserJasaRouteHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 35),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.darkBlue,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectedVehicleCard extends StatelessWidget {
  final String name;
  final String maxLoad;
  final String image;

  const _SelectedVehicleCard({
    required this.name,
    required this.maxLoad,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkBlue,
                  ),
                ),
                Text(
                  maxLoad,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    color: Color(0xFF6D7480),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 148, child: Image.asset(image, fit: BoxFit.contain)),
        ],
      ),
    );
  }
}

class UserJasaRouteCard extends StatelessWidget {
  final String? fromLocation;
  final String? toLocation;
  final DateTime selectedDate;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onLocationIconTap;
  final ValueChanged<DateTime> onDateChanged;

  const UserJasaRouteCard({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.selectedDate,
    required this.onFromTap,
    required this.onToTap,
    required this.onLocationIconTap,
    required this.onDateChanged,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;
    onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      size: 16,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  Container(height: 35, width: 1, color: Colors.grey[300]),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      size: 16,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: [
                    _buildLocationItem(
                      'From',
                      fromLocation ?? 'Lowokwaru, Malang',
                      onFromTap,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(thickness: 1, color: AppColors.darkBlue),
                    ),
                    _buildLocationItem(
                      'To',
                      toLocation ?? 'Sawojajar, Malang',
                      onToTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onLocationIconTap,
                borderRadius: BorderRadius.circular(18),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Departure',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final date = selectedDate.add(Duration(days: index - 2));
                    final isSelected =
                        date.year == selectedDate.year &&
                        date.month == selectedDate.month &&
                        date.day == selectedDate.day;
                    return GestureDetector(
                      onTap: () => onDateChanged(date),
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD1DDE6)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('E').format(date).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Container(
                height: 40,
                width: 1.5,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),
              InkWell(
                onTap: () => _showDatePicker(context),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM').format(selectedDate).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.amber),
                      ],
                    ),
                    Text(
                      DateFormat('yyyy').format(selectedDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
