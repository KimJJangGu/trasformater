import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transformation/presenter/length/length_screen_view_model.dart';

class LengthScreen extends StatefulWidget {
  const LengthScreen({super.key});

  @override
  _LengthScreenState createState() {
    return _LengthScreenState();
  }
}

class _LengthScreenState extends State<LengthScreen> {
  final LengthScreenViewModel _lengthScreenViewModel = LengthScreenViewModel();

  @override
  void dispose() {
    _lengthScreenViewModel.lengthController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _lengthScreenViewModel.initState();
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
                  controller: _lengthScreenViewModel.lengthController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _lengthScreenViewModel.length = double.tryParse(value) ?? 0;
                      _lengthScreenViewModel.convertLength();
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: false,
                        value: _lengthScreenViewModel.fromUnit,
                        onChanged: (value) {
                          setState(() {
                            _lengthScreenViewModel.fromUnit = value!;
                            _lengthScreenViewModel.convertLength();
                          });
                        },
                        items: _lengthScreenViewModel.units.map<DropdownMenuItem<String>>((String unit) {
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
                    labelText: '길이 입력',
                    hintText: '길이를 입력하세요',
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
                    children: _lengthScreenViewModel.transResult.map((result) {
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
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          '입력 값 초기화',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.black26,
                      ));
                      _lengthScreenViewModel.resetValues();
                      setState(() {

                      });
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
        elevation: 4,
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 170,
                margin: const EdgeInsets.only(left: 70, right: 70, bottom: 70),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Center(
                          child: Text(
                        '무게',
                        style: TextStyle(fontSize: 20),
                      )),
                      onTap: () {
                        context.go('/start/weight');
                      },
                    ),
                    ListTile(
                      title: const Center(
                          child: Text(
                        '속도',
                        style: TextStyle(fontSize: 20),
                      )),
                      onTap: () {
                        context.go('/start/speed');
                      },
                    ),
                  ],
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
}
