<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class candidate extends Model
{
    protected $table = 'candidates';

    protected $primaryKey = 'national_id';

    public $incrementing = false;

    protected $fillable = [
        'national_id',
        'name',
        'gender',
        'vote_count',
        'election_id',
    ];
}
