import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  GraphQLService();

  GraphQLClient createClient() {
    const String apiUrl = 'http://192.168.1.6:9090/graphql/';
    const String authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjRhMzY0NDUzLTNmZWItNDI1MC04YjM5LTNmNWRlOWM4YTg2MiJ9.5ZHeh7jJmrsKTfEzgS-8QbKe83O2ke_1iDzLvDYIdlQ'; // Replace with your token

    final HttpLink httpLink = HttpLink(apiUrl);

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $authToken',
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      // cache: GraphQLCache(store: HiveStore()),
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    );
  }
}
