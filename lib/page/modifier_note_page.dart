import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_entrainement/main.dart';
import 'package:flutter_entrainement/model/note_model.dart';
import 'package:flutter_entrainement/service/database_helper.dart';

class ModifierNotePage extends StatefulWidget {
  final Notes noteess;
  final DatabaseHelper dbhelper;
  ModifierNotePage({
    Key? key,
    required this.noteess,
    required this.dbhelper,
  }) : super(key: key);

  @override
  State<ModifierNotePage> createState() => _ModifierNotePageState();
}

class _ModifierNotePageState extends State<ModifierNotePage> {
  late TextEditingController titreController;
  late TextEditingController descriptionController;
  List<Notes> _notes = [];
  bool _montrerIcon = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titreController = TextEditingController(text: widget.noteess.titre);
    descriptionController =
        TextEditingController(text: widget.noteess.description);

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
    final notes = await widget.dbhelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void modifierNote() async {
    final titre = titreController.text;
    final description = descriptionController.text;
    final updatedNote = Notes(
        id: widget.noteess.id,
        titre: titre,
        description: description,
        date: widget.noteess.date);
    await widget.dbhelper.updateNote(updatedNote);
    _actualiserNotes();
    Navigator.pop(context, true);
  }

  void supprimerNote() async {
    await widget.dbhelper.supprimerNote(widget.noteess.id!);
    _actualiserNotes();
    Navigator.pop(context, true);
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
              // Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Entrainement();
              }));
              supprimerNote();
              print("retour sans");
            } else {
              modifierNote();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Entrainement();
              }));
              print("retour et modifié");
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Remarque",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _montrerIcon
              ? IconButton(
                  onPressed: modifierNote,
                  icon: Icon(
                    Icons.check,
                    color: Colors.blue,
                  ))
              : PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "supprimer") {
                      supprimerNote();
                    }
                    ;
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem(
                          child: Text("Supprimer"),
                          value: 'supprimer',
                        )
                      ]),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.noteess.date),
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
