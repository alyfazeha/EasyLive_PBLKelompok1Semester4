import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/color.dart';
import '../../User/profile/edit_profile_view.dart';

///
/// Untuk sementara: UI edit profile pemilikKos disamakan dengan view user.
/// Nanti bisa diganti jadi form khusus pemilikKos.
///
class PemilikKosEditProfileView extends StatefulWidget {
  const PemilikKosEditProfileView({super.key});

  @override
  State<PemilikKosEditProfileView> createState() =>
      _PemilikKosEditProfileViewState();
}

class _PemilikKosEditProfileViewState extends State<PemilikKosEditProfileView> {
  @override
  Widget build(BuildContext context) {
    return EditProfileView();
  }
}
