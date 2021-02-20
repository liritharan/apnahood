import 'package:apnahood/Screen/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:apnahood/model/search_query.dart';
import 'package:apnahood/service/api.dart';
import '../locator.dart';

var conntapis = locator<Api>();

class DataSearch extends SearchDelegate<String> {
  final search = [];
  final recentsearch = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // IconButton(
      //     icon: Icon(Icons.clear, color: Colors.red),
      //     onPressed: () {
      //       query = "";
      //     }),
      IconButton(
          icon: Icon(
            Icons.search,
            size: 30,
            color: Colors.blue,
          ),
          onPressed: () {
            showResults(context); // query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<SearchQueryModel>(
        future: conntapis.searchApi(query: query),
        builder: (context, getinfo) {
          switch (getinfo.connectionState) {
            case ConnectionState.none:
              return Text('');
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              return Text('');
              break;
            case ConnectionState.done:
              if (getinfo.hasError) {
                return Center(
                  child: Text('Error: $getinfo',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                );
              } else if (getinfo.hasData) {
                if (getinfo.data.hits.isEmpty) {
                  return Center(
                    child: Text(
                      'No result found',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  );
                } else {
                  return listsearch(getinfo.data);
                }
              } else {
                return Text('');
              }
              break;
          }
          return Text('');
        });
  }

  listsearch(SearchQueryModel data) {
    return ListView.builder(
      itemCount: data.hits.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var count = index + 1;
        return Card(
          child: ListTile(
            dense: true,
            leading: Text('$count.'),
            title: Text(
              '${data.hits[index].title}',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Row(
              children: [
                Text('Author: ', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('${data.hits[index].author}'.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostDetails(
                    postId: '${data.hits[index].objectID}',
                  )));
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final buildSuggestion = query.isEmpty
        ? recentsearch
        : search.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemCount: buildSuggestion.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            showResults(context);
          },
          leading: Icon(Icons.search),
          title: RichText(
              text: TextSpan(
                  text: buildSuggestion[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: buildSuggestion[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    )
                  ])),
        );
      },
    );
  }
}
