class Workflow {
  final String id;
  final String name;
  final String description;
  final List<String> steps;

  Workflow({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      steps: List<String>.from(json['steps']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'steps': steps,
    };
  }
}
