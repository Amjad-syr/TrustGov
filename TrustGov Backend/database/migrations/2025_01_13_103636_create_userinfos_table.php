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
        Schema::create('userinfos', function (Blueprint $table) {
            $table->unsignedInteger('national_id')->primary();
            $table->string('first_name');
            $table->string('last_name');
            $table->string('father_name');
            $table->string('mother_full_name');
            $table->date('birth_date');
            $table->integer('id_number')->unique();
            $table->string('special_features');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('userinfos');
    }
};
