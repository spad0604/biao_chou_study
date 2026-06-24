import 'dart:async';

import 'package:biao_chou/counter_event.dart';
import 'package:biao_chou/counter_state.dart';
import 'package:biao_chou/service/student_service.dart';
import 'package:flutter/material.dart';

class CounterBloc {
  final StudentService studentService = StudentService();

  final TextEditingController searchController = TextEditingController();

  CounterState _state = CounterState(counter: 0);

  CounterState get state => _state;

  final StreamController<CounterEvent> _eventController =
      StreamController<CounterEvent>();

  final StreamController<CounterState> _stateController =
      StreamController<CounterState>.broadcast();

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

  Future<void> createStudent(
    String name,
    String className,
    String status,
  ) async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    _stateController.add(_state);

    try {
      final newId = _state.students.isNotEmpty
          ? _state.students.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1
          : 1;
      await studentService.createStudent(newId, name, className, status);
      await getFullStudent();
    } catch (_) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tạo học sinh. Kiểm tra API và cấu hình CORS.',
      );
      _stateController.add(_state);
    }
  }

  Future<void> searchStudents(String query) async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    _stateController.add(_state);

    try {
      final students = await studentService.searchStudents(query);
      _state = _state.copyWith(students: students, isLoading: false);
    } catch (_) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage:
            'Không thể tìm kiếm học sinh. Kiểm tra API và cấu hình CORS.',
      );
    }

    _stateController.add(_state);
  }

  Future<void> getFullStudent() async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    _stateController.add(_state);

    try {
      final students = await studentService.getAllStudents();
      _state = _state.copyWith(students: students, isLoading: false);
    } catch (_) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage:
            'Không thể tải danh sách học sinh. Kiểm tra API và cấu hình CORS.',
      );
    }

    _stateController.add(_state);
  }

  void increment() {
    _state = _state.copyWith(counter: _state.counter + 1);
    _stateController.add(_state);
  }

  Stream<CounterState> get stateStream => _stateController.stream;

  Sink<CounterEvent> get eventSink => _eventController.sink;

  void dispose() {
    searchController.dispose();
    _eventController.close();
    _stateController.close();
  }
}
