<?php

namespace App\Services;

use Web3\Contract;
use Web3\Web3;
use Illuminate\Support\Facades\Log;
use Web3\Providers\HttpProvider;
use React\EventLoop\Factory;
use React\Promise\Deferred;
use Exception;

class PropertyPurchaseService
{
    protected $web3;
    protected $contract;
    protected $contractAddress;
    protected $loop;
    protected $options;
    protected $account;
    protected $privateKey;

    public function __construct()
    {
        $this->loop = Factory::create();

        $provider = new HttpProvider(env('QUORUM_RPC_URL'), 30);
        $this->web3 = new Web3($provider);

        $abiPath = storage_path('abis\PropertyPurchase.abi');
        if (!file_exists($abiPath)) {
            throw new Exception("ABI file not found at $abiPath");
        }

        $abi = json_decode(file_get_contents($abiPath), true);
        if (!$abi) {
            throw new Exception("Failed to parse ABI JSON");
        }

        $this->contractAddress = env('PROPERTY_PURCHASE_CONTRACT_ADDRESS');
        if (!$this->contractAddress) {
            throw new Exception("Contract address is not set.");
        }

        $this->contract = new Contract($provider, $abi);
        $this->contract->at($this->contractAddress);

        $this->account = env('QUORUM_PUBLIC_KEY');
        $this->privateKey = env('QUORUM_PRIVATE_KEY');

        if (!$this->account) {
            throw new Exception('Please set QUORUM_PUBLIC_KEY and QUORUM_PRIVATE_KEY in your .env file.');
        }

        $this->options = [
            'from' => $this->account,
            'gas' => '0x' . dechex(3000000),
            'gasPrice' => '0x0',
        ];

    }

    public function addPurchaseContract($data)
    {
        $deferred = new Deferred();



        $this->contract->send("addPurchaseContract", (int)$data['buyer_id'],
            (int)$data['seller_id'],
            (int)$data['property_id'],
            $data['property_location'],
            $data['description'],
            (int)$data['total_amount'],
            (int)$data['paid_amount'],
            $data['notes'],
            $data['encrypted_iris_buyer'],
            $data['encrypted_iris_seller'],
            $data['date'], $this->options, function ($err, $tx) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }
            $deferred->resolve($tx);
        });

        $loop = Factory::create();
        $loop->run();

        return $deferred->promise();
    }

    public function getContractById($id)
    {
        $deferred = new Deferred();

        $this->contract->call('getContractById', (int)$id, function ($err, $result) use ($deferred) {
            if ($err !== null) {
                Log::error('Error in contract call: ' . $err->getMessage());
                $deferred->reject(new Exception('Error calling contract: ' . $err->getMessage()));
                return;
            }

            try {
                // Parse the result and convert BigInteger fields to integers
                $contract = [
                    'id' => $this->convertBigInteger($result['id']),
                    'buyer_id' => $this->convertBigInteger($result['buyer_id']),
                    'seller_id' => $this->convertBigInteger($result['seller_id']),
                    'property_id' => $this->convertBigInteger($result['property_id']),
                    'property_location' => $result['property_location'],
                    'description' => $result['description'],
                    'total_amount' => $this->convertBigInteger($result['total_amount']),
                    'paid_amount' => $this->convertBigInteger($result['paid_amount']),
                    'notes' => $result['notes'],
                    'encrypted_iris_buyer' => $result['encrypted_iris_buyer'],
                    'encrypted_iris_seller' => $result['encrypted_iris_seller'],
                    'date' => $result['date'],
                ];

                $deferred->resolve($contract);
            } catch (Exception $e) {
                Log::error("Failed to parse contract data: " . $e->getMessage());
                $deferred->reject(new Exception('Failed to parse contract data: ' . $e->getMessage()));
            }
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to fetch contract data.");
        }

        return $resolvedResult;
    }


    private function convertBigInteger($bigInteger)
    {
        if ($bigInteger instanceof \phpseclib\Math\BigInteger) {
            return intval($bigInteger->toString());
        } elseif (is_array($bigInteger) && isset($bigInteger['value'])) {
            return intval($bigInteger['value']);
        } else {
            return intval($bigInteger); // Handle normal integers
        }
    }


}
