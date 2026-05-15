import '../../../models/admin/kos_model.dart';

class ApprovalController {
  List<ApprovalModel> getApprovalRequests() {
    return [
      ApprovalModel(
        id: '1',
        name: 'Budi Santoso',
        propertyName: 'Comfort Living Kost',
        submittedDate: '10 May 2025',
        status: 'Pending',
        imageUrl:
            'https://i.pravatar.cc/150?img=3',
      ),
      ApprovalModel(
        id: '2',
        name: 'Siti Aisyah',
        propertyName: 'Comfort Living Kost',
        submittedDate: '10 May 2025',
        status: 'Pending',
        imageUrl:
            'https://i.pravatar.cc/150?img=5',
      ),
    ];
  }
}