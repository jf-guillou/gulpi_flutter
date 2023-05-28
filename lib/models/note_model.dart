class Note {
  late int id;
  late String content;

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
  }

  Map toJson() {
    return {
      "id": id,
      "content": content,
    };
  }
}
