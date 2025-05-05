class Messages {
  final int chatID;
  final int userID;
  final String? name;
  final String message;
  final String? gambar;

  Messages({required this.chatID, required this.userID, this.name, required this.message, this.gambar});
  factory Messages.fromJson(Map<String, dynamic> json){
    return Messages(
      chatID: json['chat_id'],
      userID: json['user_id'],
      name: json['user']['name'],
      message: json['message'],
      gambar: json['gambar'],
    );
  }
}
