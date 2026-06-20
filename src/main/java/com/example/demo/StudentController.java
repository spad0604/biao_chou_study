package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import java.util.ArrayList;
import java.util.List;
import com.example.demo.Student;

@RestController
public class StudentController {
    List<Student> students = new ArrayList<>();

    @PostMapping("/api/students")
    public void addStudent(@RequestBody Student student) {
        students.add(student);
    }

    @GetMapping("/api/students")
    public Student getStudent() {
        return new Student(1, "Huang Biao Chou", 16);
    }

    @GetMapping("/api/list_students")
    public List<Student> getStudents() {
        return students;
    }

    @DeleteMapping("/api/students/{id}")
    public void deleteStudent(@PathVariable int id) {
        students.removeIf(student -> student.getId() == id);
    }
}