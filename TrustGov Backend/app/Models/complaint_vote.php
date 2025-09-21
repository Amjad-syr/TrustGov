<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class complaint_vote extends Model
{
    public $incrementing = false;

    protected $primaryKey = null;

    protected function setKeysForSaveQuery($query)
    {
        return $query->where('user_id', $this->getAttribute('user_id'))
                     ->where('complaint_id', $this->getAttribute('complaint_id'));
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'national_id');
    }

    public function complaint()
    {
        return $this->belongsTo(complaint::class, 'complaint_id');
    }
}
