package entity

import "core:fmt"
import rl "vendor:raylib"

Direction :: enum {
	Idle,
	North,
	East,
	South,
	West,
}

Animation :: struct {
	name:           string,
	texture:        ^rl.Texture2D,
	frame_box:      rl.Rectangle,
	frame:          rl.Rectangle,
	n_row:          u8,
	n_col:          u8,
	i_row:          u8,
	i_col:          u8,
	direction:      Direction,
	continuous:     bool,
	finished:       bool,
	frame_time:     f32,
	frame_duration: f32,
}

set_direction :: proc(using animation: ^Animation) {
	#partial switch direction {
	case .East:
		if frame_box.width < 0 {
			frame_box.width *= -1
			i_col = 0
		}
	case .West:
		if frame_box.width > 0 {
			frame_box.width *= -1
			i_col = n_col - 1
		}
	}
}

set_col :: proc(using animation: ^Animation) {
	#partial switch direction {
	case .Idle:
		i_col = 0
	case .East:
		if i_col < n_col - 1 {
			i_col += 1
		} else {
			i_col = 0
		}
	case .West:
		if i_col > 0 {
			i_col -= 1
		} else {
			i_col = n_col - 1
		}
	}
}

play :: proc(using animation: ^Animation) {
	set_direction(animation)
	if !finished {
		frame_time += rl.GetFrameTime()
		if frame_time >= frame_duration {
			set_col(animation)
			frame_time = 0
		}
		frame_box.x = f32(i_col) * frame_box.width
	}
}
