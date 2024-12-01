import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Execution {
  final String id;
  final String status;
  final DateTime timestamp;

  Execution({required this.id, required this.status, required this.timestamp});
}

class ExecutionListScreen extends StatelessWidget {
  ExecutionListScreen({Key? key}) : super(key: key);

  final List<Execution> executions = List.generate(
    10,
    (index) => Execution(
      id: 'execution_$index',
      status: index % 2 == 0 ? 'Completed' : 'Running',
      timestamp: DateTime.now().subtract(Duration(minutes: index * 5)),
    ),
  );

  Future<List<Execution>> fetchExecutions() async {
    // Mock API call to fetch execution data
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return executions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Execution List'),
      ),
      body: FutureBuilder<List<Execution>>(
        future: fetchExecutions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No executions found'));
          } else {
            final executions = snapshot.data!;
            return ListView.builder(
              itemCount: executions.length,
              itemBuilder: (context, index) {
                final execution = executions[index];

                // Format the timestamp
                final formattedTimestamp =
                    DateFormat('MM/dd/yyyy HH:mm').format(execution.timestamp);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('ID: ${execution.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${execution.status}',
                          style: TextStyle(
                            color: execution.status == 'Running'
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        Text('Timestamp: $formattedTimestamp'),
                      ],
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
