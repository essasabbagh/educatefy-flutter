import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:template/core/graphql/graphql_client.dart';

class GitHubReposScreen extends StatefulWidget {
  const GitHubReposScreen({super.key});

  @override
  State<GitHubReposScreen> createState() => _GitHubReposScreenState();
}

class _GitHubReposScreenState extends State<GitHubReposScreen> {
  late GraphQLClient client;

  @override
  void initState() {
    super.initState();
    client = GraphQLService().createClient();
  }

  Future<List<Map<String, dynamic>>> fetchRepositories() async {
    const String query = r'''
      query {
        viewer {
          repositories(first: 10, orderBy: {field: UPDATED_AT, direction: DESC}) {
            nodes {
              name
              description
              updatedAt
            }
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(document: gql(query));
    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final repositories =
        result.data?['viewer']['repositories']['nodes'] as List<dynamic>;
    return repositories.map((repo) => repo as Map<String, dynamic>).toList();
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
                title: Text(repo['name']),
                subtitle: Text(repo['description'] ?? 'No description'),
                trailing: Text(repo['updatedAt']),
              );
            },
          );
        },
      ),
    );
  }
}
