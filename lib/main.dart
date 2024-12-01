import 'package:flutter/material.dart';
import 'package:kestra_flow/screens/execution_list_screen.dart';
import 'package:kestra_flow/screens/workflow_detail_screen.dart';
import 'package:kestra_flow/screens/workflow_list_screen.dart';
import 'package:kestra_flow/screens/namespace_list_screen.dart';

void main() {
  runApp(const KestraFlowApp());
}

class KestraFlowApp extends StatelessWidget {
  const KestraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kestra Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => NamespaceListScreen(),
        '/workflow-list': (context) => WorkflowListScreen(namespace: ''),
        '/workflow-detail': (context) => WorkflowDetailScreen(
              workflowId: '',
              namespace: '',
            ),
        '/execution-list': (context) => ExecutionListScreen(),
      },
    );
  }
}
