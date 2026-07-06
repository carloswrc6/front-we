import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish_history.dart';
import 'package:frontwe/infrastructure/services/local_db_service.dart';

final historyProvider = FutureProvider.autoDispose<List<DishHistory>>((ref) async {
  final rows = await LocalDbService.instance.getAllHistory();
  return rows.map((r) => DishHistory.fromMap(r)).toList();
});
