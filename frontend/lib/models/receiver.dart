class Receiver {
  final int id;
  final String name;

  Receiver({required this.id, required this.name});
  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json['id'],
      name: json['name'],
    );
  }
}
