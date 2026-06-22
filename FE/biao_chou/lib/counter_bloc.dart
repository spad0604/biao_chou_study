import 'dart:async';

import 'package:biao_chou/counter_event.dart';
import 'package:biao_chou/counter_state.dart';
import 'package:biao_chou/service/student_service.dart';

class CounterBloc {
  final StudentService studentService = StudentService();
  
  CounterState _state = CounterState(counter: 0);

  CounterState get state => _state;

  final StreamController<CounterEvent> _eventController =
      StreamController<CounterEvent>();

  final StreamController<CounterState> _stateController =
      StreamController<CounterState>();

  CounterBloc() {
    _eventController.stream.listen((event) {
      if (event is IncrementEvent) {
        increment();
      }
      if (event is GetFullStudentEvent) {
        getFullStudent();
      }
    });
  }

  Future<void> getFullStudent() async {
    // Implement the logic to fetch full student data here
    // For example, you can call a service method to get the data
    // and then update the state with the new student list.
    final students = await studentService.getAllStudents();
    _state = _state.copyWith(students: students);
    _stateController.add(_state);
  }

  void increment() {
    _state = _state.copyWith(counter: _state.counter + 1);
    _stateController.add(_state);
  }

  Stream<CounterState> get stateStream => _stateController.stream;

  Sink<CounterEvent> get eventSink => _eventController.sink;

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
