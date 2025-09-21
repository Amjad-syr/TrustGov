<?php

namespace App\Http\Middleware;

use Closure;
use React\EventLoop\LoopInterface;

class EventLoopMiddleware
{
    protected $loop;

    public function __construct(LoopInterface $loop)
    {
        $this->loop = $loop;
    }

    public function handle($request, Closure $next)
    {
        $response = $next($request);

        // Run the event loop
        $this->loop->run();

        return $response;
    }
}
