// ============================
// approval_view.dart
// ============================

import 'package:flutter/material.dart';

import '../../../controllers/admin/kos_controller.dart';
import '../../../models/admin/kos_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/kos/approval_card.dart';
import '../../../widgets/admin/kos/approval_tab_filter.dart';
import 'detail_approvalKos.dart';

class ApprovalView extends StatefulWidget {
  const ApprovalView({super.key});

  @override
  State<ApprovalView> createState() => _ApprovalViewState();
}

class _ApprovalViewState extends State<ApprovalView> {
  final ApprovalController _controller = ApprovalController();

  final List<String> tabs = ['All', 'Pending', 'Approved', 'Rejected'];

  int selectedTabIndex = 0;
  List<ApprovalModel> allRequests = [];

  @override
  void initState() {
    super.initState();
    allRequests = _controller.getApprovalRequests();
  }

  // Filter data berdasarkan tab yang dipilih
  List<ApprovalModel> get filteredRequests {
    if (selectedTabIndex == 0) {
      return allRequests;
    }

    final selectedStatus = tabs[selectedTabIndex];

    return allRequests.where((request) {
      return request.status.toLowerCase() ==
          selectedStatus.toLowerCase();
    }).toList();
  }

  // Update status menjadi Approved
  void _onApprove(ApprovalModel request) {
    setState(() {
      allRequests = allRequests.map((r) {
        if (r.id == request.id) {
          return ApprovalModel(
            id: r.id,
            name: r.name,
            propertyName: r.propertyName,
            submittedDate: r.submittedDate,
            status: 'Approved',
            imageUrl: r.imageUrl,
          );
        }
        return r;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${request.name} approved')),
    );
  }

  // Update status menjadi Rejected
  void _onReject(ApprovalModel request) {
    setState(() {
      allRequests = allRequests.map((r) {
        if (r.id == request.id) {
          return ApprovalModel(
            id: r.id,
            name: r.name,
            propertyName: r.propertyName,
            submittedDate: r.submittedDate,
            status: 'Rejected',
            imageUrl: r.imageUrl,
          );
        }
        return r;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${request.name} rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF243B55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6BE00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Color(0xFF243447),
                        ),
                      ),
                    ),
                    const Text(
                      'Kost Approvals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 28,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '9',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tab Filter
                ApprovalTabFilter(
                  tabs: tabs,
                  selectedIndex: selectedTabIndex,
                  onTap: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(
                    child: Text(
                      'No approval requests found.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'Kost Owner Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List Card Approval
                      ...filteredRequests.map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: ApprovalCard(
                            approval: request,

                            // Sembunyikan tombol Approve & Reject
                            showActionButtons: false,

                            // Callback tetap wajib diisi
                            onApprove: () {},
                            onReject: () {},

                            // Klik card membuka detail
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ApprovalDetailView(
                                    approval: request,
                                  ),
                                ),
                              );

                              // Jika status berubah dari halaman detail
                              if (result == 'approved') {
                                _onApprove(request);
                              } else if (result == 'rejected') {
                                _onReject(request);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),

      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/admin/history');
            return;
          }
          // Kos Approval (index 1)
          if (index == 1) {
            Navigator.pushNamed(context, '/admin/kos_approval');
            return;
          }
          // Dashboard (index 2)
          if (index == 2) {
            Navigator.pushNamed(context, '/admin/home');
            return;
          }
        },
      ),
    );
  }
}
