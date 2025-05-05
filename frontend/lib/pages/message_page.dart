import 'dart:math';

import 'package:chatting/models/messages.dart';
import 'package:chatting/models/sender.dart';
import 'package:chatting/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MessagePage extends StatefulWidget {
  final int chatID;
  final String chatWith;
  MessagePage({required this.chatID, required this.chatWith}); //mendapatkan "chat_id" di halaman sebelumnya (Navigator.push)

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  ApiService apiService = ApiService();
  Sender? _sender; //seperti _user
  List<Messages> messageList = [];
  bool isLoading = false;
  final messageController = TextEditingController();
  final _pilih = ImagePicker();
  XFile? gambar;

  void pilih()async{
    gambar = await _pilih.pickImage(source: ImageSource.gallery);
  }

  @override
  void initState() {
    super.initState();
    fetchMessage();
    fetchSender();
  }

  void _sendMessage()async{
    if(messageController.text.isNotEmpty){
      final newMessage = Messages(
        chatID: widget.chatID,
        userID: _sender!.id,
        message: messageController.text,
      );

      await apiService.sendMessage(newMessage, gambar).then((_) {
        fetchMessage(); //setelah send missage referes halaman
        gambar = null; //isi Inpu Text dan gambar jadi kosong
        messageController.clear();
      });
    }
  }

  void fetchSender()async{ //mengambil data user yg login
    Sender? sender = await apiService.getSender();
    setState(() {
      _sender = sender;
    });
  }
  
  Future<void> fetchMessage()async{
    setState(() {
      isLoading = true;
    });
    messageList = await apiService.getMessage(widget.chatID); //mengambil dan menggunakan "chat_id" di construktor atas
    setState(() {
      isLoading = false;
    });
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            BackButton(),
            CircleAvatar(
              backgroundImage:
                  NetworkImage("https://i.pinimg.com/736x/54/72/d1/5472d1b09d3d724228109d381d617326.jpg"),
            ),
            SizedBox(width: 16.0 * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatWith,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active Now",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          const SizedBox(width: 16.0 / 2),
        ],
      ),
      body: _sender == null
      ? Center(child: CircularProgressIndicator(),)
      : isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: fetchMessage,
          child: Column(
            children: [
              Expanded( //gunakan expanded agar perulangan tidak terbawa ke stfl/stl lain
                child: ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (context, index) => Pesan(
                    messages: messageList[index],
                    sender: _sender!,
                    ))
              ),
             ChatInputField( //stfl input Text Message dan Gambar
              message: messageController,
              pilih: pilih,
              sendMessage: _sendMessage,),
        ],
      ),
      )
    );
  }
}


class ChatInputField extends StatefulWidget {
  final TextEditingController message;
  final VoidCallback sendMessage, pilih;
  ChatInputField({required this.message, required this.sendMessage, required this.pilih});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _showAttachment = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.mic, color: Color(0xFF00BF6D)),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 16.0 / 4),
                      Expanded(
                        child: TextField(
                          controller: widget.message,
                          decoration: InputDecoration(
                            hintText: "Type message",
                            suffixIcon: SizedBox(
                              width: 65,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: widget.pilih,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: _showAttachment
                                          ? const Color(0xFF00BF6D)
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(0.64),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: widget.sendMessage,
                                    child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0 / 2),
                                    child: Icon(
                                      Icons.send,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.64),
                                    ),
                                  ),
                                  )
                                ],
                              ),
                            ),
                            filled: true,
                            fillColor:
                                const Color(0xFF00BF6D).withOpacity(0.08),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Pesan extends StatelessWidget {
  final Messages messages;
  Sender sender;
  Pesan({required this.messages, required this.sender});

 @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    child: Align(
      alignment: messages.userID == sender.id //Text Message akan berada di kanan jika Message user_idnya sama dgn sender(curent user)| begitupun sebaliknya dgn receiver di kiri
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7, // max 70% dari lebar layar
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0 * 0.75,
            vertical: 16.0 / 2,
          ),
          decoration: BoxDecoration(
            color: messages.userID == sender.id //warna buble Text Message hijau jika Message user_idnya sama dgn sender(curent user)| begitupun sebaliknya dgn receiver abu-abu
                ? Color(0xFF00BF6D)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
              children: [
                Text(
                messages.message,
                  style: TextStyle(
                    color: messages.userID == sender.id
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              if(messages.gambar != null) //jika Message ada gambar akan di tampilkan| jika null tdk di tampilkan
              Image.network('http://10.0.2.2:8000/images/${messages.gambar}', width: 150, 
              errorBuilder: (context, error, stackTrace) => 
                Container(
                  child: Icon(Icons.broken_image),
                  width: 150,
                  color: Colors.grey,),)
              ],
            ),
          
        ),
      ),
    ),
  );
}
}