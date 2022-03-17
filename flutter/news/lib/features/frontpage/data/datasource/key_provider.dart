import 'package:flutter_dotenv/flutter_dotenv.dart';

class KeyProvider {
  newsApiKey() {
    return dotenv.env['NEWS_API_KEY']!;
  }
}
