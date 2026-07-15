import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/infrastructure/datasource/avoid_reason_datasource.dart';
import 'package:frontwe/infrastructure/datasource/http_client_provider.dart';
import 'package:frontwe/infrastructure/models/avoid_reason_model.dart';

final avoidReasonDatasourceProvider = Provider<AvoidReasonDatasource>((ref) {
  return AvoidReasonDatasource(dio: ref.watch(httpClientProvider));
});

final avoidReasonsProvider = FutureProvider.autoDispose<List<AvoidReasonModel>>((ref) async {
  final datasource = ref.watch(avoidReasonDatasourceProvider);
  return datasource.getAvoidReasons();
});
