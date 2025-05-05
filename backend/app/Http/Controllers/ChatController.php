<?php

namespace App\Http\Controllers;

use App\Models\Chat;
use App\Models\Message;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ChatController extends Controller
{
    public function index(){
        $user = User::where('id', '!=', Auth::user()->id)->get(); //menampilkan semua data user kecuali user ini
        return view('main.index', ['tampil' => $user]);
    }

    public function chat(Request $request){
        $request->validate([
            'chat_with' => 'required',
            'receiver_id' => 'required',
        ]);

        $senderID = Auth::user()->id;
        $receiverID = $request->receiver_id;
        //Mencari room chat (chat_id) contohnya seperti SELECT * FROM WHERE sender_id AND receiver_id atw SELECT * FROM WHERE receiver_id AND sender_id
        $room = Chat::where('sender_id', $senderID)->where('receiver_id', $receiverID)->orWhere('sender_id', $receiverID)->where('receiver_id', $senderID)->first();
        if(!$room){ //jika tidak ada maka akan membuat room chat (chat_id)
            $room = Chat::create([
                'sender_id' => $senderID,
                'receiver_id' => $receiverID,
            ]);
        }

        $chat = Message::with('user')->where('chat_id', $room->id)->get(); //mengambil data message dan user dengan "chat_id"
        return view('main.chat',['tampil' => $chat, 'chat_id' => $room->id, 'chatWith' => $request->chat_with]); //"tampil" utk chat| "chat_id" utk insert ke tbl message
    }

    public function message(Request $request){
        $request->validate([
            'chat_with' => 'required',
            'chat_id' => 'required',
            'gambar' => 'image|mimes:jpg,png,jpeg|max:2048'
        ]);

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        Message::create([
            'chat_id' => $request->chat_id,
            'user_id' => Auth::user()->id,
            'gambar' => $nmgambar,
            'message' => $request->message,
        ]);
        
        $chat = Message::with('user')->where('chat_id', $request->chat_id)->get();
        return view('main.chat',['tampil' => $chat, 'chat_id' => $request->chat_id, 'chatWith' => $request->chat_with]);
    }
}
