<?php

namespace App\Http\Controllers;

use App\Services\PropertyPurchaseService;
use Illuminate\Http\Request;
use Exception;
use Illuminate\Support\Facades\Log;
use App\Models\buy_contract;
use Illuminate\Support\Facades\Validator;


class PropertyPurchaseController extends Controller
{
    use apiResponse;

    protected $propertyPurchaseService;

    public function __construct(PropertyPurchaseService $propertyPurchaseService)
    {
        $this->propertyPurchaseService = $propertyPurchaseService;
    }

    public function addPurchaseContract(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'buyer_id' => 'required|digits:10', //|exists:users,national_id
            'seller_id' => 'required|digits:10',
            'property_id' => 'required|integer',
            'property_location' => 'required|string',
            'description' => 'required|string',
            'total_amount' => 'required|integer',
            'paid_amount' => 'required|integer',
            'notes' => 'required|string',
            'encrypted_iris_buyer' => 'required|string',
            'encrypted_iris_seller' => 'required|string',
            'date' => 'required|date_format:d/m/Y',
        ]);

        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $data = $request->all();

        try {
            $txHash = $this->propertyPurchaseService->addPurchaseContract($data);
            $buy_contract = new buy_contract;
            $buy_contract->buyer_id = $request->buyer_id;
            $buy_contract->seller_id = $request->seller_id;
            $buy_contract->save();

            return $this->apiResponse($data, 200,'contract created');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to add purchase contract: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function getContractById($id)
    {
        try {
            $contract = $this->propertyPurchaseService->getContractById($id);

            return $this->apiResponse($contract, 200,'ok');
        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to fetch contract: ' . $e->getMessage(),
            ], 500);
        }
    }
}
