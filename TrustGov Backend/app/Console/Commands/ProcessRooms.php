<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Room;
use App\Models\temp_buy;
use App\Models\temp_rent;
use Illuminate\Support\Facades\Log;

class ProcessRooms extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'rooms:process';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Process rooms to handle contracts and delete expired ones';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        // Fetch expired rooms
        $expiredRooms = Room::where('expires_at', '<', now())->get();

        foreach ($expiredRooms as $room) {
            try {
                if ($room->room_type === 'buy' && $room->creator_confirmed && $room->joiner_confirmed) {
                    // Handle buy contract
                    $tempBuy = temp_buy::find($room->buy_contract_id);
                    if ($tempBuy) {
                        $this->createBuyContract($tempBuy);
                    }
                } elseif ($room->room_type === 'rent' && $room->creator_confirmed && $room->joiner_confirmed) {
                    // Handle rent contract
                    $tempRent = temp_rent::find($room->rent_contract_id);
                    if ($tempRent) {
                        $this->createRentContract($tempRent);
                    }
                }

                // Delete room and its associated temp record
                $room->delete();

                if ($room->room_type === 'buy') {
                    temp_buy::where('id', $room->buy_contract_id)->delete();
                } elseif ($room->room_type === 'rent') {
                    temp_rent::where('id', $room->rent_contract_id)->delete();
                }

                Log::info("Room {$room->id} processed and deleted successfully.");

            } catch (\Exception $e) {
                Log::error("Failed to process room {$room->id}: " . $e->getMessage());
            }
        }

        return 0;
    }

    /**
     * Create a buy contract.
     */
    private function createBuyContract($tempBuy)
    {
        // Example of creating a buy contract
        try {
            $data = [
                'buyer_id' => $tempBuy->buyer_id,
                'seller_id' => $tempBuy->seller_id,
                'property_id' => $tempBuy->property_id,
                'property_location' => $tempBuy->property_location,
                'description' => $tempBuy->desc,
                'total_amount' => $tempBuy->total_amount,
                'paid_amount' => $tempBuy->paid_amount,
                'notes' => $tempBuy->notes,
                'date' => now(),
                'encrypted_iris_buyer' => ' ',
                'encrypted_iris_seller' => ' ',
            ];

            // Add contract through service
            app()->make('App\Services\PropertyPurchaseService')->addPurchaseContract($data);
            $buy_contract = new buy_contract;
            $buy_contract->buyer_id = $data->buyer_id;
            $buy_contract->seller_id = $data->seller_id;
            $buy_contract->save();

        } catch (\Exception $e) {
            Log::error('Failed to create buy contract: ' . $e->getMessage());
        }
    }

    /**
     * Create a rent contract.
     */
    private function createRentContract($tempRent)
    {
        // Example of creating a rent contract
        try {
            $data = [
                'buyer_id' => $tempRent->buyer_id,
                'seller_id' => $tempRent->seller_id,
                'property_id' => $tempRent->propertiy_id,
                'property_location' => $tempRent->propertiy_loc,
                'seller_address' => $tempRent->seller_address,
                'date' => now(),
                'encrypted_iris_buyer' => ' ',
                'encrypted_iris_seller' => ' ',
            ];

            // Add contract through service
            app()->make('App\Services\PropertyRentalService')->addRentalContract($data);
            $rent_contract = new rent_contract;
            $rent_contract->buyer_id = $data->buyer_id;
            $rent_contract->seller_id = $data->seller_id;
            $rent_contract->save();

        } catch (\Exception $e) {
            Log::error('Failed to create rent contract: ' . $e->getMessage());
        }
    }
}
