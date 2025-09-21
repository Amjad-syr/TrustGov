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
        Schema::create('rooms', function (Blueprint $table) {
                $table->id();

                $table->string('code')->unique();

                $table->unsignedInteger('creator_national_id');
                $table->foreign('creator_national_id')->references('national_id')->on('users')->cascadeOnDelete();

                $table->unsignedInteger('joiner_national_id')->nullable();
                $table->foreign('joiner_national_id')->references('national_id')->on('users')->cascadeOnDelete();

                $table->enum('room_type', ['rent', 'buy']);

                $table->unsignedBigInteger('rent_contract_id')->nullable();
                $table->foreign('rent_contract_id')->references('id')->on('temp_rents')->cascadeOnDelete();

                $table->unsignedBigInteger('buy_contract_id')->nullable();
                $table->foreign('buy_contract_id')->references('id')->on('temp_buys')->cascadeOnDelete();
                $table->boolean('creator_confirmed')->default(false);
                $table->boolean('joiner_confirmed')->default(false);

                $table->dateTime('expires_at');

                $table->timestamps();

            });

    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rooms');
    }
};
