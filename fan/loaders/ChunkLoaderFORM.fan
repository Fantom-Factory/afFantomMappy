
**
** Chunk FORM :: Must be present at the start of every map.
** 
@Js
internal class ChunkLoaderFORM : ChunkLoader {
	
	new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}

    // ---- Public Methods ----------------------------------------------------

	override Void loadChunk(MappyMap map) {
		if (readStr(4) != "FMAP")
			throwChunkLoadErr("Chunk does not start with [FMAP]")
	}
}
