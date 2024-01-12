import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:transformation/presenter/speed/speed_screen_view_model.dart';

class SpeedScreen extends StatefulWidget {
  const SpeedScreen({Key? key}) : super(key: key);

  @override
  _SpeedScreenState createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  final SpeedScreenViewModel _speedScreenViewModel = SpeedScreenViewModel();

  @override
  void dispose() {
    _speedScreenViewModel.speedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _speedScreenViewModel.convertSpeed();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('속도 변환'),
      ),
      body: orientation == Orientation.portrait
          ? Column(
        children: [_speedScreenWidget(), Expanded(child: _speedImageWidget())],
      )
          : ListView(
        children: [_speedScreenWidget(), _speedImageWidget()],
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

  Widget _speedImageWidget() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Image.asset(
        'assets/body_back/speed.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _speedScreenWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            controller: _speedScreenViewModel.speedController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _speedScreenViewModel.speed = double.tryParse(value) ?? 0;
                _speedScreenViewModel.convertSpeed();
              });
            },
            decoration: InputDecoration(
              suffixIcon: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: false,
                  value: _speedScreenViewModel.fromUnit,
                  onChanged: (value) {
                    setState(() {
                      _speedScreenViewModel.fromUnit = value!;
                      _speedScreenViewModel.convertSpeed();
                    });
                  },
                  items: _speedScreenViewModel.units.map<DropdownMenuItem<String>>((String unit) {
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
          ..._speedScreenViewModel.transResult.map((result) {
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
                _speedScreenViewModel.resetValues();
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
