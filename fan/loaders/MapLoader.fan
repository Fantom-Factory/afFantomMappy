
** Loads `MappyMap` instances from '.FMP' data streams. 
** See `MapViewer` for details on rendering a `MappyMap` to the screen.
@Js
class MapLoader {
	private static const Log log := MapLoader#.pod.log
	
	@NoDoc
	protected Str:Type			chunkLoaders 	:= [:]

	@NoDoc
	protected Int				mapSize

	
	
	// ---- Constructors ------------------------------------------------------

	internal new make() {
		// by having instances of MapLoaders they become self initialising and
		// the ChunkLoader instances (below) get automatically garbage collected
		registerChunkLoaders
	}



    // ---- Public Methods ----------------------------------------------------

	** Create a `MappyMap` from the given input stream of '.FMP' data.
	** 
	** Note this method closes the input stream.
	static MappyMap loadMap(InStream fmpStream) {
		return MapLoader().doLoadMap(fmpStream)
	}



    // ---- Protected Methods -------------------------------------------------

    ** Performs the actual FMP map loading. 
	private MappyMap doLoadMap(InStream fmpStream) {
		log.debug("loadMap() - Starting...")
		log.info("Loading Map from InputStream")

		try {
			map := MappyMap()
	
			// load the map header
			chkMapHeader := createChunkLoader(fmpStream, Endian.big)
			if (chkMapHeader.chunkName != "FORM")
				throw FantomMappyErr("Map does not start with chunk [FORM] :: ChunkIf = [$chkMapHeader.chunkName]")
	
			// find out how many bytes are contained in the map data
			chkMapHeader.loadChunk(map)
			bytesToRead := mapSize - 4
	
			// read chunks while there's still chunks to read
			while (bytesToRead > 0) {
	
				// find and create the next chunk loader
				chunkLoader := createChunkLoader(fmpStream, map.mapHeader.endian)
	
				// load the chunk
				chunkLoader.loadChunk(map)
	
				// check that all the data was loaded
				if (chunkLoader.bytesRemaining > 0) {
					log.warn("Chunk [$chunkLoader.chunkName] still has [$chunkLoader.bytesRemaining] bytes remaining, skipping...");
				}
	
				// the countdown continues
				bytesToRead -= 8	// for the chunk header
				bytesToRead -= chunkLoader.chunkSize
			}
			
			log.debug("loadMap() - Done.")
			return map
			
		} finally {
			fmpStream.close
		}
	}

	
	
	 // ---- Internal Methods -------------------------------------------------
	
	** Factory method for producing instances of ChunkLoaders.
	** Note: This method does not close the given input stream.
	internal ChunkLoader createChunkLoader(InStream fmpStream, Endian endian) {
		log.debug("createChunkLoader() - Starting...")

		ChunkLoader?	chunkLoader 	:= null
		Str?			errorMessage	:= null

		try {
			errorMessage	= "Could not read chunkId"
			chunkId 		:= fmpStream.readChars(4)

			errorMessage	= "Could not read chunk length for ChunkId [$chunkId]"
			chunkSize		:= fmpStream.readU4	// ignore the LSB / MSB thing for chunk lengths
			
			if (chunkId == "FORM")	// a little fudge
				mapSize		= chunkSize
			
            errorMessage	= "Could not read raw chunk data for ChunkId [$chunkId]"
			buf				:= fmpStream.readBufFully(null, chunkId == "FORM" ? 4 : chunkSize)

			// set a default return value
			errorMessage	= "Problem creating DefaultChunkLoader"
			chunkLoader		= DefaultChunkLoader(chunkId, buf, endian)

			// find actual ChunkLoader
			errorMessage	= "Could not find ChunkLoader for ChunkId [$chunkId]"
			chunkLoaderType	:= chunkLoaders.getOrThrow(chunkId)

			errorMessage	= "Problem initialising ChunkLoader for ChunkId [$chunkId]"
			chunkLoader		= chunkLoaderType.make([chunkId, buf, endian])

		} catch (Err e) {
			// always return a default chunk loader if we can, so we may
			// continue reading the rest of the map. Not finding a particular
			// ChunkLoader is going to be a common problem.
			if (chunkLoader != null) {
				log.warn(errorMessage)
			} else {
				throw ChunkLoadErr(errorMessage, e)
			}
		}

		log.info(chunkLoader.toStr)
		log.debug("createChunkLoader() - Done.")
		return chunkLoader
	}



	** This is where we hard code chunk loader class references to chunk names.
	** We do this so that (J2ME) obfuscaters can rename classes. It also allows
	** us to delete empty chunk loader classes like ChunkLoaderLRYx. 
	internal Void registerChunkLoaders() {

		chunkLoaders["ANDT"] = ChunkLoaderANDT#
		chunkLoaders["ATHR"] = ChunkLoaderATHR#
//		chunkLoaders["BGFX"] = ChunkLoaderBGFX#
		chunkLoaders["BKDT"] = ChunkLoaderBKDT#
//		chunkLoaders["CMAP"] = ChunkLoaderCMAP#
		chunkLoaders["FORM"] = ChunkLoaderFORM#
		chunkLoaders["MPHD"] = ChunkLoaderMPHD#
//	    chunkLoaders["OBDT"] = ChunkLoaderOBDT#
//	    chunkLoaders["OBFN"] = ChunkLoaderOBFN#
//		chunkLoaders["TSTR"] = ChunkLoaderTSTR#

		chunkLoaders["BODY"] = ChunkLoaderBODY#
		chunkLoaders["LYR1"] = ChunkLoaderBODY#
		chunkLoaders["LYR2"] = ChunkLoaderBODY#
		chunkLoaders["LYR3"] = ChunkLoaderBODY#
		chunkLoaders["LYR4"] = ChunkLoaderBODY#
		chunkLoaders["LYR5"] = ChunkLoaderBODY#
		chunkLoaders["LYR6"] = ChunkLoaderBODY#
		chunkLoaders["LYR7"] = ChunkLoaderBODY#
	}
}

@Js
internal class DefaultChunkLoader : ChunkLoader {
	
	new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}
		
	override Void loadChunk(MappyMap map) {
		// prevent the warning log
		super.skip(super.bytesRemaining)
	}
}	
