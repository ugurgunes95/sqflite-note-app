import 'package:flutter/material.dart';
import 'package:sqflitedeneme/dbhelper.dart';
import 'package:sqflitedeneme/note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbHelper dbHelper = DbHelper();

  final noteController = TextEditingController();
  final updateNoteController = TextEditingController();
  int? selectedOne;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade800,
        title: ListTile(
            tileColor: Colors.transparent,
            title: TextField(
              decoration: InputDecoration(
                hintText: "Yazmaya başlayabilirsiniz...",
                hintStyle: TextStyle(color: Colors.white70),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              controller: noteController,
              enabled: selectedOne == null ? true : false,
              keyboardType: TextInputType.text,
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 36.0,
                ),
                onPressed: () async {
                  noteController.text.length != 0
                      ? await dbHelper
                          .insertNote(Note(content: noteController.text))
                      : selectedOne = null;
                  setState(() {
                    noteController.clear();
                  });
                })),
      ),
      body: listViewBuild(),
      backgroundColor: Colors.blueGrey.shade900,
    );
  }

  Widget listViewBuild() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
      child: FutureBuilder<List<Note>>(
        future: dbHelper.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Yükleniyor",
                style: TextStyle(color: Colors.white, fontSize: 36),
              ),
            );
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Text(
                    "Not bulunmamaktadır",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView(
                  children: snapshot.data!.map((note) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      AnimatedContainer(
                        alignment: AlignmentDirectional.topStart,
                        height: selectedOne == note.id ? 240 : 60,
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.fromLTRB(4.0, 6.0, 4.0, 6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: note.id == selectedOne
                              ? Colors.blueGrey.shade600
                              : Colors.blueGrey.shade800,
                        ),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              selectedOne = note.id;
                              updateNoteController.text = note.content;
                            });
                          },
                          tileColor: Colors.transparent,
                          title: (selectedOne != note.id || selectedOne == null)
                              ? Text(
                                  note.content.toString(),
                                  style: TextStyle(color: Colors.white),
                                )
                              : TextField(
                                  decoration: InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: updateNoteController,
                                  autofocus:
                                      selectedOne == note.id ? true : false,
                                  maxLines: selectedOne == note.id ? 5 : 1,
                                  keyboardType: TextInputType.text,
                                ),
                          trailing: selectedOne != note.id
                              ? IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dbHelper.deleteNote(note.id!);
                                      selectedOne = null;
                                      updateNoteController.clear();
                                      noteController.clear();
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 36.0,
                                  ),
                                  onPressed: () async {
                                    await dbHelper.updateNote(Note(
                                        id: selectedOne,
                                        content: updateNoteController.text));
                                    setState(() {
                                      updateNoteController.clear();
                                      selectedOne = null;
                                    });
                                  }),
                        ),
                      ),
                    ],
                  );
                }).toList());
        },
      ),
    );
  }
}
