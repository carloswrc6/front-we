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
  final count = await repository.getLocalDishCount();
  print('[localDishesProvider] local dish count: $count');
  if (count < 200) {
    print('[localDishesProvider] incomplete data, syncing from API...');
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
  final countries = await repository.getLocalCountries();
  if (countries.isEmpty || countries.any((c) => c.name.isEmpty)) {
    print('[localCountriesProvider] countries invalid/empty, re-syncing...');
    await repository.syncDishes();
    final fresh = await repository.getLocalCountries();
    print('[localCountriesProvider] got ${fresh.length} valid countries');
    return fresh;
  }
  print('[localCountriesProvider] returning ${countries.length} countries');
  return countries;
});
