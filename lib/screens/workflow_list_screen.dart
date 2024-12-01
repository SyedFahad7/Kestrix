import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'workflow_detail_screen.dart';
import 'package:kestra_flow/models/workflow.dart';

class WorkflowListScreen extends StatelessWidget {
  final String namespace;

  // Constructor to accept namespace
  WorkflowListScreen({required this.namespace});

  Future<List<Workflow>> fetchWorkflows() async {
    final url = 'http://192.168.1.169:8080/api/v1/flows/$namespace';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((workflow) {
        String id = workflow['id'] ?? 'No ID provided';
        String name = workflow['id'] ?? 'No name provided';
        String description = 'Tasks: ';

        if (workflow['tasks'] != null && workflow['tasks'] is List) {
          // Extract task messages from 'tasks' list
          description += workflow['tasks']
              .map((task) => task['message'] ?? 'No message')
              .join(', ');
        } else {
          description = 'No tasks available';
        }

        return Workflow(
          id: id, // Set ID from 'id' field
          name: name, // Set name (using 'id' here as name)
          description: description,
          steps: [],
        );
      }).toList();
    } else {
      throw Exception('Failed to load workflows: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflow List'),
      ),
      body: FutureBuilder<List<Workflow>>(
        future: fetchWorkflows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No workflows available.'));
          } else {
            final workflows = snapshot.data!;
            return ListView.builder(
              itemCount: workflows.length,
              itemBuilder: (context, index) {
                final workflow = workflows[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(workflow.name),
                    subtitle: Text(workflow.description),
                    trailing: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkflowDetailScreen(
                              namespace: namespace, workflowId: workflow.id),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
