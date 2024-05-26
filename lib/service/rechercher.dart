import 'package:flutter/material.dart';
import 'package:flutter_entrainement/model/note_model.dart';
import 'package:flutter_entrainement/page/modifier_note_page.dart';
import 'database_helper.dart';

class ItemSearchDelegate extends SearchDelegate<Notes?> {
  final DatabaseHelper dbHelper;

  ItemSearchDelegate(this.dbHelper);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Notes>>(
      future: dbHelper.Rechercher(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.titre??item.description),
                subtitle: Text('Quantity: ${item.description}\nCreated at: ${item.date}'),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifierNotePage(noteess: item, dbhelper: dbHelper),
                    ),
                  );
                  if (result == true) {
                    // Refresh the search results if an item was updated or deleted
                    showResults(context);
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Notes>>(
      future: dbHelper.Rechercher(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No suggestions'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.titre??item.description),
                subtitle: Text('Quantity: ${item.description}\nCreated at: ${item.date}'),
                onTap: () {
                  query = item.titre??item.description;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}
