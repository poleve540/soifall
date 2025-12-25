package main

import rl "vendor:raylib"
import "core:math/rand"

Snowflake :: struct
{
	pos: rl.Vector2,
	scale: f32
}

main :: proc()
{
	rl.SetConfigFlags({
		.WINDOW_UNDECORATED,
		.WINDOW_UNFOCUSED,
		.WINDOW_TOPMOST,
		.WINDOW_TRANSPARENT,
		.WINDOW_MOUSE_PASSTHROUGH,
		.BORDERLESS_WINDOWED_MODE
	})

	monitor := rl.GetCurrentMonitor()
	rl.InitWindow(rl.GetMonitorWidth(monitor), rl.GetMonitorHeight(monitor), "Test")
	rl.SetTargetFPS(rl.GetMonitorRefreshRate(monitor))

	snowflakes: [dynamic]Snowflake
	reserve(&snowflakes, 1024)

	timer: f32
	timer2: f32

	tex := rl.LoadTexture("./soilad_makeup.jpg")

	for !rl.WindowShouldClose()
	{
		timer += rl.GetFrameTime()
		timer2 += rl.GetFrameTime()

		if rl.IsKeyDown(.LEFT)
		{
			for &snowflake in snowflakes
			{
				snowflake.pos.x -= 50
			}
		}
		else if rl.IsKeyDown(.RIGHT)
		{
			for &snowflake in snowflakes
			{
				snowflake.pos.x += 50
			}
		}

		SHAKE_INTERVAL :: 0.5
		for timer2 >= SHAKE_INTERVAL
		{
			timer2 -= SHAKE_INTERVAL
			for &snowflake in snowflakes
			{
				snowflake.pos.x += rand.float32_range(-2, 2)
			}
		}

		for i := 0; i < len(snowflakes); i += 1
		{
			snowflake := &snowflakes[i]
			snowflake.pos.y += 100 * rl.GetFrameTime()
			if snowflake.pos.y >= f32(rl.GetScreenHeight() + 10)
			{
				unordered_remove(&snowflakes, i)
				i -= 1
			}
		}

		SNOWFLAKES_INTERVAL :: 0.1
		for timer >= SNOWFLAKES_INTERVAL
		{
			timer -= SNOWFLAKES_INTERVAL
			new_snowflake := Snowflake{}
			new_snowflake.pos.x = rand.float32_range(0, f32(rl.GetScreenWidth()))
			new_snowflake.scale = rand.float32_range(0.1, 0.2)
			append(&snowflakes, new_snowflake)
		}

		rl.BeginDrawing()

		rl.ClearBackground(rl.BLANK)

			for snowflake in snowflakes
			{
				// rl.DrawCircleV(snowflake.pos, snowflake.radius, rl.WHITE)
				rl.DrawTextureEx(tex, snowflake.pos, 0, snowflake.scale, rl.WHITE)
			}

		rl.EndDrawing()
	}
}
