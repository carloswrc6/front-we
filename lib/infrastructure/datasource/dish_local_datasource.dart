import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/infrastructure/services/local_db_service.dart';
import 'package:frontwe/domain/entities/country.dart';

class DishLocalDatasource {
  final LocalDbService _db = LocalDbService.instance;

  Map<String, dynamic> _dishToRow(Dish d, String now, {required bool isUserCreated}) => {
    'id': d.id,
    'name': d.name,
    'image': d.image,
    'meal_type': d.mealType,
    'country_id': d.country.id,
    'country_code': d.country.code,
    'country_name': d.country.name,
    'ingredients': d.ingredients.join('||'),
    'synced_at': now,
    'is_user_created': isUserCreated ? 1 : 0,
  };

  Future<void> saveDishes(List<Dish> dishes) async {
    print('[saveDishes] saving ${dishes.length} dishes to SQLite...');

    final existing = await getDishes();
    final userCreated = existing.where((d) => d.isUserCreated).toList();

    final now = DateTime.now().toIso8601String();
    final dishRows = dishes.map(
      (d) => _dishToRow(d, now, isUserCreated: false),
    ).toList();

    for (final d in userCreated) {
      dishRows.add(_dishToRow(d, now, isUserCreated: true));
    }

    await _db.clearDishes();
    await _db.insertDishes(dishRows);
    print('[saveDishes] inserted ${dishRows.length} dishes (${userCreated.length} user-created preserved)');
  }

  Future<void> saveUserCreatedDish(Dish dish) async {
    print('[saveUserCreatedDish] saving dish ${dish.id} to SQLite...');
    final now = DateTime.now().toIso8601String();
    final row = _dishToRow(dish, now, isUserCreated: true);
    await _db.insertDish(row);
    print('[saveUserCreatedDish] saved');
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
        isUserCreated: (r['is_user_created'] as int?) == 1,
      );
    }).toList();
  }

  Future<void> saveCountries(List<Country> countries) async {
    print('[saveCountries] saving ${countries.length} countries to SQLite...');
    final rows = countries
        .map((c) => {'id': c.id, 'code': c.code, 'name': c.name})
        .toList();
    await _db.clearCountries();
    await _db.insertCountries(rows);
    print('[saveCountries] inserted ${countries.length} countries');
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

  Future<int> dishCount() async {
    return _db.dishCount();
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
