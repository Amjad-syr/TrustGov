<?php

namespace App\Services;

use Web3\Web3;
use Web3\Contract;
use Web3\Providers\HttpProvider;
use React\EventLoop\Factory;
use React\Promise\Deferred;
use Illuminate\Support\Facades\Log;
use Exception;

class PropertyRentalService
{
    protected $web3;
    protected $contract;
    protected $loop;
    protected $options;

    public function __construct()
    {
        $this->loop = Factory::create();

        $provider = new HttpProvider(env('QUORUM_RPC_URL'), 30);
        $this->web3 = new Web3($provider);

        $abiPath = storage_path('abis/PropertyRental.abi');
        if (!file_exists($abiPath)) {
            throw new Exception("PropertyRental ABI file not found at $abiPath");
        }
        $abi = json_decode(file_get_contents($abiPath), true);
        if (!$abi) {
            throw new Exception("Failed to parse ABI JSON for PropertyRental");
        }

        // 4. Contract Address
        $contractAddress = env('PROPERTY_RENTAL_CONTRACT_ADDRESS');
        if (!$contractAddress) {
            throw new Exception("PROPERTY_RENTAL_CONTRACT_ADDRESS not set in .env");
        }

        // 5. Instantiate Contract
        $this->contract = new Contract($provider, $abi);
        $this->contract->at($contractAddress);

        // 6. Transaction Options
        $account = env('QUORUM_PUBLIC_KEY');
        $privateKey = env('QUORUM_PRIVATE_KEY');
        if (!$account) {
            throw new Exception('QUORUM_PUBLIC_KEY and QUORUM_PRIVATE_KEY must be set in .env');
        }

        $this->options = [
            'from' => $account,
            'gas' => '0x' . dechex(3000000),
            'gasPrice' => '0x0',
        ];
    }

    /**
     * @dev Create a new rental contract by sending a transaction to addRentalContract.
     */
    public function addRentalContract(array $data)
    {
        $deferred = new Deferred();



        // Send transaction
        $this->contract->send('addRentalContract',   (int)$data['buyer_id'],
            (int)$data['seller_id'],
            $data['seller_address'],
            (int)$data['property_id'],
            $data['property_location'],
            $data['encrypted_iris_buyer'],
            $data['encrypted_iris_seller'],
            $data['date'], $this->options, function ($err, $tx) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }
            $deferred->resolve($tx);
        });

        $this->loop->run();

        // Resolve or throw
        $resolvedResult = null;
        $deferred->promise()->then(function ($txHash) use (&$resolvedResult) {
            $resolvedResult = $txHash;
        });

        if ($resolvedResult === null) {
            throw new Exception('Failed to send rental contract transaction');
        }

        return $resolvedResult;
    }

    /**
     * @dev Retrieves a rental contract by ID, returning a structured array.
     */
    public function getContractById($id)
    {
        $deferred = new Deferred();

        $this->contract->call('getContractById', (int)$id, function ($err, $result) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error calling getContractById: ' . $err->getMessage()));
                return;
            }
            Log::info($result);
            try {
                // The contract returns a tuple in the same order as defined
                $contract = [
                    'id' => $this->convertBigInteger($result['id']),
                    'buyer_id' => $this->convertBigInteger($result['buyer_id']),
                    'seller_id' => $this->convertBigInteger($result['seller_id']),
                    'seller_address' => $result['seller_address'],
                    'property_id' => $this->convertBigInteger($result['property_id']),
                    'property_location' => $result['property_location'],
                    'encrypted_iris_buyer' => $result['encrypted_iris_buyer'],
                    'encrypted_iris_seller' => $result['encrypted_iris_seller'],
                    'date' => $result['date'],
                ];

                $deferred->resolve($contract);
            } catch (Exception $e) {
                $deferred->reject(new Exception('Failed to parse rental contract data: ' . $e->getMessage()));
            }
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($val) use (&$resolvedResult) {
            $resolvedResult = $val;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to fetch rental contract data");
        }

        return $resolvedResult;
    }



    private function convertBigInteger($value)
    {
        if ($value instanceof \phpseclib\Math\BigInteger) {
            return intval($value->toString());
        } elseif (is_array($value) && isset($value['value'])) {
            return intval($value['value']);
        }
        return intval($value);
    }
}
