import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String THE_FOOD_KEY = dotenv.env['THE_FOOD_KEY'] ?? 'no hay pk';
  static String API_URL_BACK = dotenv.env['API_URL_BACK'] ?? 'no hay url';
}
