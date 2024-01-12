import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('길이 변환'),
      ),
      body: orientation == Orientation.portrait
          ? Column(
              children: [_lengthScreenWidget(), Expanded(child: _lengthImageWidget())],
            )
          : ListView(
              children: [_lengthScreenWidget(), _lengthImageWidget()],
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
            label: '무게',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              context.go('/start/weight');
            },
            shape: const CircleBorder(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.speed_outlined),
            backgroundColor: Colors.white,
            label: '속도',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              context.go('/start/speed');
            },
            shape: const CircleBorder(),
          ),
        ],
      ),
    );
  }

  Widget _lengthImageWidget() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        'assets/body_back/ladder.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _lengthScreenWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
          ..._lengthScreenViewModel.transResult.map((result) {
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
          const Padding(
              padding: EdgeInsets.all(2)),
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
