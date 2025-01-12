import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  GraphQLService();

  GraphQLClient createClient() {
    const String apiUrl = 'https://api.github.com/graphql';
    const String authToken = 'YOUR_GITHUB_TOKEN'; // Replace with your token

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
