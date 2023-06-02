import 'package:app_personas/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:pie_chart/pie_chart.dart';

class HobbiesStatistics extends StatefulWidget {
  const HobbiesStatistics({Key? key}) : super(key: key);

  @override
  _HobbiesStatisticsState createState() => _HobbiesStatisticsState();
}

class _HobbiesStatisticsState extends State<HobbiesStatistics> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late SqliteService query;
  final colorList = <Color>[
    Colors.greenAccent,
  ];

  final dataMap = <String, double>{
    "Flutter": 5,
  };

  @override
  void initState() {
    super.initState();
    query = SqliteService();
    query.initDb().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(94, 114, 228, 1.0),
        elevation: 0.0,
        title: const Text('Hobbies '),
      ),
      body: Column(children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "HYBRID",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                )))
      ]),
    );
  }
}
