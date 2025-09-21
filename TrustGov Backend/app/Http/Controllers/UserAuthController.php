<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\userinfo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use Exception;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\JWTException;
use App\Http\Resources\UserResource;

class UserAuthController extends Controller
{
    use apiResponse;

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'national_id' => 'required|integer|digits:10|exists:userinfos,national_id',
            'id_number' => 'required|integer|digits:6|exists:userinfos,id_number',
            'password' => 'required|string|between:8,20',

        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        try {



        try{
            $userinfo = userinfo::findorfail($request->national_id)->first();
            $user = new User;
            $user->national_id = $request->national_id;
            $user->password = bcrypt($request->password);
            $user->id_number = $request->id_number;
            $user->first_name = $userinfo->first_name;
            $user->last_name = $userinfo->last_name;
            $user->father_name = $userinfo->father_name;
            $user->mother_full_name = $userinfo->mother_full_name;
            $user->birth_date = $userinfo->birth_date;
            $user->special_features = $userinfo->special_features;
            $user->save();
        }catch (Exception $e){
            return $this->apiResponse(["error"=>$e->getMessage()],400,"User registration failed");
        }

        return $this->apiResponse(new UserResource($user),200,"User successfully registered");
        }
        catch (Exception $e) {
            $user->delete();
            return $this->apiResponse(["error"=>$e->getMessage()],400,"User registration failed");
        }
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'national_id' => 'required',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422,"Validation error");
        }
        $credentials = $validator->validated();


        if (! $token = auth('user')->attempt($credentials)) {
            return $this->apiResponse(['error' => 'Unauthorized'], 401, "Wrong id or password");
        }
        $user = auth()->guard('user')->user();

        return $this->apiResponse($this->createNewToken($token)->original,200,'ok');
    }

    public function logout()
    {
     try {
        auth()->guard('user')->logout();
        return $this->apiResponse(null, 200, 'User successfully signed out');
    } catch (TokenInvalidException $e) {

        return $this->apiResponse(null, 400, 'Invalid token');
    } catch (JWTException $e) {

        return $this->apiResponse(null, 500, 'An error occurred during logout');
    } catch (Exception $e) {

        return $this->apiResponse(null, 500, 'An unexpected error occurred');
    }
    }

    public function refresh()
    {
        try {
            $newToken = auth()->guard('user')->refresh();
            return $this->apiResponse(['token'=>$newToken], 200, 'Token refreshed successfully');
        } catch (TokenExpiredException $e) {

            return $this->apiResponse(null, 401, 'Token expired');
        } catch (TokenInvalidException $e) {

            return $this->apiResponse(null, 400, 'Invalid token');
        } catch (JWTException $e) {

            return $this->apiResponse(null, 500, 'Could not refresh token');
        } catch (Exception $e) {

            return $this->apiResponse(null, 500, 'An unexpected error occurred');
        }
    }
    public function userProfile() {
        return  $this->apiResponse(new UserResource(auth()->guard('user')->user()),200,'ok');
    }

    protected function createNewToken($token){
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->guard('user')->factory()->getTTL() * 60,
            'user' => new UserResource(auth()->guard('user')->user())
        ]);
    }
}
