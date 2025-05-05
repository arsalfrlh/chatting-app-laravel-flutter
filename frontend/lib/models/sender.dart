class Sender {
  final int id;
  final String name;

  Sender({required this.id, required this.name});
  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      name: json['name'],
    );
  }
}
