import 'package:intl/intl.dart';

// 단위 변환, 쉼표 및 소수점 기능 구현
class LengthConverterUseCase {
  List<String> convertLength(double value, String fromUnit, List<String> units) {
    List<String> transResult = [];
    for (String toUnit in units) {
      double resultValue = value;
      resultValue = convertToMeter(resultValue, fromUnit);
      resultValue = convertFromMeter(resultValue, toUnit);
      transResult.add('${formatNumber(resultValue)}) $toUnit');
    }

    return transResult;
  }

  // 단위별 환산 값 계산
  double convertToMeter(double value, String unit) {
    switch (unit) {
      case "mm":
        return value / 1000;
      case "cm":
        return value / 100;
      case "m":
        return value;
      case "km":
        return value * 1000;
      case "in":
        return value * 0.0254;
      case "ft":
        return value * 0.3048;
      case "yd":
        return value * 0.9144;
      case "mile":
        return value * 1609.34;
      default:
        return value;
    }
  }

  // 단위별 환산 값 계산
  double convertFromMeter(double value, String unit) {
    switch (unit) {
      case "mm":
        return value * 1000;
      case "cm":
        return value * 100;
      case "m":
        return value;
      case "km":
        return value / 1000;
      case "in":
        return value / 0.0254;
      case "ft":
        return value / 0.3048;
      case "yd":
        return value / 0.9144;
      case "mile":
        return value / 1609.34;
      default:
        return value;
    }
  }

  String formatNumber(double resultNum) {
    return NumberFormat('###,###.##########').format(resultNum);
  }
}
