import 'dart:convert';

import 'package:biao_chou/model/student.dart';
import 'package:http/http.dart' as http;

class StudentService {
  Future<List<Student>> getAllStudents() async {
    final url = Uri.parse("http://localhost:8080/api/students");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.body.isNotEmpty
          ? List.from(jsonDecode(response.body))
          : [];
      return jsonList.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }
}
