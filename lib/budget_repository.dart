import 'package:api_1/failure_model.dart';
import 'package:api_1/item_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetRepository {
  static const String _baseUrl = 'https://api.notion.com/v1/';
  final Ref _ref;
  BudgetRepository({required Ref ref}) : _ref = ref;

  Future<List<Item>> getItems() async {
    try {
      final response = await _ref.read(dioProvider).post(
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query');
      // print(
      //   response.data.toString(),
      // );
      final results = List<Map<String, dynamic>>.from(
        response.data['results'],
      );

      List<Item> items = results.map((e) => Item.fromMap(e)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return items;
    } on DioError {
      throw Failure(message: 'Something went wrong');
    }
  }
}

final dioProvider = Provider<Dio>(
  (ref) {
    return Dio(
      BaseOptions(
        headers: {
          'Authorization': 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          'Content-Type': 'application/json',
        },
      ),
    );
  },
);

final budgetRepoProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref: ref);
});
