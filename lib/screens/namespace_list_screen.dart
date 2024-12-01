import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kestra_flow/constants/app_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workflow_list_screen.dart';
import 'select_avatar_screen.dart';

class NamespaceListScreen extends StatefulWidget {
  @override
  _NamespaceListScreenState createState() => _NamespaceListScreenState();
}

class _NamespaceListScreenState extends State<NamespaceListScreen> {
  late Future<List<String>> namespaces;
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    namespaces = fetchNamespaces();
    loadSelectedAvatar();
  }

  Future<void> loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar =
          prefs.getString('selectedAvatar') ?? 'assets/images/dummy.png';
    });
  }

  Future<List<String>> fetchNamespaces() async {
    final url = 'http://192.168.1.169:8080/api/v1/flows/distinct-namespaces';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<String> data = List<String>.from(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load namespaces: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue.shade800,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectAvatarScreen(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          selectedAvatar = result;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('selectedAvatar', result);
                      }
                    },
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage(
                          selectedAvatar ?? 'assets/images/dummy.png'),
                    ),
                  ),
                  const Spacer(),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                      child: Text(
                        'Select Namespace',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 46), // Placeholder for alignment
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<String>>(
              future: namespaces,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No namespaces available.'));
                } else {
                  final namespaceList = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: namespaceList.length,
                    itemBuilder: (context, index) {
                      final namespace = namespaceList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            namespace,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkflowListScreen(namespace: namespace),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
