import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String THE_FOOD_KEY = dotenv.env['THE_FOOD_KEY'] ?? 'no hay pk';
  static String API_URL_BACK = dotenv.env['API_URL_BACK'] ?? 'no hay url';
  static String DISH_IMAGE_BASE_URL =
      'https://raw.githubusercontent.com/carloswrc6/back-we/what_eat/static/dishes/';

  static String resolveImageUrl(String image) {
    if (image.isEmpty || image.startsWith('http')) return image;
    return '$DISH_IMAGE_BASE_URL$image';
  }
}
