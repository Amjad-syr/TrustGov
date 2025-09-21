<?php

namespace App\Http\Controllers;

use App\Services\PropertyRentalService;
use Illuminate\Http\Request;
use Exception;
use App\Models\rent_contract;
use Illuminate\Support\Facades\Validator;

class PropertyRentalController extends Controller
{
    use apiResponse;

    protected $propertyRentalService;

    public function __construct(PropertyRentalService $propertyRentalService)
    {
        $this->propertyRentalService = $propertyRentalService;
    }

    /**
     * @dev POST /rental-contracts/add
     */
    public function addRentalContract(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'buyer_id' => 'required|digits:10',
            'seller_id' => 'required|digits:10',
            'seller_address' => 'required|string',
            'property_id' => 'required|integer',
            'property_location' => 'required|string',
            'encrypted_iris_buyer' => 'required|string',
            'encrypted_iris_seller' => 'required|string',
            'date' => 'required|date_format:d/m/Y',
        ]);

        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $data = $request->all();

        try {
            $txHash = $this->propertyRentalService->addRentalContract($data);
            $rent_contract = new rent_contract;
            $rent_contract->buyer_id = $request->buyer_id;
            $rent_contract->seller_id = $request->seller_id;
            $rent_contract->save();

            return $this->apiResponse($data, 200,'contract created');
        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to add rental contract: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * @dev GET /rental-contracts/{id}
     */
    public function getContractById($id)
    {
        try {
            $contract = $this->propertyRentalService->getContractById($id);

            return $this->apiResponse($contract, 200,'ok');
        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to fetch rental contract: ' . $e->getMessage(),
            ], 500);
        }
    }

}
