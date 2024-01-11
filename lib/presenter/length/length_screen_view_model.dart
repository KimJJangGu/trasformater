import 'package:flutter/material.dart';
import '../../domain/use_case/length_converter_use_case.dart';

class LengthScreenViewModel extends ChangeNotifier {
  double length = 0;
  String fromUnit = "mm";
  final List<String> units = ["mm", "cm", "m", "km", "in", "ft", "yd", "mile"];

  final List<String> _transResult = [];
  List<String> get transResult => _transResult;

  final TextEditingController lengthController = TextEditingController();
  final LengthConverterUseCase lengthConverterUseCase = LengthConverterUseCase();

  void dispose() {
    lengthController.dispose();
    super.dispose();
  }

  void initState() {
    convertLength();
    notifyListeners();
  }

  void resetValues() {
    _transResult.clear();
    lengthController.clear();
    length = 0;
    convertLength();
    notifyListeners();
  }


  void convertLength() {
    _transResult.clear();
    // 숫자를 입력하지 않았을 때에는 단위만 표시
    if (length == 0) {
      _transResult.addAll(units.map((unit) => unit));
    } else {
      for (String toUnit in units) {
        double resultValue = length;
        resultValue = lengthConverterUseCase.convertToMeter(resultValue, fromUnit);
        resultValue = lengthConverterUseCase.convertFromMeter(resultValue, toUnit);
        _transResult.add('${lengthConverterUseCase.formatNumber(resultValue)} $toUnit');
      }
    }
    notifyListeners();
  }
}