import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:transformation/presenter/weight/weight_screen_view_model.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final WeightScreenViewModel _weightScreenViewModel = WeightScreenViewModel();

  @override
  void dispose() {
    _weightScreenViewModel.weightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _weightScreenViewModel.convertWeight();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('무게 변환'),
      ),
      body: orientation == Orientation.portrait
          ? Column(
        children: [_weightScreenWidget(), Expanded(child: _weightImageWidget())],
      )
          : ListView(
        children: [_weightScreenWidget(), _weightImageWidget()],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.scale_outlined),
            backgroundColor: Colors.white,
            label: '속도',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              context.go('/start/speed');
            },
            shape: const CircleBorder(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.speed_outlined),
            backgroundColor: Colors.white,
            label: '길이',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              context.go('/start');
            },
            shape: const CircleBorder(),
          ),
        ],
      ),
    );
  }

  Widget _weightImageWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
      child: Image.asset(
        'assets/body_back/weight.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _weightScreenWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _weightScreenViewModel.weightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _weightScreenViewModel.weight = double.tryParse(value) ?? 0;
                _weightScreenViewModel.convertWeight();
              });
            },
            decoration: InputDecoration(
              suffixIcon: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: false,
                  value: _weightScreenViewModel.fromUnit,
                  onChanged: (value) {
                    setState(() {
                      _weightScreenViewModel.fromUnit = value!;
                      _weightScreenViewModel.convertWeight();
                    });
                  },
                  items: _weightScreenViewModel.units.map<DropdownMenuItem<String>>((String unit) {
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
            children: [],
          ),
          const Padding(
            padding: EdgeInsets.all(2.0),
          ),
          ..._weightScreenViewModel.transResult.map((result) {
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
                _weightScreenViewModel.resetValues();
                setState(() {});
              },
              child: const Text('초기화', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
