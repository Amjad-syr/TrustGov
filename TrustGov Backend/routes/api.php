<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\VotingController;
use App\Http\Controllers\PropertyPurchaseController;
use App\Http\Controllers\PropertyRentalController;
use App\Http\Controllers\UserAuthController;
use App\Http\Controllers\EmployeeAuthController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\UserContoller;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\ComplaintController;


Route::group(['prefix' => 'user'], function () {
    Route::post('register', [UserAuthController::class, 'register']);
    Route::post('login', [UserAuthController::class, 'login']);
    Route::post('refresh', [UserAuthController::class, 'refresh']);

    Route::group(['middleware' => ['auth:user']], function () {
        Route::post('logout', [UserAuthController::class, 'logout']);
        Route::get('profile',[UserAuthController::class, 'userProfile'] );
        Route::get('elections/latest', [VotingController::class, 'getLatestElection']);
        Route::get('/elections/active', [VotingController::class, 'getActiveElections']);
        Route::get('/elections/{electionId}/candidates', [VotingController::class, 'getAllCandidates']);
        Route::post('/elections/vote', [VotingController::class, 'vote']);
        Route::get('/elections/{electionId}/has-voted', [VotingController::class, 'hasVoted']);
        Route::get('/properties/getall', [UserContoller::class, 'get_properties']);
        Route::post('/rooms/create', [RoomController::class, 'createRoom']);
        Route::post('/rooms/join', [RoomController::class, 'joinRoom']);
        Route::get('/rooms/status/{code}', [RoomController::class, 'check_room_status']);
        Route::get('/rooms/confirm/{code}', [RoomController::class, 'confirm_room']);
        Route::post('/rooms/end', [RoomController::class, 'end_room']);
        Route::post('/complaints/create', [ComplaintController::class, 'createComplaint']);
        Route::get('/complaints/pending', [ComplaintController::class, 'getPendingComplaints']);
        Route::post('/complaints/vote', [ComplaintController::class, 'ComplaintVote']);
        Route::post('/verify', [UserContoller::class, 'verifyUser']);

    });
});

Route::group(['prefix' => 'employee'], function () {
    Route::post('login', [EmployeeAuthController::class, 'login']);
    Route::post('refresh', [EmployeeAuthController::class, 'refresh']);

    // Auth routes
    Route::group(['middleware' => ['auth:employee']], function () {
        Route::post('register', [EmployeeAuthController::class, 'register']);
        Route::post('logout', [EmployeeAuthController::class, 'logout']);
        Route::get('getall', [EmployeeController::class, 'getemployees']);
        Route::get('profile', [EmployeeAuthController::class, 'employeeProfile']);
        Route::post('elections', [VotingController::class, 'createElection']);
        Route::post('elections/addcandidate', [VotingController::class, 'addCandidate']);
        Route::get('elections', [VotingController::class, 'getAllElections']);
        Route::get('elections/latest', [VotingController::class, 'getLatestElection']);
        Route::get('/elections/{id}', [VotingController::class, 'getElection']);
        Route::get('/elections/{electionId}/candidates', [VotingController::class, 'getAllCandidates']);
        Route::post('/elections/start', [VotingController::class, 'startElection']);
        Route::post('/elections/end', [VotingController::class, 'endElection']);
        Route::post('/elections/delete', [VotingController::class, 'deleteElection']);
        Route::post('/elections/candidates/delete', [VotingController::class, 'deleteCandidate']);
        Route::get('/purchase-contracts/{id}', [PropertyPurchaseController::class, 'getContractById']);
        Route::get('/rental-contracts/{id}', [PropertyRentalController::class, 'getContractById']);
        Route::get('/complaints/all', [ComplaintController::class, 'getAllComplaints']);
        Route::get('/complaints/pending', [ComplaintController::class, 'getPendingComplaints']);
        Route::get('/complaints/approved', [ComplaintController::class, 'getApprovedComplaints']);
        Route::get('/complaints/denied', [ComplaintController::class, 'getDeniedComplaints']);
        Route::get('/complaints/done', [ComplaintController::class, 'getDoneComplaints']);
        Route::post('/complaints/status/change', [ComplaintController::class, 'changestatus']);


    });
});


Route::post('/rental-contracts/add', [PropertyRentalController::class, 'addRentalContract']);

Route::post('/purchase-contracts/add', [PropertyPurchaseController::class, 'addPurchaseContract']);






Route::get('/elections/active', [VotingController::class, 'getActiveElections']);







Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


