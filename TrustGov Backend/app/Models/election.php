<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class election extends Model
{
    protected $fillable = [
        'name',
        'start_date',
        'end_date',
        'status',
    ];

    public function candidates(): HasMany
    {
        return $this->hasMany(candidate::class);
    }
}
