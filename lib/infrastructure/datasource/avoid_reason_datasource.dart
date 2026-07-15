import 'package:dio/dio.dart';
import 'package:frontwe/infrastructure/models/avoid_reason_model.dart';

class AvoidReasonDatasource {
  final Dio dio;

  AvoidReasonDatasource({required this.dio});

  Future<List<AvoidReasonModel>> getAvoidReasons() async {
    final response = await dio.get('/avoid-reasons');
    final data = response.data as List;
    return data
        .map((json) => AvoidReasonModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
