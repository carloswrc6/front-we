import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/infrastructure/services/local_db_service.dart';
import 'package:frontwe/domain/entities/country.dart';

class DishLocalDatasource {
  final LocalDbService _db = LocalDbService.instance;

  Future<void> saveDishes(List<Dish> dishes) async {
    print('[saveDishes] saving ${dishes.length} dishes to SQLite...');
    final now = DateTime.now().toIso8601String();
    final dishRows = dishes.map(
      (d) => {
        'id': d.id,
        'name': d.name,
        'image': d.image,
        'meal_type': d.mealType,
        'country_id': d.country.id,
        'country_code': d.country.code,
        'country_name': d.country.name,
        'ingredients': d.ingredients.join('||'),
        'synced_at': now,
      },
    );

    final countryMap = <String, Country>{};
    for (final d in dishes) {
      countryMap[d.country.id] = d.country;
    }
    final countryRows = countryMap.values.map(
      (c) => {'id': c.id, 'code': c.code, 'name': c.name},
    );

    await _db.clearDishes();
    await _db.clearCountries();
    await _db.insertDishes(dishRows.toList());
    await _db.insertCountries(countryRows.toList());
    print(
      '[saveDishes] inserted ${dishes.length} dishes and ${countryRows.length} countries',
    );
  }

  Future<List<Dish>> getDishes() async {
    final rows = await _db.getAllDishes();
    return rows.map((r) {
      return Dish(
        id: r['id'] as String,
        name: r['name'] as String,
        image: r['image'] as String,
        mealType: r['meal_type'] as String,
        ingredients: (r['ingredients'] as String).split('||'),
        country: Country(
          id: r['country_id'] as String,
          code: r['country_code'] as String,
          name: r['country_name'] as String,
        ),
      );
    }).toList();
  }

  Future<List<Country>> getCountries() async {
    final rows = await _db.getAllCountries();
    return rows
        .map(
          (r) => Country(
            id: r['id'] as String,
            code: r['code'] as String,
            name: r['name'] as String,
          ),
        )
        .toList();
  }

  Future<bool> hasData() async {
    final count = await _db.dishCount();
    print('[hasData] dish count in SQLite: $count');
    return count > 0;
  }

  Future<bool> hasCountryData() async {
    final count = await _db.countryCount();
    return count > 0;
  }
}
