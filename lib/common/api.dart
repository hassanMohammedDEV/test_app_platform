import 'package:app_platform_network/network.dart';
import 'package:http/http.dart' as http;

class AppTokenProvider implements TokenProvider {
  @override
  Future<String?> getToken() async {
    return null; // لاحقًا: token من storage
  }
}

final apiClient = HttpApiClient(
  baseUrl: 'https://dummyjson.com',
  client: http.Client(),
  timeout: Duration(milliseconds: 1500),
  tokenProvider: AppTokenProvider(),
);
