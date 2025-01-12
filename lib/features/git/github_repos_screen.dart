import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:template/core/graphql/graphql_client.dart';
import 'package:template/core/log/app_log.dart';

// To parse this JSON data, do
//
//     final resModel = resModelFromJson(jsonString);

import 'dart:convert';

List<ResModel> resModelFromJson(String str) =>
    List<ResModel>.from(json.decode(str).map((x) => ResModel.fromJson(x)));

class ResModel {
  ResModel({
    this.typename,
    this.denomination,
    this.id,
  });

  factory ResModel.fromJson(Map<String, dynamic> json) => ResModel(
        typename: json['__typename'],
        denomination: json['denomination'],
        id: json['id'],
      );
  String? typename;
  String? denomination;
  int? id;
}

class GitHubReposScreen extends StatefulWidget {
  const GitHubReposScreen({super.key});

  @override
  State<GitHubReposScreen> createState() => _GitHubReposScreenState();
}

class _GitHubReposScreenState extends State<GitHubReposScreen> {
  // late GraphQLClient client;

  @override
  void initState() {
    super.initState();
    // client = GraphQLService().createClient();
  }

  Future<List<Map<String, dynamic>>> fetchRepositories() async {
    try {
      final client = GraphQLService().createClient();

      const String query = r'''
    query MyQuery {
  countries {
    denomination
    id
  }
}
''';

      final QueryOptions options = QueryOptions(
        document: gql(query),
        // pollInterval: const Duration(seconds: 10),
      );

      final result = await client.query(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final repositories = result.data?['countries'] as List<dynamic>;

      return repositories.map((repo) => repo as Map<String, dynamic>).toList();
    } catch (e) {
      AppLog.error('e: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Repositories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRepositories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final repos = snapshot.data;

          if (repos == null || repos.isEmpty) {
            return const Center(child: Text('No repositories found.'));
          }

          return ListView.builder(
            itemCount: repos.length,
            itemBuilder: (context, index) {
              final repo = repos[index];
              return ListTile(
                title: Text(repo['denomination'].toString()),
                leading: Text(repo['id'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
