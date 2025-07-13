package main

import "core:fmt"

import "entity"
import rl "vendor:raylib"

main :: proc() {
	// Window constants
	SCREEN_WIDTH :: 800
	SCREEN_HEIGHT :: 450
	TARGET_FPS :: 60
	// Physics constants
	GRAVITY :: 10
	// Entity constants


	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Run, run, run as fast as you can")
	rl.SetTargetFPS(TARGET_FPS)
	defer rl.CloseWindow()


	// Load textures/animations/shaders
	player_texture := rl.LoadTexture("assets/scarfy.png")
	defer rl.UnloadTexture(player_texture)


	tag_map := make(map[string]entity.Entity)
	defer delete(tag_map)

	ecs: entity.EntityComponentSystem
	ecs.boundry = rl.Vector2{SCREEN_WIDTH, SCREEN_HEIGHT}
	ecs.gravity = GRAVITY
	ecs.tag_map = tag_map
	e := entity.get_entity(&ecs, "scarfy")
	player := entity.Animation {
		texture = &player_texture,
		frame_box = rl.Rectangle {
			x = 0,
			y = 0,
			width = f32(player_texture.width) / 6,
			height = f32(player_texture.height),
		},
		n_col = 6,
		n_row = 1,
		i_row = 0,
		i_col = 0,
		continuous = true,
		finished = false,
		frame_time = 0.0,
		frame_duration = 0.25,
	}
	ecs.position[e] = rl.Vector2 {
		f32(SCREEN_WIDTH) / 2 - player.frame.width / 2,
		f32(SCREEN_HEIGHT) - player.frame.height,
	}
	ecs.speed[e] = rl.Vector2{100, 100}
	ecs.animation[e] = player


	// Main game loop
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		entity.handle_input(&ecs)
		entity.movement(&ecs)
		entity.collision(&ecs)
		entity.animate(&ecs)
		rl.EndDrawing()
	}
}
