<?php

use App\Livewire\Counter;
use Livewire\Livewire;
use Tests\TestCase;

class CounterTest extends TestCase
{
    /** @test */
    public function it_increments_count()
    {
        Livewire::test(Counter::class)
            ->call('increment')
            ->assertSet('count', 1);
    }
}