import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

import '../bottomsheet/custom_expandable_bottomsheet.dart';

/// Extension to add customExpandableBottomSheet functionality to GetX
extension CustomBottomSheetExtension on GetInterface {
  Future<T?>? customExpandableBottomSheet<T>({
    required WidgetBuilder builder,
    double initialChildSize = 1.0,
    double minChildSize = 0.5,
    double maxChildSize = 1.0,
    double borderRadius = 15.0,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    Duration? enterBottomSheetDuration,
    Duration? exitBottomSheetDuration,
  }) {
    return Navigator.of(Get.context!).push(
      CustomExpandableBottomSheetRoute<T>(
        builder: builder,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        borderRadius: borderRadius,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        backgroundColor: backgroundColor,
        elevation: elevation,
        enterBottomSheetDuration: enterBottomSheetDuration ?? const Duration(milliseconds: 250),
        exitBottomSheetDuration: exitBottomSheetDuration ?? const Duration(milliseconds: 200),
      ),
    );
  }
}
