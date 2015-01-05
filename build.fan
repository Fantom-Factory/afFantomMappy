using build

class Build : BuildPod {

	new make() {
		podName = "afFantomMappy"
		summary = "A playback library for square, hexagonal and isometric Mappy tile maps."
		version = Version("1.0.3") 

		meta = [
			"proj.name"			: "FantomMappy",
			"tags"				: "misc",
			"repo.private"		: "true"
		]
		
		depends = [
			"fwt 1.0",
			"web 1.0",
			
			"sys 1.0", 
			"gfx 1.0" 
		]

		srcDirs = [`test/`, `test/loaders/`, `test/entities/`, `fan/`, `fan/viewers/`, `fan/renderers/`, `fan/loaders/`, `fan/entities/`]
	}
}
