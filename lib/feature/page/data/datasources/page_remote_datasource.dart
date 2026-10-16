import 'package:logger/logger.dart';
import 'package:notion_app/core/error/exceptions.dart';
import 'package:notion_app/feature/page/data/model/page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _logger = Logger();

sealed class PageRemoteDataSource {
  Future<List<PageModel>> getPages();
  Future<PageModel> createPage(String title);
  Future<void> renamePage({required String id, required String title});
  Future<void> trashPage(String id);
}

class PageRemoteDataSourceImpl implements PageRemoteDataSource {
  final SupabaseClient _client;
  const PageRemoteDataSourceImpl(this._client);

  static const _table = 'pages';
  static const _columns = 'id, title, icon, last_edited_time';

  @override
  Future<List<PageModel>> getPages() async {
    try {
      final rows = await _client
          .from(_table)
          .select(_columns)
          .eq('in_trash', false)
          .isFilter('parent_page_id', null) 
          .order('last_edited_time', ascending: false);

      return rows.map<PageModel>((r) => PageModel.fromJson(r)).toList();
    } catch (e) {
      _logger.e('Get pages error: $e');
      throw ServerException();
    }
  }

  @override
  Future<PageModel> createPage(String title) async {
    try {
      final row = await _client
          .from(_table)
          .insert({'title': title})
          .select(_columns)
          .single();

      return PageModel.fromJson(row);
    } catch (e) {
      _logger.e('Create page error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> renamePage({required String id, required String title}) async {
    try {
      final rows = await _client
          .from(_table)
          .update({'title': title})
          .eq('id', id)
          .select('id');

      if (rows.isEmpty) throw EmptyException();
    } on EmptyException {
      rethrow;
    } catch (e) {
      _logger.e('Rename page error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> trashPage(String id) async {
    try {
      final rows = await _client
          .from(_table)
          .update({'in_trash': true})
          .eq('id', id)
          .select('id');

      if (rows.isEmpty) throw EmptyException();
    } on EmptyException {
      rethrow;
    } catch (e) {
      _logger.e('Trash page error: $e');
      throw ServerException();
    }
  }
}