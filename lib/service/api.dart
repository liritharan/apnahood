import 'dart:convert';
import 'package:apnahood/locator.dart';
import 'package:apnahood/model/search_query.dart';
import 'baseurl.dart';
import 'baseapi.dart';
import 'package:http/http.dart' as http;

var url = locator<BaseUrl>();

class Api extends BaseApi {
  @override
  Future<SearchQueryModel> searchApi({query}) async {
    var response = await http.get('${url.query}$query');
    print('${url.query}$query');

    var decode = json.decode(response.body);
    if (decode != null) {
      SearchQueryModel list = SearchQueryModel.fromJson(decode);
      return list;
    } else {
      return null;
    }
  }


}
