<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class userinfo extends Model
{
    protected $primaryKey = 'national_id';
    public $incrementing = false;
    protected $keyType = 'integer';

    protected $guarded = [];

}
