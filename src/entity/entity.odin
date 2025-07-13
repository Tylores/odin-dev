package entity

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
get_entity :: proc(ecs: ^EntityComponentSystem, tag: string) -> Entity {
	using ecs
	for e in 0 ..< len(active) {
		if !active[e] {
			active[e] = true
			tag_map[tag] = Entity(e)
			return Entity(e)
		}
	}
	return MAX_ENTITIES
}

handle_input :: proc(ecs: ^EntityComponentSystem) {
	using ecs
	e := tag_map["scarfy"]
	if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		velocity[e].x = speed[e].x
		animation[e].flip_h = false
	} else if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		velocity[e].x = -speed[e].x
		animation[e].flip_h = true
	} else if rl.IsKeyPressed(.SPACE) && !grounded[e] {
		velocity[e].y = speed[e].y
	}
}

movement :: proc(ecs: ^EntityComponentSystem) {
	using ecs
	for e in 0 ..< len(position) {
		position[e] += velocity[e]
	}
}

collision :: proc(ecs: ^EntityComponentSystem) {
	using ecs
	for i in 0 ..< len(position) {
		if position[i].y >= f32(boundry.y) - animation[i].frame_box.height {
			position[i].y = f32(boundry.y) - animation[i].frame_box.height
			velocity[i].y = 0
			grounded = true
		} else {
			velocity[i].y += gravity
			grounded = false
		}
	}
}

animate :: proc(ecs: ^EntityComponentSystem) {
	using ecs
	for e in 0 ..< len(active) {
		flip_sprite(&animation[e])
		play(&animation[e])
		rl.DrawTextureRec(animation[e].texture^, animation[e].frame_box, position[e], rl.WHITE)
	}

}
