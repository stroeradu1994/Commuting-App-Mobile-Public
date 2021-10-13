import 'package:commuting_app_mobile/services/place_service.dart';
import 'package:flutter/material.dart';

class AddressSearch extends SearchDelegate<Suggestion> {

  PlaceApiProvider? apiClient;

  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, new Suggestion("", ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient!.fetchSuggestions(
          query, 'ro'),
      builder: (context, snapshot) => query == ''
          ? Container(
        padding: EdgeInsets.all(16.0),
        child: Text('Enter your address'),
      )
          : snapshot.hasData
          ? ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title:
          Text(((snapshot.data as List<Suggestion>)[index]).description),
          onTap: () {
            close(context, (snapshot.data as List<Suggestion>)[index]);
          },
        ),
        itemCount: (snapshot.data as List<Suggestion>).length,
      )
          : Container(child: Text('Loading...')),
    );
  }
}