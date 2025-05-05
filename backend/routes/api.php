<?php

use App\Http\Controllers\AuthApiController;
use App\Http\Controllers\ChatApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/login',[AuthApiController::class,'login']);
Route::post('/register',[AuthApiController::class,'register']);
Route::middleware('auth:sanctum')->post('/logout',[AuthApiController::class,'logout']);
Route::get('/index/{id}',[ChatApiController::class,'index']); //route ini membutuhkan parameter ID user yg sedang login di app
Route::post('/chat',[ChatApiController::class,'chat']);
Route::get('/chat/{id}',[ChatApiController::class,'message']); //route ini akan mengambil semuda data chat berdasarkan "chat_id"
Route::post('/message',[ChatApiController::class,'sendMessage']);