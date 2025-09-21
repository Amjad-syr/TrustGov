<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\JWTException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->web(append: [
            \App\Http\Middleware\HandleInertiaRequests::class,
            \Illuminate\Http\Middleware\AddLinkHeadersForPreloadedAssets::class,
        ]);

        //
    })
    ->withExceptions(function (Exceptions $exceptions) {

        // $exceptions->shouldRenderJsonWhen(function (Request $request, Throwable $e) {
        //     if ($request->is('api/*')) {
        //         return true;
        //     }
        // });
        $exceptions->renderable(function (TokenExpiredException $e, Request $request) {
            return response()->json(['error' => 'Token has expired'], 401);
        });

        $exceptions->renderable(function (TokenInvalidException $e, Request $request) {
            return response()->json(['error' => 'Token is invalid'], 400);
        });

        $exceptions->renderable(function (JWTException $e, Request $request) {
            return response()->json(['error' => 'Token is missing or malformed'], 401);
        });

    })->create();
