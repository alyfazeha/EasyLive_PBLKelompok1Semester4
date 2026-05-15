class ApprovalDetailModel {
  final String ownerName;
  final String ownerRole;
  final String status;
  final String profileImage;
  final String businessName;
  final String phoneNumber;
  final String email;
  final String address;
  final String description;
  final List<String> photos;

  // Alasan penolakan approval (persist dari Supabase)
  final String? rejectionReason;

  ApprovalDetailModel({
    required this.ownerName,
    required this.ownerRole,
    required this.status,
    required this.profileImage,
    required this.businessName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.description,
    required this.photos,
    this.rejectionReason,
  });
}
