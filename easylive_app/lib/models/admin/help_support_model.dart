class AdminHelpSupportModel {
  final String contactEmail;
  final String contactPhone;

  const AdminHelpSupportModel({
    required this.contactEmail,
    required this.contactPhone,
  });

  factory AdminHelpSupportModel.initial() {
    return const AdminHelpSupportModel(
      contactEmail: 'support@easyjasa.com',
      contactPhone: '0812-0000-0000',
    );
  }
}

