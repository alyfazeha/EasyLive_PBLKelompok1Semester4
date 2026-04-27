import 'package:flutter/material.dart';
import 'location_picker_view.dart';
import '../../models/kos_model.dart';
import '../../widgets/home/bottom_navbar.dart';

class JasaView extends StatefulWidget {
  const JasaView({super.key});

  @override
  State<JasaView> createState() => _JasaViewState();
}

class _JasaViewState extends State<JasaView> {
  String? selectedFromLocation;
  String? selectedToLocation;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedVehicle = 'Mobil Pick Up';

  final List<String> availableLocations = [
    'Lowokwaru, Malang',
    'Sawojajar, Malang',
    'Blimbing, Malang',
    'Klojen, Malang',
    'Sukun, Malang',
  ];

  void _showLocationPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                isFrom ? 'Pilih Lokasi Jemput' : 'Pilih Lokasi Tujuan',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: availableLocations.length,
                itemBuilder: (context, i) => ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(availableLocations[i]),
                  onTap: () {
                    setState(() {
                      if (isFrom) {
                        selectedFromLocation = availableLocations[i];
                      } else {
                        selectedToLocation = availableLocations[i];
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
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
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              color: Color(0xFF2D3E50),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: RouteCard(
                    fromLocation: selectedFromLocation,
                    toLocation: selectedToLocation,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    onFromTap: () => _showLocationPicker(true),
                    onToTap: () => _showLocationPicker(false),
                    onDateChanged: (date) =>
                        setState(() => selectedDate = date),
                    onTimeChanged: (time) =>
                        setState(() => selectedTime = time),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        const Text(
                          'Choose the car for moving',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF2D3E50),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildVehicleCard(
                          'Mobil Pick Up',
                          'max 100kg',
                          Icons.local_shipping,
                        ),
                        _buildVehicleCard(
                          'Truck',
                          'max 500kg',
                          Icons.delivery_dining,
                        ),
                        const SizedBox(height: 20),
                        _buildNextButton(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: const CircleAvatar(
              backgroundColor: Color(0xFFE0BBE4),
              radius: 25,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Alyfa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Welcome to EasyLive!',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(String name, String cap, IconData icon) {
    bool isSelected = selectedVehicle == name;
    return GestureDetector(
      onTap: () => setState(() => selectedVehicle = name),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F7FA) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? const Color(0xFFFBC02D) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(cap, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Icon(
              icon,
              size: 50,
              color: isSelected ? const Color(0xFF2D3E50) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            final price = selectedVehicle == 'Truck' ? 300000 : 150000;
            final kost = KostModel(
              name: selectedVehicle,
              address: 'Jasa Pindahan',
              image: '',
              price: price,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPickerView(kost: kost),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBC02D),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              color: Color(0xFF2D3E50),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class RouteCard extends StatelessWidget {
  final String? fromLocation;
  final String? toLocation;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const RouteCard({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.selectedDate,
    required this.selectedTime,
    required this.onFromTap,
    required this.onToTap,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationRow(context, 'From', fromLocation, onFromTap),
          const SizedBox(height: 15),
          _buildLocationRow(context, 'To', toLocation, onToTap),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      onDateChanged(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF2D3E50),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3E50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      onTimeChanged(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F7FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Color(0xFF2D3E50),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jam',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3E50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context,
    String label,
    String? location,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              location == null
                  ? Icons.add_location_outlined
                  : Icons.location_on_outlined,
              color: const Color(0xFF2D3E50),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    location ?? 'Pilih lokasi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
