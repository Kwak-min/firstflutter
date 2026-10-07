import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class QuestionPage extends StatefulWidget {
  final String? filePath;
  final String? question;
  const QuestionPage({super.key, this.filePath, this.question});

  @override
  State<QuestionPage> createState() {
    return _QuestionPageState();
  }
}

class _QuestionPageState extends State<QuestionPage> {

  Future<String> loadAsset() async {
    String? file = widget.question ?? widget.filePath;
    String path = file != null ? 'res/api/$file.json' : 'res/api/mbti.json';
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question'),
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
                Map<String, dynamic> data = jsonDecode(snapshot.data!);
                List selects = data['selects'] ?? [];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? '',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data['question'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(selects.length, (index) {
                        return Card(
                          child: ListTile(
                            title: Text(selects[index].toString()),
                            onTap: () {
                              List answers = data['answer'] ?? [];
                              if (index < answers.length) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text(answers[index].toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('확인'),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
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
