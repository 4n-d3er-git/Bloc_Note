import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_entrainement/model/note_model.dart';
import 'package:flutter_entrainement/service/database_helper.dart';
import 'package:intl/intl.dart';

class AjouterNote extends StatefulWidget {
  const AjouterNote({super.key});

  @override
  State<AjouterNote> createState() => _AjouterNoteState();
}

class _AjouterNoteState extends State<AjouterNote> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  TextEditingController titreController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime date = DateTime.now();
  List<Notes> _notes = [];
  bool _montrerIcon = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _actualiserNotes();
    titreController.addListener(_handleTextChange);
    descriptionController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titreController.removeListener(_handleTextChange);
    descriptionController.removeListener(_handleTextChange);
    titreController.dispose();
    descriptionController.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _montrerIcon = titreController.text.isNotEmpty ||
          descriptionController.text.isNotEmpty;
    });
  }

  void _actualiserNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void ajouterNote() async {
    final titre = titreController.text.trim();
    final description = descriptionController.text.trim();
    final date = DateFormat('yyyy-MM-dd-kk-mm').format(DateTime.now());
    if (description.isNotEmpty) {
      final nouveauNote =
          Notes(titre: titre, description: description, date: date);
      await _dbHelper.insererNote(nouveauNote);

      _actualiserNotes();
    }
  }

  void updateNote(Notes note) async {
    final updatedNote = Notes(
        id: note.id,
        titre: note.titre,
        description: note.description,
        date: note.date);
    await _dbHelper.updateNote(updatedNote);
    _actualiserNotes();
  }

  void supprimerNote(int id) async {
    await _dbHelper.supprimerNote(id);
    _actualiserNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (titreController.text.isEmpty &&
                descriptionController.text.isEmpty) {
              Navigator.pop(context);
              print("retour sans");
            } else {
              ajouterNote();
              Navigator.pop(context);
              print("retour et ajout");
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Remarque",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_montrerIcon)
            IconButton(
                onPressed: () {
                  ajouterNote();
                  print("object");
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.blue,
                )),],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${date}"),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  controller: titreController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Titre",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 27)),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Prendre des notes",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
