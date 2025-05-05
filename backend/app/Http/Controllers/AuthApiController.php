<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthApiController extends Controller
{
    public function login(Request $request){
        $validator = Validator::make($request->all(),[
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($login)){
            $data = [
                'token' => Auth::user()->createToken('auth-token')->plainTextToken,
            ];
            return response()->json(['message' => 'Login berhasil', 'success' => true, 'data' => $data]);
        }else{
            return response()->json(['message' => 'Email atau Password Salah', 'success' => false, 'data' => null]);
        }
    }

    public function register(Request $request){
        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'password' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);
        
        $data = [
            'token' => $user->createToken('auth-token')->plainTextToken,
        ];
        return response()->json(['message' => 'Register Berhasil', 'success' => true, 'data' => $data]);
    }

    public function logout(Request $request){
        $request->user()->tokens()->delete();
        return response()->json(['message' => 'Anda telah Logout']);
    }
}
