import 'package:biao_chou/model/student.dart';

class CounterState {
  final int counter;

  final List<Student> students;

  CounterState({required this.counter, this.students = const []});

  CounterState copyWith({int? counter, List<Student>? students}) {
    return CounterState(
      counter: counter ?? this.counter,
      students: students ?? this.students,
    );
  }
}