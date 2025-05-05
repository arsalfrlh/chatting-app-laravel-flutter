import 'package:chatting/models/receiver.dart';
import 'package:chatting/models/sender.dart';
import 'package:chatting/pages/login_page.dart';
import 'package:chatting/pages/message_page.dart';
import 'package:chatting/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  int senderID;
  ChatPage({required this.senderID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ApiService apiService = ApiService();
  List<Receiver> userList = [];
  Sender? _sender;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserList();
    fetchSender();
  }

  void fetchSender() async {
    Sender? sender = await apiService.getSender();
    setState(() {
      _sender = sender;
    });
  }

  Future<void> fetchUserList() async {
    setState(() {
      isLoading = true;
    });
    userList = await apiService.getUserList(widget.senderID); //senderID di halaman sebelumnya "HomePage"
    setState(() {
      isLoading = false;
    });
  }

  void _logout() async {
    await apiService.logout().then((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda telah logout'),backgroundColor: Colors.red,));
    });
  }

  void getChatRoom(int receiverID, String chatWith) async { //receiverID dpt di userList[index].id| chatWith dpt di userList[index].name| hrus berurutan seuai function
    final response = await apiService.chatRoom(_sender!.id, receiverID); //senderID dpt di fetchSender()| receiverID dpt di userList[index].id
    if(response['success'] == true){
      Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage(
        chatWith: chatWith, //utk tittle MessagePage dgn nama user yg di chat
        chatID: response['data']['chat_id']))); //akan mengambil data dri array key "chat_id" di dlm array key "data"
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.green,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: Text("Hello ${_sender?.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _sender == null
      ? Center(child: CircularProgressIndicator())
      : SafeArea(
        child: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) => CallHistoryCard(
            user: userList[index],
            isActive: index.isEven,
            press: () => getChatRoom(userList[index].id, userList[index].name), //saat di klik userList akan memanggil function di atas
          ),
        ),
      ),
    );
  }
}

class CallHistoryCard extends StatelessWidget {
  CallHistoryCard(
      {required this.isActive, required this.press, required this.user});

  final bool isActive;
  final VoidCallback press;
  Receiver user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0 / 2,
      ),
      onTap: press,
      leading: CircleAvatarWithActiveIndicator(
        isActive: isActive,
        radius: 28,
      ),
      title: Text(user.name),
    );
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.radius = 24,
    this.isActive,
  });

  final double? radius;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
           backgroundImage:
                  NetworkImage("https://i.pinimg.com/736x/54/72/d1/5472d1b09d3d724228109d381d617326.jpg"),
        ),
        if (isActive!)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF00BF6D),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor, width: 3),
              ),
            ),
          )
      ],
    );
  }
}
