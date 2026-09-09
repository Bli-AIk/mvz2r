// bevy 风味封装
// 哎一群啥鸟我始终忘不了你
// 但是螃蟹快把我电脑储存夹爆了
package main

import ecs "../vendor/odecs/src"

WINDOW_WIDTH :: 640 * 2
WINDOW_HEIGHT :: 480 * 2
WINDOW_TITLE :: "Minecraft Vs Zombies 2: Reverie"

// ---

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
	assert(typeid_of(T) not_in ctx.resources, "资源重复注册")
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
	return App{ctx = Ctx{world = ecs.create_world(), resources = new(map[typeid]rawptr)}}
}

app_destroy :: proc(app: ^App) {
	for system_list in app.systems do delete(system_list)
	ecs.delete_world(app.ctx.world)
	for _, p in app.ctx.resources^ do free(p)
	delete(app.ctx.resources^)
	free(app.ctx.resources)
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
	init_window()
	defer close_window()
	set_target_fps(60)
	run_stage(app, .Startup)

	for !window_should_close() {
		app.ctx.dt = frame_time()
		app.ctx.time += app.ctx.dt

		run_stage(app, .PreUpdate)
		run_stage(app, .Update)
		run_stage(app, .PostUpdate)

		// Draw
		begin_frame()
		clear_background(Color{0, 0, 0, 0})

		run_stage(app, .Draw)

		draw_fps(10, 10)

		end_frame()
	}
}
