
class TestChunkLoaderFORM : Test {
	
	Void testLoadChunkWorksWithValidData() {
		data 		:= "FORM\u0000\u0000\u0000\u0004FMAP"
		chunkLoader	:= MapLoader().createChunkLoader(data.toBuf.in, Endian.big)
		chunkLoader.loadChunk(MappyMap())
	}

	Void testLoadChunkAbortsIfNoFMAPData() {
		data 		:= "FORM\u0000\u0000\u0000\u0004DODA"
		chunkLoader := MapLoader().createChunkLoader(data.toBuf.in, Endian.big)

		try {
			chunkLoader.loadChunk(MappyMap())
			super.fail("ChunkLoadErr Expected")
		} catch (ChunkLoadErr cle) { }
	}
	
}
