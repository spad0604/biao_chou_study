import 'package:biao_chou/counter_bloc.dart';
import 'package:biao_chou/counter_event.dart';
import 'package:biao_chou/counter_state.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final CounterBloc counterBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<CounterState>(
            stream: counterBloc.stateStream,
            builder: (context, snapshot) {
              final counter = snapshot.data?.counter ?? 0;
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      counterBloc.eventSink.add(IncrementEvent());
                    },
                    child: Text('Press Me'),
                  ),
                  Text('Counter: $counter', style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                    onPressed: () {
                      counterBloc.eventSink.add(GetFullStudentEvent());
                    },
                    child: Text('Get Full Student Data'),
                  ),
                  if (snapshot.data?.students.isNotEmpty ?? false)
                    ...snapshot.data!.students.map(
                      (student) => Text(
                        'Student: ${student.name}, Age: ${student.age}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
