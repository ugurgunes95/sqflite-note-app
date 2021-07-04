class Note {
  int? id;
  late String content;
  Note({this.id, required this.content});

  Note.fromObject(dynamic o) {
    this.id = int.tryParse(o['id'].toString());
    this.content = o['content'].toString();
  }

  Map<String, dynamic> toMap(Note note) {
    return {'id': note.id, 'content': note.content};
  }
}
