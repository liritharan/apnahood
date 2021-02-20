import 'package:apnahood/model/search_query.dart';

abstract class BaseApi {
  Future<SearchQueryModel> searchApi({query});
}
