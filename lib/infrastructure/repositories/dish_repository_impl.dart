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
  Future<List<Dish>> syncDishes() async {
    print('[syncDishes] fetching dishes from remote API...');
    final dishes = await remoteDatasource.getDishes();
    print('[syncDishes] got ${dishes.length} dishes from API');
    await localDatasource.saveDishes(dishes);
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
  Future<bool> hasLocalData() {
    return localDatasource.hasData();
  }
}
