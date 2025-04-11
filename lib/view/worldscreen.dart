

import 'package:covid19_trackerapp/Model/world_states.dart';
import 'package:covid19_trackerapp/services/states_services.dart';
import 'package:covid19_trackerapp/view/splashscreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class Worldscreen extends StatefulWidget {
  const Worldscreen({super.key});

  @override
  State<Worldscreen> createState() => _WorldscreenState();
}

class _WorldscreenState extends State<Worldscreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorsList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed: () {
            print('search icon pressed');
          }),
        ],
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.red),
        title: const Text(
          'Tracker',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        toolbarHeight: 100.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text(
                'Countries',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: Colors.red),
            ),
            UserAccountsDrawerHeader(
              accountName: ListTile(title: Text('Pakistan')),
              accountEmail: Text('1000 cases'),
            ),
            UserAccountsDrawerHeader(
              accountName: ListTile(title: Text('Afghanistan')),
              accountEmail: Text('1000 cases'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              FutureBuilder<WorldStates>(
                future: stateServices.fetchWorldStatesRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitCircle(
                      color: Colors.white,
                      size: 50,
                      controller: _controller,
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available.'));
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total Cases": double.parse(snapshot.data!.cases!.toString()),
                            "Recovered": double.parse(snapshot.data!.recovered!.toString()),
                            "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                          },
                          chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: const LegendOptions(legendPosition: LegendPosition.left),
                          animationDuration: const Duration(milliseconds: 2000),
                          chartType: ChartType.ring,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .10),
                          child: Card(
                            color: const Color(0xff1aa260),
                            child: Column(
                              children: [
                                ReusableRow(title: 'Total Cases', value: snapshot.data!.cases!.toString()),
                                ReusableRow(title: 'Recovered', value: snapshot.data!.recovered!.toString()),
                                ReusableRow(title: 'Deaths', value: snapshot.data!.deaths!.toString()),
      
                                ReusableRow(title: 'Deaths', value: snapshot.data!.active!.toString()),
                                ReusableRow(title: 'Deaths', value: snapshot.data!.critical!.toString()),
                                ReusableRow(title: 'Deaths', value: snapshot.data!.todayCases.toString()),
                                ReusableRow(title: 'Deaths', value: snapshot.data!.affectedCountries.toString()),
                                ReusableRow(title: 'Deaths', value: snapshot.data!.todayRecovered.toString()),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector( onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OceanList()));
                        },
                          child: Container(

                             height: 50,
                             decoration: BoxDecoration(color: const Color(0xff1aa260), borderRadius: BorderRadius.circular(10)),
                             child: const Center(child: Text('Track Countries')),

                           ),
                        )
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
