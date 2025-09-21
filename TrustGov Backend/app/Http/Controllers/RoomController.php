<?php

namespace App\Http\Controllers;

use App\Services\PropertyRentalService;
use App\Services\PropertyPurchaseService;
use App\Models\room;
use App\Models\temp_rent;
use App\Models\temp_buy;
use App\Models\User;
use App\Models\property;
use App\Models\buy_contract;
use App\Models\rent_contract;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class RoomController extends Controller
{
    use apiResponse;
    protected $propertyRentalService;
    protected $propertyPurchaseService;

    public function __construct(PropertyRentalService $propertyRentalService ,PropertyPurchaseService $propertyPurchaseService)
    {
        $this->propertyRentalService = $propertyRentalService;
        $this->propertyPurchaseService = $propertyPurchaseService;

    }

    public function createRoom(Request $request)
    {
        $creatorNationalId = auth()->user()->national_id;

        $validator = Validator::make($request->all(), [
            'room_type' => 'required|in:rent,buy',
            'property_id' => 'required|integer|exists:properties,property_id',
            'seller_address' => 'string',
            'total_amount' => 'integer',
            'paid_amount' => 'integer',
            'notes' => 'string',
        ]);

        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }

        $property = property::findorfail($request->property_id);
        if ($request->room_type === 'rent') {
            $rentContract = temp_rent::create([
                'seller_id'       => $creatorNationalId,
                'buyer_id'      => $request->input('seller_id'),
                'property_id'   => $property->property_id,
                'seller_address' => $request->input('seller_address'),
                'date'           => now(),
            ]);

            $contractId = $rentContract->id;
            $buyContractId = null;

        } else {
            $buyContract = temp_buy::create([
                'seller_id'         => $creatorNationalId,
                'buyer_id'        => $request->input('seller_id'),
                'property_id'      => $request->input('property_id'),
                'total_amount'     => $request->input('total_amount'),
                'paid_amount'      => $request->input('paid_amount'),
                'notes'            => $request->input('notes'),
                'date'             => now(),
            ]);

            $contractId = null;
            $buyContractId = $buyContract->id;
        }

        $code = Str::upper(Str::random(8));

        $room = room::create([
            'code'                => $code,
            'creator_national_id' => $creatorNationalId,
            'room_type'           => $request->room_type,
            'rent_contract_id'    => $request->room_type === 'rent' ? $contractId : null,
            'buy_contract_id'     => $request->room_type === 'buy'  ? $buyContractId : null,
            'expires_at'          => now()->addMinutes(30),
        ]);

        return $this->apiResponse($room,200,'ok');

    }

    public function joinRoom(Request $request)
    {
        $joinerNationalId = auth()->user()->national_id;

        $validator = Validator::make($request->all(), [
            'code' => 'required|string|exists:rooms,code',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }

        $room = room::where('code', $request->code)->first();
        if($room->room_type == 'rent'){
            $contract_info = $room->temp_rents()->get()->first();
        }else{
            $contract_info = $room->temp_buys()->get()->first();
        }
        $property = property::all()->where('property_id' , $contract_info->property_id)->first();

        if ($room->isExpired()) {
            return $this->apiResponse([], 400,'Room has expired');
        }
        if ($room->creator_national_id == $joinerNationalId) {
            return $this->apiResponse(['room'=>$room,'contract'=>$contract_info , 'property'=>$property], 200,'ok');
        }
        if ($room->joiner_national_id && $room->joiner_national_id != $joinerNationalId) {
            return $this->apiResponse([], 400,'Room already has two users');
        }
        $contract_info->buyer_id = $joinerNationalId;
        $contract_info->save();
        $room->update([
            'joiner_national_id' => $joinerNationalId,
        ]);

        return $this->apiResponse(['room'=>$room,'contract'=>$contract_info , 'property'=>$property], 200,'ok');

    }

    public function check_room_status($code){

        $room = room::where('code', $code)->first();
        if(!$room){
            return $this->apiResponse([], 400,'Room not found');

        }
        return $this->apiResponse($room, 200,'ok');


    }
    public function confirm_room($code){

        $room = room::where('code', $code)->first();
        if(!$room){
            return $this->apiResponse([], 400,'Room not found');

        }
        $confirmerNationalId = auth()->user()->national_id;

        if (!$room->joiner_national_id ||  !$room->creator_national_id){
            return $this->apiResponse([], 400,'Room is not full yet');
        }
        if ($confirmerNationalId == $room->joiner_national_id){
            $room->joiner_confirmed = 1;
        }elseif ($confirmerNationalId == $room->creator_national_id){
            $room->creator_confirmed = 1;
        }else {
            return $this->apiResponse([], 400,'User not in the room');
        }
        $room->save();
        return $this->apiResponse($room, 200,'ok');

    }

    public function end_room(Request $request){

        $validator = Validator::make($request->all(), [
            'code' => 'required|string|exists:rooms,code',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $room = room::where('code', $request->code)->first();


        if (!$room->joiner_confirmed || !$room->creator_confirmed){
            return $this->apiResponse([], 400,'Room doesnt have confirmation');
        }

        if($room->room_type == 'rent'){
            $contract = temp_rent::where('id',$room->rent_contract_id)->first();
            $property = property::where('property_id' , $contract->property_id)->first();

            $data = [
                'buyer_id' => $contract->buyer_id,
                'seller_id' => $contract->seller_id,
                'property_id' => $contract->property_id,
                'property_location' => $property->property_location,
                'seller_address' => $contract->seller_address,
                'date' => now()->format('d/m/Y'),
                'encrypted_iris_buyer' => ' ',
                'encrypted_iris_seller' => ' ',];
            try {
                $txHash = $this->propertyRentalService->addRentalContract($data);
                $rent_contract = new rent_contract;
                $rent_contract->buyer_id = $contract->buyer_id;
                $rent_contract->seller_id = $contract->seller_id;
                $rent_contract->save();

            } catch (Exception $e) {
                return response()->json([
                    'error' => 'Failed to add rental contract: ' . $e->getMessage(),], 500);
            }
        }

        if($room->room_type == 'buy'){
            $contract = temp_buy::where('id',$room->buy_contract_id)->first();
            $property = property::where('property_id' , $contract->property_id)->first();
            $data = [
                'buyer_id' => $contract->buyer_id,
                'seller_id' => $contract->seller_id,
                'property_id' => $contract->property_id,
                'property_location' => $property->property_location,
                'description' => $property->description,
                'total_amount' => $contract->total_amount,
                'paid_amount' => $contract->paid_amount,
                'notes' => $contract->notes,
                'encrypted_iris_buyer' => ' ',
                'encrypted_iris_seller' => ' ',
                'date' => now()->format('d/m/Y'),
            ];
            try {
                $txHash = $this->propertyPurchaseService->addPurchaseContract($data);
                $buy_contract = new buy_contract;
                $buy_contract->buyer_id = $contract->buyer_id;
                $buy_contract->seller_id = $contract->seller_id;
                $buy_contract->save();


            } catch (Exception $e) {
                return response()->json([
                    'error' => 'Failed to add purchase contract: ' . $e->getMessage(),], 500);}
        }

        $room->delete();
        $contract->delete();
        return $this->apiResponse([], 200,'contract created');


    }
}
