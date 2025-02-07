import '../../getx.dart';

extension PercentSized on double {
  /// height: 50.0.hp = 50%
  ///
  /// Percent must be between 0 and 100
  double get hp {
    assert(this >= 0 && this <= 100, 'Percent must be between 0 and 100');
    return (Get.height * (this / 100)).roundToDouble();
  }

  /// width: 30.0.wp = 30%
  ///
  /// Percent must be between 0 and 100
  double get wp {
    assert(this >= 0 && this <= 100, 'Percent must be between 0 and 100');
    return (Get.width * (this / 100)).roundToDouble();
  }
}
