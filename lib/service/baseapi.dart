import 'package:apnahood/model/search_query.dart';
import 'package:apnahood/model/post_details.dart';

abstract class BaseApi {
  Future<SearchQueryModel> searchApi({query});
  Future<PostDetailsModel> postDetailsApi({postId});
}
