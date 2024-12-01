class Execution {
  final String id;
  final String status;
  final String timestamp;

  Execution({
    required this.id,
    required this.status,
    required this.timestamp,
  });

  factory Execution.fromJson(Map<String, dynamic> json) {
    return Execution(
      id: json['id'],
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
