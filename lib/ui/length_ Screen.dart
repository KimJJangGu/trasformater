import 'package:flutter/material.dart';
import 'package:transformation/use_case/length_converter_use_case.dart';

class LengthScreen extends StatefulWidget {
  const LengthScreen({super.key});

  @override
  _LengthScreenState createState() {
    return _LengthScreenState();
  }
}

class _LengthScreenState extends State<LengthScreen> {
  final TextEditingController lengthController = TextEditingController();
  final LengthConverterUseCase lengthConverterUseCase = LengthConverterUseCase();
  final List<String> units = ["mm", "cm", "m", "km", "in", "ft", "yd", "mile"];

  double length = 0;
  String fromUnit = "mm";
  final List<String> _transResult = [];

  @override
  void dispose() {
    lengthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    convertLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('길이 변환'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: lengthController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      length = double.tryParse(value) ?? 0;
                      convertLength();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '길이 입력',
                    hintText: '길이를 입력하세요',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                const Padding(
                  padding: EdgeInsets.all(0.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: DropdownButton<String>(
                          isExpanded: false,
                          value: fromUnit,
                          onChanged: (value) {
                            setState(() {
                              fromUnit = value!;
                              convertLength();
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
                    ),
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
                      // backgroundColor: Colors.black,
                      foregroundColor: Colors.black,
                      elevation: 4,
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
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/body_back/ladder.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Column(
                  children: units.map((String unit) {
                    return ListTile(
                      title: Text(unit),
                      onTap: () {
                        setState(() {
                          fromUnit = unit;
                          convertLength();
                          Navigator.pop(context);
                        });
                      },
                    );
                  }).toList(),
                ),
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

  void convertLength() {
    _transResult.clear();
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
  }

  void resetValues() {
    setState(() {
      lengthController.clear();
      length = 0;
      _transResult.clear();
    });
    convertLength();
  }
}
