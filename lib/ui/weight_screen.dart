import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../use_case/weight_convert_use_case.dart';
import 'length_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final TextEditingController weightController = TextEditingController();
  final WeightConverterUseCase weightConverterUseCase = WeightConverterUseCase();
  final List<String> units = ["mg", "g", "kg", "t", "kt", "gr", "oz", "lb"];

  double weight = 0;
  String fromUnit = "mg";
  final List<String> _transResult = [];

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    convertWeight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('무게 변환'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      weight = double.tryParse(value) ?? 0;
                      convertWeight();
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
                            convertWeight();
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
                    labelText: '무게 입력',
                    hintText: '무게를 입력하세요',
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
                  children: [
                  ],
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
              child: Image.asset(
                'assets/body_back/weight.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 4,
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
                          '속도 변환',
                          style: TextStyle(fontSize: 20),
                        )),
                    onTap: () {
                      context.go('/start/speed');
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

  void resetValues() {
    setState(() {
      weightController.clear();
      weight = 0;
      _transResult.clear();
    });
    convertWeight();
  }
}