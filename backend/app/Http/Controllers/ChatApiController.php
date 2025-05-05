<?php

namespace App\Http\Controllers;

use App\Models\Chat;
use App\Models\Message;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ChatApiController extends Controller
{
    public function index($id){
        $data = User::where('id', '!=', $id)->get(); //menampilkan semua data user kecuali user yg sedang login di app
        return response()->json(['message' => 'menampilkan semua data user', 'success' => true, 'data' => $data]);
    }

    public function chat(Request $request){
        $validator = Validator::make($request->all(),[
            'sender_id' => 'required',
            'receiver_id' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $sender = $request->sender_id;
        $receiver = $request->receiver_id;

        //mencari room chat berdasarkan id_user sbg sendeer atw receiver dari request| (SELECT * FROM WHERE sender_id AND receiver_id atw SELECT * FROM WHERE receiver_id AND sender_id)
        $room = Chat::where('sender_id', $sender)->where('receiver_id', $receiver)->orWhere('sender_id', $receiver)->where('receiver_id', $sender)->first();
        if(!$room){ //jika tidak ada room dalam tbl Chat maka akan membuat room chat
            $room = Chat::create([
                'sender_id' => $sender,
                'receiver_id' => $receiver,
            ]);
        }

        $data = [
            'chat_id' => $room->id, //"chat_id" ini digunakan untuk function di bawah
        ];
        return response()->json(['message' => 'Menampilkan chat', 'success' => true, 'data' => $data]);
    }

    public function message($id){
        $data = Message::with('user')->where('chat_id', $id)->get(); //memanggil orm user di model Message| mencari semua data message dengan "chat_id"
        return response()->json(['message' => 'Menampilkan chat', 'success' => true, 'data' => $data]);
    }

    public function sendMessage(Request $request){
        $validator = Validator::make($request->all(),[
            'chat_id' => 'required',
            'user_id' => 'required',
            'message' => 'required',
            'gambar' => 'image|mimes:png,jpeg,jpg|max:2048',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        $data = Message::create([
            'chat_id' => $request->chat_id,
            'user_id' => $request->user_id,
            'message' => $request->message,
            'gambar' => $nmgambar,
        ]);

        return response()->json(['message' => 'Berhasil mengirim pesan', 'success' => true, 'data' => $data]);
    }
}
