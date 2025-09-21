<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Carbon\Carbon;

class room extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'creator_national_id',
        'joiner_national_id',
        'room_type',
        'rent_contract_id',
        'buy_contract_id',
        'expires_at',
    ];

    /**
     * Check if the room is expired (now() > expires_at).
     */
    public function isExpired(): bool
    {
        return now()->greaterThan($this->expires_at);
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'creator_national_id', 'national_id');
    }

    public function joiner()
    {
        return $this->belongsTo(User::class, 'joiner_national_id', 'national_id');
    }

    public function temp_rents()
    {
        return $this->belongsTo(temp_rent::class, 'rent_contract_id');
    }

    public function temp_buys()
    {
        return $this->belongsTo(temp_buy::class, 'buy_contract_id');
    }
}
