
**
** Chunk ATHR :: Up to 4 ASCII strings of author information.
** 
** 
@Js
internal class ChunkLoaderATHR : ChunkLoader {
	
	new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}

    // ---- Public Methods ----------------------------------------------------

	override Void loadChunk(MappyMap map) {
		
		// read in the 4 lines of text
		Str[] desc := [,]
		(0..<4).each {
			desc.add(readLine)
		}
		
		log.info("Author      :: ${desc[0]}")
		log.info("Description :: ${desc[1]}")
		log.info("            :: ${desc[2]}")
		log.info("            :: ${desc[3]}")

        // save out map description
		map.description = desc;
	}
}
