<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class property extends Model
{

    protected $primaryKey = 'property_id';
    public $incrementing = false;
    protected $keyType = 'unsignedBigInteger';

    protected $guarded = [];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
