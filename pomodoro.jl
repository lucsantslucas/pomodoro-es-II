using Test

mutable struct PomodoroTimer
    work_duration::Int
    break_duration::Int
    completed_cycles::Int
    is_running::Bool
    current_mode::Symbol
end

function PomodoroTimer(work_duration::Int=25, break_duration::Int=5)
    if work_duration <= 0 || break_duration <= 0
        throw(ArgumentError("Durations must be positive integers."))
    end
    return PomodoroTimer(work_duration, break_duration, 0, false, :idle)
end

function start_work!(timer::PomodoroTimer)
    timer.is_running = true
    timer.current_mode = :work
end

function finish_work!(timer::PomodoroTimer)
    if timer.current_mode != :work
        throw(ErrorException("Cannot finish work when not in work mode."))
    end
    timer.completed_cycles += 1
    timer.current_mode = :break
end

function finish_break!(timer::PomodoroTimer)
    timer.current_mode = :idle
    timer.is_running = false
end

function reset_timer!(timer::PomodoroTimer)
    timer.completed_cycles = 0
    timer.is_running = false
    timer.current_mode = :idle
end

# --- Unit Tests ---
@testset "PomodoroTimer Tests" begin
    @testset "1. Initial State" begin
        timer = PomodoroTimer()
        @test timer.completed_cycles == 0
        @test timer.is_running == false
        @test timer.current_mode == :idle
    end

    @testset "2. Start Work Session" begin
        timer = PomodoroTimer()
        start_work!(timer)
        @test timer.is_running == true
        @test timer.current_mode == :work
    end

    @testset "3. Finish Work Session" begin
        timer = PomodoroTimer()
        start_work!(timer)
        finish_work!(timer)
        @test timer.completed_cycles == 1
        @test timer.current_mode == :break
    end

    @testset "4. Finish Break Session" begin
        timer = PomodoroTimer()
        start_work!(timer)
        finish_work!(timer)
        finish_break!(timer)
        @test timer.is_running == false
        @test timer.current_mode == :idle
    end

    @testset "5. Invalid Duration Input" begin
        @test_throws ArgumentError PomodoroTimer(-5, 5)
    end
end
