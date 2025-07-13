package entity

import "core:fmt"
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
	continuous:     bool,
	finished:       bool,
	frame_time:     f32,
	frame_duration: f32,
}

play :: proc(using animation: ^Animation) {
	if !finished {
		frame_time += rl.GetFrameTime()
		if frame_time >= frame_duration {
			i_col += 1
			frame_time = 0
		}
		if i_col >= n_col && continuous {
			i_col = 0
		}
		if !continuous {
			finished = true
		}
		frame_box.x = f32(i_col) * frame_box.width
	}
}
