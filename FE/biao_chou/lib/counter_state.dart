import 'package:biao_chou/model/student.dart';

class CounterState {
  final int counter;
  final List<Student> students;
  final bool isLoading;
  final String? errorMessage;

  CounterState({
    required this.counter,
    this.students = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CounterState copyWith({
    int? counter,
    List<Student>? students,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
