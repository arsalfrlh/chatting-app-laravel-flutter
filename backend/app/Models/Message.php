<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Message extends Model
{
    protected $fillable = ['chat_id','message','user_id','gambar'];

    public function user(){
        return $this->belongsTo(User::class,'user_id');
    }
}
