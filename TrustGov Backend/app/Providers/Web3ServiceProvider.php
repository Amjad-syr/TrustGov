<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Web3\Web3;

class Web3ServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton(Web3::class, function ($app) {
            return new Web3(env('QUORUM_RPC_URL'));
        });
    }
}
