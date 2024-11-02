class Note {
  final int? id; // Nullable for new notes
  final String title;
  final String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Convert a Note into a Map. The Map is used as the
  // data for the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Extract a Note from a Map.
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
