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
        Schema::create('complaint_votes', function (Blueprint $table) {
            $table->unsignedInteger('user_id');
            $table->foreign('user_id')->references('national_id')->on('users')->cascadeOnDelete();
            $table->foreignId("complaint_id")->constrained("complaints")->cascadeOnDelete();
            $table->boolean('type');
            $table->timestamps();
            $table->primary(['user_id', 'complaint_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('complaint_votes');
    }
};
