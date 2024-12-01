import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workflow.dart';
import '../models/execution.dart';

class KestraService {
  final String baseUrl = 'http://192.168.1.169:8080/api';

  Future<List<Workflow>> fetchWorkflows() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/v1/flows'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((item) => Workflow.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load workflows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching workflows: $e');
    }
  }

  // Fetch details for a single workflow from the Kestra API
  Future<Workflow> fetchWorkflowDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/v1/flows/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Workflow.fromJson(data);
      } else {
        throw Exception(
            'Failed to load workflow details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching workflow details: $e');
    }
  }

  // Trigger a specific workflow using the Kestra API
  Future<void> triggerWorkflow(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v1/executions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'flowId': id,
        }),
      );

      if (response.statusCode == 200) {
        print('Workflow $id triggered successfully');
      } else {
        throw Exception('Failed to trigger workflow: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error triggering workflow: $e');
    }
  }

  // Fetch executions of a specific workflow
  Future<List<Execution>> fetchExecutions(String workflowId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/v1/flows/$workflowId/executions'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((item) => Execution.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load executions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching executions: $e');
    }
  }
}
