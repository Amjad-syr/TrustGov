<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\employee;
use App\Http\Resources\EmployeeResource;
use Illuminate\Support\Facades\Auth;

class EmployeeController extends Controller
{
    use apiResponse;

    public function getemployees()
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $employees = employee::all()->where('role' , 0);
        return $this->apiResponse($employees,200,'ok');

    }
}
