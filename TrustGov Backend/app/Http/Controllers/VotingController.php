<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Log;
use App\Services\VotingService;
use Illuminate\Http\Request;
use Exception;
use App\Models\election;
use App\Models\candidate;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use App\Models\election_vote;
use Illuminate\Support\Facades\Auth;

class VotingController extends Controller
{
    use apiResponse;

    protected $votingService;

    public function __construct(VotingService $votingService)
    {
        $this->votingService = $votingService;
    }

    public function createElection(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|between:2,25|unique:elections',
            'start_date' => 'required|date',
            'end_date' => 'required|date',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $name = $request->input('name');

        try {
            $txHash = $this->votingService->createElection($name);
            $election = new election;
            $election->name = $request->name;
            $election->start_date = $request->start_date;
            $election->end_date = $request->end_date;
            $election->save();

            return $this->apiResponse($election,200,'ok');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to create election: ' . $e->getMessage(),
            ], 500);
        }
    }


    // Add Candidate
    public function addCandidate(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $validator = Validator::make($request->all(), [
            'national_id' => 'required|integer|digits:11|unique:candidates,national_id',
            'name' => 'required|string|between:5,35',
            'election_id' => 'required|integer|exists:elections,id',
            'gender' => 'required|string|in:male,female',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $electionId = $request->input('election_id');
        $name = $request->input('name');
        $national_id = $request->input('national_id');

        try {
            $txHash = $this->votingService->addCandidate($electionId, $name,$national_id);
            $candidate = new candidate;
            $candidate->national_id = $national_id;
            $candidate->name = $request->name;
            $candidate->election_id = $request->election_id;
            $candidate->gender = $request->gender;
            $candidate->save();

            return $this->apiResponse($candidate,200,'ok');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to add candidate: ' . $e->getMessage(),
            ], 500);
        }
    }

    // Start Election
    public function startElection(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $electionId = $request->input('election_id');
        $election= election::findorfail($electionId);

        if($election->status == 2){
            return $this->apiResponse([], 400,'election already ended');
        }
        if($election->status == 1){
            return $this->apiResponse([], 400,'election already started');
        }
        if($election->candidates()->count() < 2){
            return $this->apiResponse([], 400,'election has less than 2 candidates');
        }
        try {
            $txHash = $this->votingService->startElection($electionId);
            $election->status = 1;
            $election->save();
            return $this->apiResponse([], 200,'election strated');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to start election: ' . $e->getMessage(),
            ], 500);
        }
    }

    // End Election
    public function endElection(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $electionId = $request->input('election_id');
        $election= election::findorfail($electionId);
        if($election->status == 0){
            return $this->apiResponse([], 400,'election is not running');
        }
        if($election->status == 2){
            return $this->apiResponse([], 400,'election already ended');
        }
        try {
            $txHash = $this->votingService->endElection($electionId);
            $election->status = 2;
            $election->save();
            return $this->apiResponse([], 200,'election ended');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to end election: ' . $e->getMessage(),
            ], 500);
        }
    }
    public function deleteElection(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $electionId = $request->input('election_id');
        $election = election::where('id',$electionId)->first();
        if ($election->status != 0){
            return $this->apiResponse([], 400,'election has started or ended');
        }
        try {
            $txHash = $this->votingService->deleteElection($electionId);
            election::findorfail($electionId)->delete();
            return $this->apiResponse([], 200,'election deleted');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to delete election: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function deleteCandidate(Request $request)
    {
        $user = Auth::user();
        if (!$user->role) {
            return $this->apiResponse(null,400,'not super admin');
        }
        $electionId = $request->input('election_id');
        $national_id = $request->input('national_id');
        $election = election::where('id',$electionId)->first();
        if ($election->status != 0){
            return $this->apiResponse([], 400,'election has started or ended');
        }
        try {
            $txHash = $this->votingService->deleteCandidate($electionId,$national_id);
            candidate::get()->where('national_id',$national_id)->first()->delete();
            return $this->apiResponse([], 200,'candidate deleted');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to delete candidate: ' . $e->getMessage(),
            ], 500);
        }
    }

    // Vote
    public function vote(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'election_id' => 'required|integer|exists:elections,id',
            'candidate_id' => 'required|integer|exists:candidates,national_id',
        ]);

        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $user = Auth::user();
        $electionId = $request->input('election_id');
        $candidateId = $request->input('candidate_id');
        $voterId = $user->national_id;

        try {
            $txHash = $this->votingService->vote($electionId, $candidateId, $voterId);

            $vote = new election_vote;
            $vote->election_id = $electionId;
            $vote->candidate_id = $candidateId;
            $vote->user_id = $voterId;
            $vote->save();
            return $this->apiResponse([], 200,'Vote casted');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to cast vote: ' . $e->getMessage(),
            ], 500);
        }
    }


    public function hasVoted($electionId)
    {
        $voterId = Auth::user()->id;
        try {
            $hasVoted = $this->votingService->hasVoted($electionId, $voterId);

            return $this->apiResponse($hasVoted, 200,'ok');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to check if voter has voted: ' . $e->getMessage(),
            ], 500);
        }
    }

    // Get All Candidates
    public function getAllCandidates($electionId)
    {
        try {
            $candidates = $this->votingService->getAllCandidates($electionId);

            return $this->apiResponse($candidates,200,'ok');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to get candidates: ' . $e->getMessage(),
            ], 500);
        }
    }

    //Get Active Elections
    public function getActiveElections()
    {

        try {
            $activeElections = $this->votingService->getActiveElections();

            return $this->apiResponse($activeElections,200,'ok');

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to get active elections: ' . $e->getMessage(),
            ], 500);
        }
    }
    public function getAllElections()
    {
        try {
            $elections = $this->votingService->getAllElections();

            $filteredElections = array_filter($elections, function ($election) {
                return isset($election['id']) && $election['id'] !== 0;
            });

            $filteredElections = array_values($filteredElections);

            return $this->apiResponse($filteredElections, 200, 'ok');
        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to get elections: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function getLatestElection()
    {

        try {
            $activeElections = $this->votingService->getActiveElections();

            if (empty($activeElections)) {
                return response()->json([
                    'error' => 'No active election found',
                ], 404);
            }
            $activeElections = array_values($activeElections);
            $election = end($activeElections);

            try {
                $dbElection = election::where('id', $election['id'])->first();

                if (! $dbElection) {
                    return response()->json([
                        'error' => 'Election not found in DB',
                    ], 404);
                }

                $election['start_date'] = $dbElection->end_date;
                $election['end_date'] = $dbElection->end_date;

                $candidates = $this->votingService->getAllCandidates($election['id']);

                $totalVotes = 0;
                foreach ($candidates as $candidate) {
                    $totalVotes += $candidate['votes'] ?? 0;
                }

                $usersCount = User::count();

                return $this->apiResponse([
                    'election'    => $election,
                    'candidates'  => $candidates,
                    'totalvotes'  => $totalVotes,
                    'usercount'   => $usersCount
                ], 200, 'ok');

            } catch (Exception $e) {
                return response()->json([
                    'error' => 'Failed to get candidates: ' . $e->getMessage(),
                ], 500);
            }

        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to get elections: ' . $e->getMessage(),
            ], 500);
        }
    }
    public function getElection($electionId)
    {
        try {
            $election = $this->votingService->getElectionById($electionId);
            return $this->apiResponse($election,200,'ok');


        } catch (Exception $e) {
            return response()->json([
                'error' => 'Failed to get election: ' . $e->getMessage(),
            ], 500);
        }
    }


}
