#+feature using-stmt
package main

import ecs "../vendor/odecs/src"
import "core:fmt"

Position :: struct {
	x, y: f32,
}
Velocity :: struct {
	vx, vy: f32,
}

main :: proc() {
	using ecs

	world := create_world()
	defer delete_world(world)

	player := add_entity(world, Position{0, 0}, Velocity{1, 1})

	for arch in query(world, {Position, Velocity}) {
		positions := get_table(world, arch, Position)
		velocities := get_table(world, arch, Velocity)

		for i in 0 ..< len(arch.entities) {
			positions[i].x += velocities[i].vx
			positions[i].y += velocities[i].vy

			fmt.println(positions[i],velocities[i])
		}

	}
}
