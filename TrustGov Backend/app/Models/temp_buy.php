<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;
class temp_buy extends Model
{
    protected $guarded = [];


    public function property(): HasOne
    {
        return $this->hasOne(property::class);
    }
}
