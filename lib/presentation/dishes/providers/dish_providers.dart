import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/repository/dish_repository.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/infrastructure/datasource/http_client_provider.dart';
import 'package:frontwe/infrastructure/datasource/dish_db_datasource.dart';
import 'package:frontwe/infrastructure/datasource/dish_local_datasource.dart';
import 'package:frontwe/infrastructure/repositories/dish_repository_impl.dart';

final dishRepositoryProvider = Provider<DishRepository>((ref) {
  final dio = ref.watch(httpClientProvider);
  return DishRepositoryImpl(
    remoteDatasource: DishDbDatasource(dio: dio),
    localDatasource: DishLocalDatasource(),
  );
});

final dishSyncProvider = FutureProvider.autoDispose<void>((ref) async {
  final repository = ref.watch(dishRepositoryProvider);
  await repository.syncDishes();
});

final localDishesProvider = FutureProvider.autoDispose<List<Dish>>((ref) async {
  final repository = ref.watch(dishRepositoryProvider);
  final hasLocal = await repository.hasLocalData();
  print('[localDishesProvider] hasLocalData: $hasLocal');
  if (!hasLocal) {
    print('[localDishesProvider] no local data -> syncing from API...');
    await repository.syncDishes();
    print('[localDishesProvider] sync finished');
  }
  final dishes = await repository.getLocalDishes();
  print(
    '[localDishesProvider] returning ${dishes.length} dishes from local DB',
  );
  return dishes;
});

final hasLocalDishesProvider = FutureProvider.autoDispose<bool>((ref) async {
  final repository = ref.watch(dishRepositoryProvider);
  return repository.hasLocalData();
});

final localCountriesProvider = FutureProvider.autoDispose<List<Country>>((
  ref,
) async {
  final repository = ref.watch(dishRepositoryProvider);
  final hasLocal = await repository.hasLocalData();
  if (!hasLocal) {
    await repository.syncDishes();
  }
  return repository.getLocalCountries();
});
