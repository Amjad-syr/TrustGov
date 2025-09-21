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
        Schema::create('candidates', function (Blueprint $table) {

              $table->bigInteger('national_id')->primary();
              $table->string('name');
              $table->string('gender');
              $table->unsignedInteger('vote_count')->default(0);
              $table->foreignId("election_id")->constrained("elections")->cascadeOnDelete();

              $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('candidates');
    }
};
