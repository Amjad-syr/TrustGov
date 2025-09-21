<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Exception;
use App\Models\complaint;
use App\Models\complaint_vote;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\File;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class ComplaintController extends Controller
{
    use apiResponse;

      public function getAllComplaints()
      {
        $complaints = complaint::all();
        return $this->apiResponse($complaints,200,'ok');
      }
      public function getPendingComplaints()
      {
        $complaints = complaint::all()->where('status','pending');
        return $this->apiResponse($complaints,200,'ok');
      }
      public function getApprovedComplaints()
      {
        $complaints = complaint::all()->where('status','approved');
        return $this->apiResponse($complaints,200,'ok');
      }
      public function getDeniedComplaints()
      {
        $complaints = complaint::all()->where('status','denied');
        return $this->apiResponse($complaints,200,'ok');
      }
      public function getDoneComplaints()
      {
        $complaints = complaint::all()->where('status','done');
        return $this->apiResponse($complaints,200,'ok');
      }

      public function changestatus(Request $request)
      {
        $validator = Validator::make($request->all(), [
            'complaint_id' => 'required|integer|exists:complaints,id',
            'status' => 'required|string|in:pending,approved,denied,done',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        $complaint = complaint::findorfail($request->complaint_id)->first();
        if ( $complaint->status == 'done'){
            return $this->apiResponse([], 400,'complaint is already done');

        }
        $complaint->status = $request->status;
        $complaint->save();

        return $this->apiResponse($complaint,200,'ok');
      }

      public function createComplaint(Request $request)
      {

        $validator = Validator::make($request->all(), [
            'picture1' => 'required|file|mimes:jpg,jpeg,png',
            'picture2' => 'required|file|mimes:jpg,jpeg,png',
            'desc' => 'required|string',
            'location' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 400, 'Validation error');
          }

        $user = Auth::user();
        $user_roles = $user->user_roles()->get();
        if (!$user_roles->contains('role', 'mikhtar')) {
            return $this->apiResponse([], 400, 'user is not mikhtar');
        }
        $picturePath1 = $request->file('picture1')->store('complaints', 'public');
        $fullPicturePath1 = url('storage/' . $picturePath1);

        $picturePath2 = $request->file('picture2')->store('complaints', 'public');
        $fullPicturePath2 = url('storage/' . $picturePath2);

        $complaint = new Complaint();
        $complaint->user_id       = $user->national_id;
        $complaint->desc          = $request->desc;
        $complaint->location      = $request->location;
        $complaint->picture_path1 = $fullPicturePath1;
        $complaint->picture_path2 = $fullPicturePath2;
        $complaint->save();

        return $this->apiResponse($complaint, 200, 'ok');
      }


      public function ComplaintVote(Request $request)
      {

        $validator = Validator::make($request->all(), [
            'complaint_id' => 'required|integer|exists:complaints,id',
            'type' => 'required|boolean',
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 400, 'Validation error');
        }

        $complaint = complaint::findOrFail($request->complaint_id);
        $user = Auth::user();
        $vote = complaint_vote::where('user_id', $user->national_id)
        ->where('complaint_id', $request->complaint_id)
        ->first();

        if ($vote) {
            if ((bool)$vote->type != (bool)$request->type) {
                $complaint->total_votes += (bool)$request->type ? 2 : -2;
                $vote->type = $request->type;
                $vote->user_id = $user->national_id;
                $vote->save();
                $complaint->save();
                return $this->apiResponse([], 200, 'Vote updated');

            }
            return $this->apiResponse([], 200, 'No change in vote');
        }
        $vote = new complaint_vote;
        $vote->user_id = $user->national_id;
        $vote->complaint_id = $request->complaint_id;
        $vote->type = $request->type;
        $vote->save();

        if ($vote->type == 1){
            $complaint->total_votes +=1;
        }else{
            $complaint->total_votes -=1;

        }
        $complaint->save();
        return $this->apiResponse([], 200, 'vote casted');
      }

}
