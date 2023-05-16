// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../viewModel/constent.dart';
import '../../viewModel/provider.dart';

// import '../constent.dart';

class Firstcontainer extends StatelessWidget {
  Firstcontainer(this.dataProvider, this.day, {super.key});
  final DataProvider dataProvider;
  late String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(109, 0, 77, 164),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500),
                  ),
                  Consumer<DataProvider>(builder: (context, value, child) {
                    return Text(
                        value.datas == null
                            ? day
                            : value.datas!.current.isDay == 0
                                ? 'Evening'
                                : 'Morning',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 199, 193, 193),
                            fontSize: 20,
                            fontWeight: FontWeight.w600));
                  })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    // color: Colors.amberAccent,
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width / 3.2,
                    child: Row(
                      children: [
                        Consumer<DataProvider>(
                            builder: (context, value, child) {
                          if (value.status == ProviderStatus.completed) {
                            return Text(
                              value.datas == null
                                  ? value.temperature.toString()
                                  : value.datas!.current.tempC.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'o',
                              style:
                                  TextStyle(color: Colors.yellow, fontSize: 25),
                            ),
                          ],
                        ),
                        const Text(
                          'C',
                          style: TextStyle(color: Colors.yellow, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Consumer<DataProvider>(builder: (context, value, child) {
                    if (value.status == ProviderStatus.completed) {
                      return value.datas == null
                          ? const SizedBox()
                          : Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(value
                                  .datas!.current.condition.icon
                                  .toString()));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // SizedBox(
                  //   width: 20,
                  // ),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 28,
                    color: Colors.red,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Consumer<DataProvider>(
                        builder: (context, value, child) {
                      if (value.status == ProviderStatus.completed) {
                        return Text(
                          value.datas == null
                              ? value.nameofLocation
                              : value.datas!.location.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
