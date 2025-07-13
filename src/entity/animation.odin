package entity

import rl "vendor:raylib"

Animation :: struct {
	name:           string,
	texture:        ^rl.Texture2D,
	frame_box:      rl.Rectangle,
	frame:          rl.Rectangle,
	n_row:          u8,
	n_col:          u8,
	i_row:          u8,
	i_col:          u8,
	flip_v:         bool,
	flip_h:         bool,
	continuous:     bool,
	finished:       bool,
	frame_time:     f32,
	frame_duration: f32,
}

flip_sprite :: proc(animation: ^Animation) {
	using animation

	if flip_v && flip_h {
		frame_box.width *= -1
		frame_box.height *= -1
	} else if flip_h {
		frame_box.width *= -1
	} else if flip_v {
		frame_box.height *= -1
	}
}

play :: proc(animation: ^Animation) {
	using animation
	if !finished {
		frame_time += rl.GetFrameTime()
		if frame_time >= frame_duration {
			i_row += 1
		}
		frame_box.x = f32(i_row) * frame_box.width
	}
}
