<?php

namespace App\Http\Controllers;

trait apiResponse
{
    public function apiResponse($data =null,$code = null,$msg = null){

    $array = [
        'data'=>$data,
        'message'=>$msg
    ];
    return response($array,$code);
    }


}
