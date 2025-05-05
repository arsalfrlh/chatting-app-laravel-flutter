import 'dart:convert';

import 'package:chatting/models/messages.dart';
import 'package:chatting/models/receiver.dart';
import 'package:chatting/models/sender.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password)async{
    final response = await http.post(Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'name': name, 'email': email, 'password': password}));
    return json.decode(response.body);
  }

  Future<void> logout() async {
    final key = await SharedPreferences.getInstance();
    final token = await key.getString('token');

    await http.post(Uri.parse('$baseUrl/logout'),
        headers: {'Authorization': 'Bearer $token'});

    await key.remove('token');
    await key.remove('statusLogin');
  }

  //user yg login akan di simpan ke dalam Model Class "Sender"
  Future<Sender?> getSender() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/user'),
        headers: {'Authorization': "Bearer $token"});

    if (response.statusCode == 200) {
      return Sender.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  //smua data user akan disimpan ke Model Class "Receiver"
  Future<List<Receiver>> getUserList(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/index/$id'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Receiver.fromJson(item)).toList();
    } else {
      throw Exception('Data gagal dimuat');
    }
  }

  
  Future<Map<String, dynamic>> chatRoom(int senderID, int receiverID) async {
    final response = await http.post(Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sender_id': senderID, 'receiver_id': receiverID})); //arraykey ini akan di proses dlu di server dgn function "chat"|cek apkh ada data room chat jk ada akan mengembalikan "chat_id"| jika tidak ada akan membuat dan mengembalikan "chat_id"
    return json.decode(response.body);
  }

  Future<List<Messages>> getMessage(int chatRoomID) async { //"chat_id" ini di ambil dari hasil function atas (chatRoom)
    final response = await http.get(Uri.parse('$baseUrl/chat/$chatRoomID'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Messages.fromJson(item)).toList(); //Menyinpan data message di Model Class Messages
    } else {
      throw Exception('Message gagal dimuat');
    }
  }

  Future<void> sendMessage(Messages message, XFile? gambar)async{
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/message'));
    request.fields['chat_id'] = message.chatID.toString();
    request.fields['user_id'] = message.userID.toString();
    request.fields['message'] = message.message;

    if(gambar != null){
      request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    }
    
    await request.send();
  }
}
