source_path := "src/"

default:
    @just run

build:
    odin build {{source_path}}

run:
    odin run {{source_path}}
