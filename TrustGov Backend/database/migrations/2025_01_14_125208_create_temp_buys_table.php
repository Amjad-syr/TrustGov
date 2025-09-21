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
        Schema::create('temp_buys', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('buyer_id')->nullable();
            $table->foreign('buyer_id')->references('national_id')->on('users')->cascadeOnDelete();
            $table->unsignedInteger('seller_id');
            $table->foreign('seller_id')->references('national_id')->on('users')->cascadeOnDelete();
            $table->unsignedBigInteger('property_id');
            $table->foreign('property_id')->references('property_id')->on('properties')->cascadeOnDelete();
            $table->integer('total_amount');
            $table->integer('paid_amount');
            $table->string('notes');
            $table->dateTime('date');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('temp_buys');
    }
};
