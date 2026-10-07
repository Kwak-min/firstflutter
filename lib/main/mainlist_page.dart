import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'Question_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {

  Future<String> loadAsset() async {
    return await rootBundle.loadString('res/api/list.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personality Test'),
      ),
      body: FutureBuilder<String>(
        future: loadAsset(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                Map<String, dynamic> list = jsonDecode(snapshot.data!);
                return ListView.builder(
                  itemCount: list['count'],
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return QuestionPage(
                                question: list['questions'][index]['file'].toString(),
                              );
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        child: Card(
                          child: Center(
                            child: Text(
                              list['questions'][index]['title'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: Text('No Data'),
                );
              }
            default:
              return const Center(
                child: Text('No Data'),
              );
          }
        },
      ),
    );
  }
}
