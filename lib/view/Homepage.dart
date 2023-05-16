// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';
import 'package:weather_app/viewModel/provider.dart';
import 'package:weather_app/view/widgets/first_container.dart';
import 'package:weather_app/view/widgets/tabbar_data.dart';

import '../viewModel/constent.dart';
import 'widgets/chartpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int buttonindex = -1;
String day = 'Morning';

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<DataProvider>().fetchLocation();

      await context
          .read<DataProvider>()
          .fetchWeather(
              Provider.of<DataProvider>(context, listen: false).location?.city)
          .then((value) {
        context.read<DataProvider>().addCurrentWeatherData();
      });
    });
    context.read<DataProvider>().getCurrentWeatherData();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Consumer<DataProvider>(builder: (context, getdata, child) {
        // getdata.fetchQuestion();
        // if (getdata.datas != null) {
        //   if (getdata.isday == 0) {
        //     day = 'Evening';
        //   } else if (getdata.isday == 1) {
        //     day = 'Morning';
        //   }
        // }
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 10, 46, 75),
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: MySearch(data: getdata.searchlist));
                  },
                  icon: Icon(Icons.search))
            ],
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 10, 46, 75),
            leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert_rounded, size: 28)),
            title: Text(
              'Weather App',
              style: TextStyle(fontSize: 25),
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Firstcontainer(getdata, day),
                  ),
                  TabBar(
                    labelColor: Color.fromARGB(255, 187, 184, 6),
                    unselectedLabelColor: Colors.white,
                    indicatorColor: Color.fromARGB(255, 187, 184, 6),
                    tabs: const [
                      Tab(text: "Today"),
                      Tab(text: "Tomorrow"),
                      Tab(text: "Next 7 Day")
                    ],
                  ),
                  // ignore: duplicate_ignore
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4.2,
                    // ignore: prefer_const_constructors
                    child: TabBarView(
                      children: const [
                        TabBarData(),
                        TabBarData(),
                        TabBarData()
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(
                              'WindSpeed',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Spacer(),
                            Consumer<DataProvider>(
                                builder: (context, value, child) {
                              if (value.status == ProviderStatus.completed) {
                                return Text(
                                  value.datas == null
                                      ? '${value.windspeed}Km/h'
                                      : '${value.datas!.current.windKph}Km/h',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 35,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 3.5,
                          // width: 380,
                          // color: Colors.amberAccent,
                          child: Sfchart(chartData: chartData))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  final List<ChartData> chartData = [
    ChartData(2010, 10),
    ChartData(2011, 30),
    ChartData(2012, 20),
    ChartData(2013, 60),
    ChartData(2014, 40)
  ];
}

class MySearch extends SearchDelegate {
  MySearch({data});
  // final getData;
  List<String> dataNames = ['humidity', 'windKph', 'tempC'];
  List<String> data = [];
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              Navigator.pop(context);
              query = '';
            }
          },
        ),
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );
  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dataNames[buttonindex],
              style: TextStyle(
                  fontSize: 50, fontWeight: FontWeight.w600, color: Colors.red),
            ),
            Text(
              context
                  .read<DataProvider>()
                  .searchlist[dataNames.indexOf(query)]
                  .toString(),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
  //flutter search bar with listview
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggesstions = dataNames.where((element) {
      // context.read<DataProvider>().searchlist.where((element) {
      final result = element.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return ListView.builder(
        itemCount: suggesstions.length,
        itemBuilder: (context, index) {
          buttonindex = index;
          final suggestion = suggesstions[buttonindex];
          return ListTile(
            title: Text(suggestion),
            onTap: () {
              buttonindex = index;
              query = suggestion;
              showResults(context);
            },
          );
        });
  }
}
