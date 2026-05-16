import 'package:flutter/foundation.dart';

import '../../../models/admin/help_support_model.dart';

class AdminHelpSupportController extends ChangeNotifier {
  AdminHelpSupportModel _model = AdminHelpSupportModel.initial();

  AdminHelpSupportModel get model => _model;
}

