using build

class Build : BuildPod {

	new make() {
		podName = "afFantomMappy"
		summary = "FantomMappy :: A Fantom Playback Library for Mappy"
		version = Version("1.0.2") 
		
		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"proj.name"		: "FantomMappy",
					"license.name"	: "BSD 2-Clause License"
				  ]		
		
		srcDirs = [`test/`, `test/loaders/`, `test/entities/`, `fan/`, `fan/viewers/`, `fan/util/`, `fan/renderers/`, `fan/loaders/`, `fan/entities/`]
		depends = ["sys 1.0", "gfx 1.0"]
		
		docApi = true
		docSrc = true
	}

}
