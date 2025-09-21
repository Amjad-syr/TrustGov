<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\employee;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use Exception;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\JWTException;
use App\Http\Resources\EmployeeResource;
use Illuminate\Support\Facades\Auth;

class EmployeeAuthController extends Controller
{
    use apiResponse;

    public function register(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:25|unique:employees',
            'password' => 'required|string|min:8',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        try {

        $employee = employee::create(array_merge(
            $validator->validated(),
            ['password' => bcrypt($request->password)]));


        return $this->apiResponse(new EmployeeResource($employee),200,"employee successfully registered");
        }
        catch (Exception $e) {
            $employee->delete();
            return $this->apiResponse(["error"=>$e->getMessage()],400,"employee registration failed");
        }
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422,"Validation error");
        }
        $credentials = $validator->validated();


        if (! $token = auth('employee')->attempt($credentials)) {
            return $this->apiResponse(['error' => 'Unauthorized'], 401, "Wrong id or password");
        }
        $user = auth()->guard('employee')->user();

        return $this->apiResponse($this->createNewToken($token)->original,200,'ok');
    }

    public function logout()
    {
     try {
        auth()->guard('employee')->logout();
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
            $newToken = auth()->guard('employee')->refresh();
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
    public function employeeProfile() {
        return  $this->apiResponse(new EmployeeResource(auth()->guard('employee')->user()),200,'ok');
    }

    protected function createNewToken($token){
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->guard('employee')->factory()->getTTL() * 60,
            'user' => new EmployeeResource(auth()->guard('employee')->user())
        ]);
    }
}
