#+feature using-stmt
package main

import ecs "../vendor/odecs/src"

CELL_W :: 96
CELL_H :: 96
GRID_ROWS :: 5
GRID_COLS :: 9
// 第 0 列左边缘（世界坐标）
GRID_X :: 260
// 第 0 行上边缘
GRID_Y :: 80

grid_plugin :: proc(app: ^App) {
	app_add_system(app, .Startup, spawn_grid_system)
	app_add_system(app, .Draw, debug_draw_cell_system)
}

spawn_grid_system :: proc(ctx: ^Ctx) {
	using ecs

	CELL_COLOR_A :: Color{0.36, 0.56, 0.26, 1}
	CELL_COLOR_B :: Color{0.31, 0.50, 0.22, 1}

	for row in 0 ..< GRID_ROWS {
		for col in 0 ..< GRID_COLS {
			color := CELL_COLOR_A if (row + col) % 2 == 0 else CELL_COLOR_B

			cell := Cell {
				row  = row,
				col  = col,
				kind = .Ground,
			}

			ecs.add_entity(
				ctx.world,
				Position{f32(GRID_X + col * CELL_W), f32(GRID_Y + row * CELL_H)},
				Size{CELL_W, CELL_H},
				color,
				cell,
			)
		}
	}
}

debug_draw_cell_system :: proc(ctx: ^Ctx) {
	using ecs
	for arch in query(ctx.world, {Position, Size, Cell, Color}) {
		positions := get_table(ctx.world, arch, Position)
		sizes := get_table(ctx.world, arch, Size)
		colors := get_table(ctx.world, arch, Color)
		for i in 0 ..< len(arch.entities) {
			p := positions[i]
			s := sizes[i]
			draw_rect(p.x, p.y, s.w, s.h, colors[i])
		}
	}
}

// 获取指定坐标对应的格子实体
cell_at :: proc(ctx: ^Ctx, x, y: f32) -> (entity: ecs.EntityID, ok: bool) {
	using ecs
	for arch in query(ctx.world, {Position, Size, Cell}) {
		positions := get_table(ctx.world, arch, Position)
		sizes := get_table(ctx.world, arch, Size)
		for i in 0 ..< len(arch.entities) {
			p := positions[i]
			s := sizes[i]
			if x >= p.x && x < p.x + s.w && y >= p.y && y < p.y + s.h {
				return arch.entities[i], true
			}
		}
	}
	return 0, false
}
