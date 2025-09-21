<?php

namespace App\Services;

use Web3\Web3;
use Illuminate\Support\Facades\Log;
use Web3\Contract;
use Web3\Providers\HttpProvider;
use React\EventLoop\Factory;
use React\Promise\Deferred;
use Exception;
use phpseclib3\Math\BigInteger;

class VotingService
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

        $abiPath = storage_path('abis\Voting.abi');
        if (!file_exists($abiPath)) {
            throw new Exception("ABI file not found at $abiPath");
        }

        $abi = json_decode(file_get_contents($abiPath), true);
        if (!$abi) {
            throw new Exception("Failed to parse ABI JSON");
        }

        $this->contractAddress = env('VOTING_CONTRACT_ADDRESS');
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

    // Create Election
    public function createElection($name)
    {
        $deferred = new Deferred();

        $this->contract->send("createElection", $name, $this->options, function ($err, $tx) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }
            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
        }

    // Add Candidate
    public function addCandidate($electionId, $name ,$national_id)
    {
        $deferred = new Deferred();
        Log::info($electionId);
        Log::info($name);
        Log::info($national_id);

        $this->contract->send("addCandidate", (int)$electionId, $name,(int)$national_id,$this->options, function ($err, $tx) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }

            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
     }

    // Start Election
    public function startElection($electionId)
    {

        $deferred = new Deferred();


        $this->contract->send("startElection", (int)$electionId,$this->options, function ($err, $tx) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }

            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
    }

    // End Election
    public function endElection($electionId)
    {
        $deferred = new Deferred();

        $this->contract->send("endElection", (int)$electionId,$this->options, function ($err, $tx) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }

            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
    }

    public function deleteElection($electionId)
    {

        $deferred = new Deferred();


        $this->contract->send("deleteElection", (int)$electionId,$this->options, function ($err, $tx) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }

            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
    }
    public function deleteCandidate($electionId,$national_id)
    {

        $deferred = new Deferred();


        $this->contract->send("deleteCandidate", (int)$electionId,(int)$national_id,$this->options, function ($err, $tx) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }

            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
    }
    // Vote
    public function vote($electionId, $candidateId, $voterId)
    {
        $deferred = new Deferred();

        $this->contract->send("vote", (int)$electionId, (int)$candidateId,(int) $voterId,$this->options, function ($err, $tx) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error sending transaction: ' . $err->getMessage()));
                return;
            }

            $deferred->resolve($tx);
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to send transaction.");
        }

        return $resolvedResult;
    }

    public function hasVoted($electionId, $voterId)
    {
        $deferred = new Deferred();

        $this->contract->call('hasVoted', (int)$electionId, (int)$voterId, function ($err, $result) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error calling contract: ' . $err->getMessage()));
                return;
            }
            try {
                // Parse the result as a boolean
                $hasVoted = (bool)$result[0];

                $deferred->resolve($hasVoted);
            } catch (Exception $e) {
                $deferred->reject(new Exception('Failed to parse hasVoted result: ' . $e->getMessage()));
            }
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to fetch voting status.");
        }

        return $resolvedResult;
    }




    public function getAllCandidates($electionId)
    {
        $deferred = new Deferred();

        $this->contract->call('getAllCandidates', (int)$electionId, function ($err, $result) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error calling contract: ' . $err->getMessage()));
                return;
            }


            try {
                $candidates = [];
                $names = $result['names'];
                $votes = $result['votes'];
                $nationalIds = $result['nationalIds'];

                for ($i = 0; $i < count($names); $i++) {
                    $voteCount = $votes[$i];
                    $nationalId = $nationalIds[$i];

                    if ($voteCount instanceof \phpseclib\Math\BigInteger) {
                        $voteCount = intval($voteCount->toString());
                    }
                    if ($nationalId instanceof \phpseclib\Math\BigInteger) {
                        $nationalId = intval($nationalId->toString());
                    }
                    $candidates[] = [
                        'name' => $names[$i],
                        'votes' => $voteCount,
                        'National_Id' => $nationalId,
                    ];
                }

                $deferred->resolve($candidates);
            } catch (Exception $e) {
                $deferred->reject(new Exception('Failed to parse candidates: ' . $e->getMessage()));
            }
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to fetch candidates.");
        }

        return $resolvedResult;
    }


    // Get All Elections
    public function getAllElections()
    {
        return $this->parseElectionData('getAllElections');
    }

    //Get Active Elections
    public function getActiveElections()
    {

        return $this->parseElectionData('getActiveElections');
    }

    public function getElectionById($electionId)
    {
        $deferred = new Deferred();

        $this->contract->call('getElectionById', $electionId, function ($err, $result) use ($deferred) {
            if ($err !== null) {
                $deferred->reject(new Exception('Error calling contract: ' . $err->getMessage()));
                return;
            }

            try {

                $election = [
                    'id' => $this->convertBigInteger($result['id']),
                    'name' => $result['name'],
                    'candidatesCount' => $this->convertBigInteger($result['candidatesCount']),
                    'isActive' => (bool)$result['isActive'],
                    'hasEnded' => (bool)$result['hasEnded'],
                ];

                $deferred->resolve($election);
            } catch (Exception $e) {
                $deferred->reject(new Exception('Failed to parse election data: ' . $e->getMessage()));
            }
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to fetch election data.");
        }

        return $resolvedResult;
    }


    // Helper: Parse Election Data
    private function parseElectionData($method)
    {

        $deferred = new Deferred();

        $this->contract->call($method, [], function ($err, $result) use ($deferred) {

            if ($err !== null) {
                $deferred->reject(new Exception('Error calling contract: ' . $err->getMessage()));
                return;
            }

            try {
                // Extract individual arrays from the result
                $ids = $result[0];
                $names = $result[1];
                $candidatesCounts = $result[2];
                $isActiveArray = $result[3];
                $hasEndedArray = $result[4];
                $owners = $result[5];

                // Convert the data into a structured array
                $elections = [];
                for ($i = 0; $i < count($ids); $i++) {
                    $elections[] = [
                        'id' => $this->convertBigInteger($ids[$i]),
                        'name' => $names[$i],
                        'candidatesCount' => $this->convertBigInteger($candidatesCounts[$i]),
                        'isActive' => (bool)$isActiveArray[$i],
                        'hasEnded' => (bool)$hasEndedArray[$i],
                        'owner' => $owners[$i],
                    ];
                }

                $deferred->resolve($elections);
            } catch (Exception $e) {
                $deferred->reject(new Exception('Failed to parse elections result: ' . $e->getMessage()));
            }
        });

        $this->loop->run();

        $resolvedResult = null;
        $deferred->promise()->then(function ($result) use (&$resolvedResult) {
            $resolvedResult = $result;
        });

        if ($resolvedResult === null) {
            throw new Exception("Failed to fetch election data.");
        }

        return $resolvedResult;
    }




    // Helper: Parse BigInteger to Integer
    private function convertBigInteger($bigInteger)
    {
        if ($bigInteger instanceof \phpseclib\Math\BigInteger) {
            return intval($bigInteger->toString());
        } elseif (is_array($bigInteger) && isset($bigInteger['value'])) {
            return intval($bigInteger['value']);
        } else {
            throw new Exception('Invalid BigInteger format: ' . json_encode($bigInteger));
        }
    }



}
