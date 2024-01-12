import 'package:flutter/material.dart';
import '../../domain/use_case/speed_converter_use_case.dart';

class SpeedScreenViewModel extends ChangeNotifier {
  double speed = 0;
  String fromUnit = "m/s";
  final List<String> units = ["m/s", "m/h", "km/s", "km/h", "mi/s", "mi/h", "ft/s", "ft/h"];

  final List<String> _transResult = [];
  List<String> get transResult => _transResult;

  final TextEditingController speedController = TextEditingController();
  final SpeedConverterUseCase speedConverterUseCase = SpeedConverterUseCase();

  void convertSpeed() {
    _transResult.clear();
    if (speed == 0) {
      _transResult.addAll(units.map((unit) => unit));
    } else {
      for (String toUnit in units) {
        double resultValue = speed;
        resultValue = speedConverterUseCase.convertToMeterPerSecond(resultValue, fromUnit);
        resultValue = speedConverterUseCase.convertFromMeterPerSecond(resultValue, toUnit);
        _transResult.add('${speedConverterUseCase.formatNumber(resultValue)} $toUnit');
      }
    }
  }

  void dispose() {
    speedController.dispose();
    super.dispose();
  }

  void initState() {
    convertSpeed();
    notifyListeners();
  }

  void resetValues() {
    _transResult.clear();
    speedController.clear();
    speed = 0;
    convertSpeed();
    notifyListeners();
  }
}
