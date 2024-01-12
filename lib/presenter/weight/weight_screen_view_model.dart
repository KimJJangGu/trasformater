import 'package:flutter/material.dart';
import '../../domain/use_case/weight_converter_use_case.dart';

class WeightScreenViewModel extends ChangeNotifier {
  double weight = 0;
  String fromUnit = "mg";
  final List<String> units = ["mg", "g", "kg", "t", "kt", "gr", "oz", "lb"];

  final List<String> _transResult = [];
  List<String> get transResult => _transResult;

  final TextEditingController weightController = TextEditingController();
  final WeightConverterUseCase weightConverterUseCase = WeightConverterUseCase();

  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  void initState() {
    convertWeight();
    notifyListeners();
  }

  void resetValues() {
    weightController.clear();
    weight = 0;
    _transResult.clear();
    convertWeight();
  }

  void convertWeight() {
    _transResult.clear();
    if (weight == 0) {
      _transResult.addAll(units.map((unit) => unit));
    } else {
      for (String toUnit in units) {
        double resultValue = weight;
        resultValue = weightConverterUseCase.convertToGram(resultValue, fromUnit);
        resultValue = weightConverterUseCase.convertFromGram(resultValue, toUnit);
        _transResult.add('${weightConverterUseCase.formatNumber(resultValue)} $toUnit');
      }
    }
  }
}
