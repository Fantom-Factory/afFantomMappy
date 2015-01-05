using build

class Build : BuildPod {

	new make() {
		podName = "afFantomMappy"
		summary = "A playback library for tile maps created with Mappy"
		version = Version("1.0.5") 

		meta = [
			"proj.name"			: "FantomMappy",
			"tags"				: "misc",
			"repo.private"		: "true"
		]
		
		depends = [
			"sys 1.0", 
			"gfx 1.0" 
		]

		srcDirs = [`test/`, `test/loaders/`, `test/entities/`, `fan/`, `fan/viewers/`, `fan/renderers/`, `fan/loaders/`, `fan/entities/`]
	}
}
