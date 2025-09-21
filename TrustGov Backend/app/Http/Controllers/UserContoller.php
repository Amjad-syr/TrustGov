<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\File;
use Illuminate\Support\Facades\Http;
class UserContoller extends Controller
{
    use apiResponse;

    public function get_properties(){

        $user = Auth::user();
        $properties = $user->properties()->get();

        return $this->apiResponse($properties,200,'ok');

    }

    public function verifyUser(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'img'     => 'required|file|mimes:jpg,jpeg,png',
        ]);

        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $user = Auth::user();
        if($user->national_id == 1234567890){
            $userid = 61;
        }
        try {
            $imageFile    = $request->file('img');

            $response = Http::attach(
                'img', file_get_contents($imageFile->getRealPath()), $imageFile->getClientOriginalName()
            )->post('http://127.0.0.1:5000/api/iris', [
                'user_id' => $userid,
                'mode'    => 'verify',]);

            return $this->apiResponse($response->json(), 200,'ok');

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Verification request failed: ' . $e->getMessage(),
            ], 500);
        }
    }
}


