import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:lilac_flutter_assignment/modeclasslocation.dart';

import 'constent.dart';

import 'package:http/http.dart' as http;

import '../model/model.dart';

class DataProvider with ChangeNotifier {
  WeatherModel? datas;
  Location? location; //
  late int humidity;
  late double windspeed;
  late String nameofLocation;
  late double temperature;
  late String icon;
  late int isday;
  late List searchlist = [];
  // late Location datas2;
  ProviderStatus status = ProviderStatus.loading;
  late final Box box = Hive.box('currentWeatherData');

  Future<void> fetchWeather(String? location) async {
    final response = await http.post(
      Uri.parse(
          'http://api.weatherapi.com/v1/current.json?key=c0dbb6f1794640eeabf103014222805&q=Ernakulam&aqi=no'),
      body: <String, String>{
        'key': 'c0dbb6f1794640eeabf103014222805',
        'q': location!
      },
    );
    // print(response.body);
    print("response 100");
    if (response.statusCode == 200) {
      // print(response.body);
      datas = WeatherModelFromJson(response.body);
      print(datas);
      searchlist = [
        datas?.current.humidity,
        datas?.current.windKph,
        datas?.current.tempC
      ];
      print(searchlist);
      status = ProviderStatus.completed;
      notifyListeners();
    } else {
      // print('object');
      throw Exception('faild');
    }

    notifyListeners();
  }

  Future<void> fetchLocation() async {
    final responseofipaddress = await http.get(
      Uri.parse('https://api.ipify.org?format=json'),
    );
    Map ipadress = jsonDecode(responseofipaddress.body);
    String currentlocation = ipadress['ip'];
    // print(currentlocation);
    final responseoflocation =
        await http.get(Uri.parse('https://ipinfo.io/${currentlocation}/geo'));
    print(responseoflocation.body);
    // print(responseoflocation.body);
    location = locationFromJson(responseoflocation.body);
    // print(location!.city);
  }
  //HIVE LOCAL STORAGE CODE BELOW

//TO Add Data
  addCurrentWeatherData() async {
    await box.put('humidity', datas!.current.humidity).then((value) {
      // print('adding succesful');
    });
    await box.put('windKph', datas!.current.windKph).then((value) {
      // print('adding succesful');
    });
    await box.put('tempC', datas!.current.tempC).then((value) {
      // print('adding succesful');
    });
    await box.put('is_day', datas!.current.isDay).then((value) {
      // print('adding succesful');
    });
    await box.put('name', datas!.location.name).then((value) {
      // print('adding succesful');
    });
    await box.put('icon', datas!.current.condition.icon).then((value) {
      // print('adding succesful');
    });
  }

//To Get Data

  getCurrentWeatherData() async {
    humidity = await box.get('humidity');
    windspeed = await box.get('windKph');
    temperature = await box.get('tempC');
    icon = 'http:' + await box.get('icon');
    isday = await box.get('is_day');
    nameofLocation = await box.get('name');
    // for (int a = 0; a < 6;a++){
    searchlist = [
      humidity.toString(),
      windspeed.toString(),
      temperature.toString(),
    ];
    print(searchlist);

    // }

    status = ProviderStatus.completed;

    notifyListeners();
    // print(humidity);
  }
}

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    required this.ip,
    required this.hostname,
    required this.city,
    required this.region,
    required this.country,
    required this.loc,
    required this.org,
    required this.postal,
    required this.timezone,
    required this.readme,
  });

  String? ip;
  String? hostname;
  String? city;
  String? region;
  String? country;
  String? loc;
  String? org;
  String? postal;
  String? timezone;
  String? readme;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        ip: json["ip"],
        hostname: json["hostname"],
        city: json["city"],
        region: json["region"],
        country: json["country"],
        loc: json["loc"],
        org: json["org"],
        postal: json["postal"],
        timezone: json["timezone"],
        readme: json["readme"],
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "hostname": hostname,
        "city": city,
        "region": region,
        "country": country,
        "loc": loc,
        "org": org,
        "postal": postal,
        "timezone": timezone,
        "readme": readme,
      };
}
