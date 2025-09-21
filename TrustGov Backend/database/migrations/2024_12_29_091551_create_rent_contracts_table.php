<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rent_contracts', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('buyer_id');
            $table->foreign('buyer_id')->references('national_id')->on('users')->cascadeOnDelete();
            $table->unsignedInteger('seller_id');
            $table->foreign('seller_id')->references('national_id')->on('users')->cascadeOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rent_contracts');
    }
};
