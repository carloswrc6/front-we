import 'package:frontwe/domain/datasource/dish_datasource.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/domain/repository/dish_repository.dart';
import 'package:frontwe/infrastructure/datasource/dish_local_datasource.dart';

class DishRepositoryImpl extends DishRepository {
  final DishDatasource remoteDatasource;
  final DishLocalDatasource localDatasource;

  DishRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Dish>> getDishes({int offset = 0, int limit = 100}) {
    return remoteDatasource.getDishes(offset: offset, limit: limit);
  }

  @override
  Future<List<Country>> getRemoteCountries() {
    return remoteDatasource.getCountries();
  }

  @override
  Future<List<Dish>> syncDishes() async {
    print('[syncDishes] fetching dishes and countries from API...');
    final results = await Future.wait([
      remoteDatasource.getDishes(limit: 200),
      remoteDatasource.getCountries(),
    ]);
    final dishes = results[0] as List<Dish>;
    final countries = results[1] as List<Country>;
    print(
      '[syncDishes] got ${dishes.length} dishes and ${countries.length} countries from API',
    );
    await localDatasource.saveDishes(dishes);
    await localDatasource.saveCountries(countries);
    print('[syncDishes] saved to local DB');
    return dishes;
  }

  @override
  Future<List<Dish>> getLocalDishes() {
    return localDatasource.getDishes();
  }

  @override
  Future<List<Country>> getLocalCountries() {
    return localDatasource.getCountries();
  }

  @override
  Future<int> getLocalDishCount() {
    return localDatasource.dishCount();
  }

  @override
  Future<bool> hasLocalData() {
    return localDatasource.hasData();
  }

  @override
  Future<Dish> createDish({
    required String name,
    required String image,
    required List<String> ingredients,
    required String mealType,
    required String countryId,
  }) async {
    final dish = await remoteDatasource.createDish(
      name: name,
      image: image,
      ingredients: ingredients,
      mealType: mealType,
      countryId: countryId,
    );
    final userDish = Dish(
      id: dish.id,
      name: dish.name,
      image: dish.image,
      ingredients: dish.ingredients,
      mealType: dish.mealType,
      country: dish.country,
      isUserCreated: true,
    );
    await localDatasource.saveUserCreatedDish(userDish);
    return userDish;
  }

  @override
  Future<void> toggleFavorite(String dishId) {
    return localDatasource.toggleFavorite(dishId);
  }
}
