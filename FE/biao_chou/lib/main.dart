import 'dart:async';

import 'package:biao_chou/counter_bloc.dart';
import 'package:biao_chou/counter_state.dart';
import 'package:biao_chou/model/student.dart';
import 'package:flutter/material.dart';

class HeaderUI extends StatelessWidget {
  const HeaderUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, size: 24, color: Colors.black),
          Text(
            'Student List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.search, size: 24, color: Colors.black),
        ],
      ),
    );
  }
}

class CreateStudentPopup extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController classController;
  final TextEditingController statusController;
  final Future<void> Function(String name, String className, String status)
  onCreate;

  const CreateStudentPopup({
    super.key,
    required this.nameController,
    required this.classController,
    required this.statusController,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nhap hoc sinh'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Ten'),
          ),
          TextField(
            controller: classController,
            decoration: const InputDecoration(labelText: 'Lop'),
          ),
          TextField(
            controller: statusController,
            decoration: const InputDecoration(labelText: 'Trang thai'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Huy'),
        ),
        ElevatedButton(
          onPressed: () async {
            await onCreate(
              nameController.text.trim(),
              classController.text.trim(),
              statusController.text.trim(),
            );
          },
          child: const Text('Luu'),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search students...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Class: ${student.className}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: student.status == 'active' ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(student.status, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final CounterBloc counterBloc = CounterBloc();

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    counterBloc.getFullStudent();

    counterBloc.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    counterBloc.searchController.removeListener(_onSearchChanged);
    counterBloc.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 1000), () {
      if (counterBloc.searchController.text.isEmpty) {
        counterBloc.getFullStudent();
      } else {
        counterBloc.searchStudents(counterBloc.searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<CounterState>(
          stream: counterBloc.stateStream,
          initialData: CounterState(counter: 0),
          builder: (context, snapshot) {
            final state = snapshot.data ?? CounterState(counter: 0);

            return Column(
              children: [
                const HeaderUI(),
                const Divider(height: 1, color: Colors.grey),
                SearchBar(controller: counterBloc.searchController),
                Expanded(child: _buildStudentBody(state)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCreateStudentPopup(context),
                      child: const Text('Them hoc sinh'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentBody(CounterState state) {
    if (state.isLoading && state.students.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(state.errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    if (state.students.isEmpty) {
      return const Center(child: Text('No students found'));
    }

    return ListView.builder(
      itemCount: state.students.length,
      itemBuilder: (context, index) {
        final student = state.students[index];
        return StudentItem(student: student);
      },
    );
  }

  Future<void> _showCreateStudentPopup(BuildContext context) async {
    final nameController = TextEditingController();
    final classController = TextEditingController();
    final statusController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final dialogNavigator = Navigator.of(dialogContext);

        return CreateStudentPopup(
          nameController: nameController,
          classController: classController,
          statusController: statusController,
          onCreate: (name, className, status) async {
            if (name.isEmpty || className.isEmpty || status.isEmpty) {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Vui long nhap day du ten, lop va trang thai'),
                ),
              );
              return;
            }

            try {
              await counterBloc.createStudent(name, className, status);
              if (!mounted) {
                return;
              }
              dialogNavigator.pop();
              scaffoldMessenger.showSnackBar(
                const SnackBar(content: Text('Them hoc sinh thanh cong')),
              );
            } catch (_) {
              if (!mounted) {
                return;
              }
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Khong the them hoc sinh. Kiem tra API va cau hinh CORS.',
                  ),
                ),
              );
            }
          },
        );
      },
    );

    nameController.dispose();
    classController.dispose();
    statusController.dispose();
  }
}
