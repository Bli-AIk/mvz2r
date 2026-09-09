// bevy 风味 ecs 封装
// 哎一群啥鸟我始终忘不了你
// 但是螃蟹快把我电脑储存夹爆了
package main

import ecs "../vendor/odecs/src"
import rl "vendor:raylib"

System :: proc(ctx: ^Ctx)

Stage :: enum {
	Startup,
	PreUpdate,
	Update,
	PostUpdate,
	Draw,
}

// --- context ---
Ctx :: struct {
	world:     ^ecs.World,
	dt:        f32,
	time:      f32,
	resources: ^map[typeid]rawptr,
}

resource_add :: proc(ctx: ^Ctx, value: $T) {
	p := new(T)
	p^ = value
	ctx.resources[typeid_of(T)] = rawptr(p)
}

resource_get :: proc(ctx: ^Ctx, $T: typeid) -> ^T {
	return cast(^T)ctx.resources[T]
}

// --- app ---
App :: struct {
	ctx:     Ctx,
	systems: [Stage][dynamic]System,
}

app_create :: proc() -> App {
	// TODO: 给 resources 分配东西
	return App{ctx = Ctx{world = ecs.create_world()}}
}

app_destroy :: proc(app: ^App) {
	for system_list in app.systems do delete(system_list)
	ecs.delete_world(app.ctx.world)
	// TODO: 释放 resources
}

app_add_system :: proc(app: ^App, stage: Stage, sys: System) {
	append(&app.systems[stage], sys)
}

run_stage :: proc(app: ^App, stage: Stage) {
	for system in app.systems[stage] {
		system(&app.ctx)
	}
}

app_run :: proc(app: ^App) {
	rl.InitWindow(640 * 2, 480 * 2, "Minecraft Vs Zombies 2: Reverie")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	run_stage(app, .Startup)

	for !rl.WindowShouldClose() {
		app.ctx.dt = rl.GetFrameTime()
		app.ctx.time += app.ctx.dt

		run_stage(app, .PreUpdate)
		run_stage(app, .Update)
		run_stage(app, .PostUpdate)

		// Draw
		rl.BeginDrawing()
		rl.ClearBackground({160, 200, 255, 255})

		run_stage(app, .Draw)

		rl.DrawFPS(10, 10)

		rl.EndDrawing()
	}
}
