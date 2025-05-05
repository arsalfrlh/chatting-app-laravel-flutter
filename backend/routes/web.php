<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ChatController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::middleware(['guest'])->group(function(){
    Route::get('/login',[AuthController::class,'login'])->name('login');
    Route::post('/login/proses',[AuthController::class,'loginProses']);
    Route::get('/register',[AuthController::class,'register']);
    Route::post('/register/proses',[AuthController::class,'registerProses']);
});

Route::get('/home',function(){
    return redirect('/index');
});

Route::middleware(['auth'])->group(function(){
    Route::get('/logout',[AuthController::class,'logout']);
    Route::get('/index',[ChatController::class,'index']);
    Route::post('/chat',[ChatController::class,'chat']);
    Route::get('/chat/{id}',[ChatController::class,'chat']);
    Route::post('/message',[ChatController::class,'message']);
});
