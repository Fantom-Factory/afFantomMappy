
class MapLoadTest : Test {
	
	Void testLoadMap() {
		File f := `test/GundamLevel.fmp`.toFile
		MapLoader.loadMap(f.in)
	}

}
