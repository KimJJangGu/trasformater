import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../use_case/speed_convert_use_case.dart';

class SpeedScreen extends StatefulWidget {
  const SpeedScreen({Key? key}) : super(key: key);

  @override
  _SpeedScreenState createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  final TextEditingController speedController = TextEditingController();
  final SpeedConverterUseCase speedConverterUseCase = SpeedConverterUseCase();
  final List<String> units = ["m/s", "m/h", "km/s", "km/h", "mi/s", "mi/h", "ft/s", "ft/h"];

  double speed = 0;
  String fromUnit = "m/s";
  final List<String> _transResult = [];

  @override
  void dispose() {
    speedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    convertSpeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('속도 변환'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: speedController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      speed = double.tryParse(value) ?? 0;
                      convertSpeed();
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: false,
                        value: fromUnit,
                        onChanged: (value) {
                          setState(() {
                            fromUnit = value!;
                            convertSpeed();
                          });
                        },
                        items: units.map<DropdownMenuItem<String>>((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(
                              unit,
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    labelText: '속도 입력',
                    hintText: '속도를 입력하세요',
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(0.0),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 230,
                  child: ListView(
                    children: _transResult.map((result) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            (result),
                            style: const TextStyle(fontSize: 16),
                            maxLines: 1,
                          ),
                          const Divider(height: 4, color: Colors.black12),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(95, 30),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          '입력 값 초기화',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.black26,
                      ));
                      resetValues();
                    },
                    child: const Text('초기화', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(
                'assets/body_back/speed.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext context) {
              return Column(
                children: [
                  ListTile(
                    title: const Center(
                        child: Text(
                      '길이 변환',
                      style: TextStyle(fontSize: 20),
                    )),
                    onTap: () {
                      context.go('/start');
                    },
                  ),
                  ListTile(
                    title: const Center(
                        child: Text(
                      '무게 변환',
                      style: TextStyle(fontSize: 20),
                    )),
                    onTap: () {
                      context.go('/start/weight');
                    },
                  ),
                ],
              );
            },
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.autorenew_rounded),
      ),
    );
  }

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

  void resetValues() {
    setState(() {
      speedController.clear();
      speed = 0;
      _transResult.clear();
    });
    convertSpeed();
  }
}
