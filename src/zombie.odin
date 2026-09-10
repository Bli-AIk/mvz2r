#+feature using-stmt
package main

import ecs "../vendor/odecs/src"

ZOMBIE_SPAWN_INTERVAL :: 3.0
ZOMBIE_SPEED :: -20.0
ZOMBIE_W :: 64
ZOMBIE_H :: 64

zombie_plugin :: proc(app: ^App) {
	app_add_system(app, .Startup, setup_zombie_system)
	app_add_system(app, .Update, spawn_zombie_system)
	app_add_system(app, .Update, despawn_zombie_system)
}


SpawnTimer :: struct {
	t:     f32,
	count: int,
}

setup_zombie_system :: proc(ctx: ^Ctx) {
	resource_add(ctx, SpawnTimer{})
}

spawn_zombie_system :: proc(ctx: ^Ctx) {
	timer := resource_get(ctx, SpawnTimer)

	timer.t += ctx.dt
	if timer.t < ZOMBIE_SPAWN_INTERVAL do return

	// --- 生成 ---
	assets := resource_get(ctx, Assets)
	timer.t = 0
	row := timer.count % GRID_ROWS //先轮流走各条道以便测试；之后换随机
	timer.count += 1

	ecs.add_entity(
		ctx.world,
		Position{f32(WINDOW_WIDTH), f32(GRID_Y + row * CELL_H)},
		Velocity{ZOMBIE_SPEED, 0},
		Size{ZOMBIE_W, ZOMBIE_H},
		Zombie{},
		Sprite{texture = assets.textures["missing"], src = Rect{0, 0, 16, 16}},
	)
}


despawn_zombie_system :: proc(ctx: ^Ctx) {
	using ecs
	for arch in query(ctx.world, {Position, Zombie}) {
		positions := get_table(ctx.world, arch, Position)
		for i in 0 ..< len(arch.entities) {
			if positions[i].x + ZOMBIE_W < f32(GRID_X) {
				remove_entity(ctx.world, arch.entities[i])
			}
		}
	}
}
