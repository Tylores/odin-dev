package entity

import "core:fmt"
import rl "vendor:raylib"

Entity :: u32
MAX_ENTITIES: Entity : 10


EntityComponentSystem :: struct {
	boundry:      rl.Vector2,
	gravity:      f32,
	tag_map:      map[string]Entity,
	active:       [MAX_ENTITIES]bool,
	grounded:     [MAX_ENTITIES]bool,
	position:     [MAX_ENTITIES]rl.Vector2,
	speed:        [MAX_ENTITIES]rl.Vector2,
	velocity:     [MAX_ENTITIES]rl.Vector2,
	acceleration: [MAX_ENTITIES]rl.Vector2,
	animation:    [MAX_ENTITIES]Animation,
	sound:        [MAX_ENTITIES]rl.Sound,
}

// TODO check for max entities and figure out errors
get_entity :: proc(using ecs: ^EntityComponentSystem, tag: string) -> Entity {
	for e in 0 ..< len(active) {
		if !active[e] {
			active[e] = true
			tag_map[tag] = Entity(e)
			return Entity(e)
		}
	}
	return MAX_ENTITIES
}

handle_input :: proc(using ecs: ^EntityComponentSystem) {
	e := tag_map["scarfy"]
	if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		velocity[e].x = speed[e].x
		animation[e].direction = Direction.East
	} else if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		velocity[e].x = -speed[e].x
		animation[e].direction = Direction.West
	} else {
		velocity[e].x = -1
		animation[e].direction = Direction.Idle
	}
	if rl.IsKeyPressed(.SPACE) && grounded[e] {
		velocity[e].y = -speed[e].y
	}
}

movement :: proc(using ecs: ^EntityComponentSystem) {
	for e in 0 ..< len(active) {
		if !active[e] {
			continue
		}
		velocity[e].y += gravity
		position[e] += velocity[e] * rl.GetFrameTime()
	}
}

collision :: proc(using ecs: ^EntityComponentSystem) {
	for e in 0 ..< len(active) {
		if !active[e] {
			continue
		}
		if position[e].y >= f32(boundry.y) - animation[e].frame_box.height {
			position[e].y = f32(boundry.y) - animation[e].frame_box.height
			velocity[e].y = 0
			grounded = true
		} else {
			grounded = false
		}
	}
}

animate :: proc(using ecs: ^EntityComponentSystem) {
	for e in 0 ..< len(active) {
		if !active[e] {
			continue
		}
		play(&animation[e])
		rl.DrawTextureRec(animation[e].texture^, animation[e].frame_box, position[e], rl.WHITE)
	}

}
