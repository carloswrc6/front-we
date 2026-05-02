// C:\calochop-py\front_we\lib\presentation\providers\plan\plan_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/repository/plan_repository.dart';
import 'package:frontwe/infrastructure/datasource/plan_db_datasource.dart';
import 'package:frontwe/infrastructure/repositories/plan_repository_impl.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepositoryImpl(PlanDbDatasource());
});
