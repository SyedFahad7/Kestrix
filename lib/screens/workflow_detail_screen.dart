import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkflowDetailScreen extends StatefulWidget {
  final String namespace;
  final String workflowId;

  WorkflowDetailScreen({required this.namespace, required this.workflowId});

  @override
  _WorkflowDetailScreenState createState() => _WorkflowDetailScreenState();
}

class _WorkflowDetailScreenState extends State<WorkflowDetailScreen> {
  late Future<Map<String, dynamic>> workflowDetails;

  @override
  void initState() {
    super.initState();
    workflowDetails = fetchWorkflowDetails();
  }

  // Fetch workflow details from the API
  Future<Map<String, dynamic>> fetchWorkflowDetails() async {
    final url =
        'http://192.168.1.169:8080/api/v1/flows/${widget.namespace}/${widget.workflowId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load workflow details');
    }
  }

  // Update workflow
  Future<void> updateWorkflow() async {
    final url =
        'http://192.168.1.169:8080/api/v1/flows/${widget.namespace}/${widget.workflowId}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to update workflow');
    }
  }

  // Delete workflow
  Future<void> deleteWorkflow() async {
    final url =
        'http://192.168.1.169:8080/api/v1/flows/${widget.namespace}/${widget.workflowId}';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 204) {
      // Successfully deleted,
      Navigator.pop(context);
    } else {
      throw Exception('Failed to delete workflow');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflow Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: workflowDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No details available.'));
          } else {
            final workflow = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Workflow ID: ${workflow['id']}'),
                  SizedBox(height: 8),
                  Text('Name: ${workflow['name']}'),
                  SizedBox(height: 8),
                  Text('Description: ${workflow['description']}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: updateWorkflow,
                    child: const Text('Update Workflow'),
                  ),
                  ElevatedButton(
                    onPressed: deleteWorkflow,
                    child: const Text('Delete Workflow'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
