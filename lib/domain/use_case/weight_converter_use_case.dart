import 'package:intl/intl.dart';

class WeightConverterUseCase {
  double convertToGram(double value, String fromUnit) {
    switch (fromUnit) {
      case 'mg':
        return value / 1000.0;
      case 'g':
        return value;
      case 'kg':
        return value * 1000.0;
      case 't':
        return value * 1000000.0;
      case 'kt':
        return value * 1000000000.0;
      case 'gr':
        return value * 0.06479891;
      case 'oz':
        return value * 28.3495;
      case 'lb':
        return value * 453.592;
      default:
        return value;
    }
  }

  double convertFromGram(double value, String toUnit) {
    switch (toUnit) {
      case 'mg':
        return value * 1000.0;
      case 'g':
        return value;
      case 'kg':
        return value / 1000.0;
      case 't':
        return value / 1000000.0;
      case 'kt':
        return value / 1000000000.0;
      case 'gr':
        return value / 0.06479891;
      case 'oz':
        return value / 28.3495;
      case 'lb':
        return value / 453.592;
      default:
        return value;
    }
  }

  String formatNumber(double resultNum) {
    return NumberFormat('###,###.##########').format(resultNum);
  }
}
