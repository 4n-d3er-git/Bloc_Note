import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_entrainement/ajouter_notes.dart';
import 'package:flutter_entrainement/model/note_model.dart';
import 'package:flutter_entrainement/page/modifier_note_page.dart';
import 'package:flutter_entrainement/service/database_helper.dart';
import 'package:flutter_entrainement/service/rechercher.dart';

void main() {
  runApp(MonApp());
}

class MonApp extends StatelessWidget {
  MonApp({super.key});
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Entrainement(),
    );
  }
}

class Entrainement extends StatefulWidget {
  Entrainement({super.key});

  @override
  State<Entrainement> createState() => _EntrainementState();
}

class _EntrainementState extends State<Entrainement> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Notes> _notes = [];
  void _actualiserNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _actualiserNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bloc-notes"),
          bottom: PreferredSize(
              preferredSize: Size(400, 50),
              child: Container(
                  child: Container(
                      height: 40,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(50)),
                      child: TextField(
                        // readOnly: true,
                        // onTap: 
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            hintText: "Rechercher des notes",
                            hintStyle: TextStyle(color: Colors.grey)),
                      )))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AjouterNote();
            }));
          },
          child: Icon(Icons.add),

          
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Container(
                          width: 400,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.titre ?? note.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                note.description,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                note.date,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ModifierNotePage(
                              noteess: note,
                              dbhelper: _dbHelper,
                            );
                          }));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                })));
  }
}
