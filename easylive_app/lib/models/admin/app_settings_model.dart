class AdminAppSettingsModel {
  final bool darkMode;
  final bool reduceAnimations;

  const AdminAppSettingsModel({
    required this.darkMode,
    required this.reduceAnimations,
  });

  factory AdminAppSettingsModel.initial() {
    return const AdminAppSettingsModel(
      darkMode: false,
      reduceAnimations: false,
    );
  }

  AdminAppSettingsModel copyWith({
    bool? darkMode,
    bool? reduceAnimations,
  }) {
    return AdminAppSettingsModel(
      darkMode: darkMode ?? this.darkMode,
      reduceAnimations: reduceAnimations ?? this.reduceAnimations,
    );
  }
}

