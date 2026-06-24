class Student {
  final int id;
  final String name;
  final String className;
  final String status;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Unknown student',
      className: json['class_name']?.toString() ?? 'Not assigned',
      status: json['status']?.toString() ?? 'unknown',
    );
  }
}
