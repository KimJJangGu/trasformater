import 'package:intl/intl.dart';

class SpeedConverterUseCase {
  double convertSpeed(double value, String fromUnit, String toUnit) {
    double resultValue = value;

    if (fromUnit == toUnit) {
      // 같은 단위로 변환할 필요가 없습니다.
      return resultValue;
    }

    resultValue = convertToMeterPerSecond(resultValue, fromUnit);
    resultValue = convertFromMeterPerSecond(resultValue, toUnit);

    return resultValue;
  }

  double convertToMeterPerSecond(double value, String fromUnit) {
    switch (fromUnit) {
      case 'm/s':
        return value;
      case 'm/h':
        return value / 3600.0;
      case 'km/s':
        return value * 1000.0;
      case 'km/h':
        return value / 3.6;
      case 'mi/s':
        return value * 1609.34;
      case 'mi/h':
        return value * 0.44704;
      case 'ft/s':
        return value * 0.3048;
      case 'ft/h':
        return value * 0.0000846667;
      default:
        throw ArgumentError('Unsupported unit: $fromUnit');
    }
  }

  double convertFromMeterPerSecond(double value, String toUnit) {
    switch (toUnit) {
      case 'm/s':
        return value;
      case 'm/h':
        return value * 3600.0;
      case 'km/s':
        return value / 1000.0;
      case 'km/h':
        return value * 3.6;
      case 'mi/s':
        return value / 1609.34;
      case 'mi/h':
        return value / 0.44704;
      case 'ft/s':
        return value / 0.3048;
      case 'ft/h':
        return value / 0.0000846667;
      default:
        throw ArgumentError('Unsupported unit: $toUnit');
    }
  }

  String formatNumber(double resultNum) {
    return NumberFormat('###,###.##########').format(resultNum);
  }
}
