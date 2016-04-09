using build

class Build : BuildPod {

	new make() {
		podName = "afFantomMappy"
		summary = "A playback library for tile maps created with Mappy"
		version = Version("1.0.5") 

		meta = [
			"proj.name"			: "FantomMappy",
			"repo.tags"			: "misc",
			"repo.public"		: "false"
		]
		
		depends = [
			"sys 1.0", 
			"gfx 1.0" 
		]

		srcDirs = [`fan/`, `fan/entities/`, `fan/loaders/`, `fan/renderers/`, `fan/viewers/`, `test/`, `test/entities/`, `test/loaders/`]
		resDirs = [`doc/`]
	}
}
