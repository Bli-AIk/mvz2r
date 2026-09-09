package main

Texture :: struct {
	id:            u32,
	width, height: i32,
}

Assets :: struct {
	textures: map[string]Texture,
}

load_assets_system :: proc(ctx: ^Ctx) {
	assets: Assets
	assets.textures["missing"] = load_texture("assets/missing.png")
	resource_add(ctx, assets)
}


assets_plugin :: proc(app: ^App) {
	app_add_system(app, .Startup, load_assets_system)
}
