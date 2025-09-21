<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Arr;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $resourceArray = parent::toArray($request);


        return Arr::except($resourceArray, ['created_at', 'updated_at','iris_sample_path','voice_sample_path','password']);
       }
}
