class Conversation {
  String email;
  String id;

  Conversation({required this.id, required this.email});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(id: json['id'], email: json['name']);
  }
}
