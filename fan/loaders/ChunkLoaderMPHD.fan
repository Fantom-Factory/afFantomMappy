using gfx::Color
using gfx::Size

**
** Chunk MPHD :: Map header, see struct in mapfunc.c
** 
@Js
internal class ChunkLoaderMPHD : ChunkLoader {
	
	new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}

    // ---- Public Methods ----------------------------------------------------

	override Void loadChunk(MappyMap map) {
		header := map.mapHeader
		
		// read and verify the map version
		header.mapVersion 			= Version([readS1, readS1])
		if (header.mapVersion.major > 1) throwChunkLoadErr("Map version is unsupported :: version=[$header.mapVersion]")
		log.info("FMP Version       = [$header.mapVersion]")

		// this has to be the most important bit in the whole damn map!
		header.endian 				= (readS1 == 1) ? Endian.little : Endian.big
		endian 						= header.endian
		log.info("LSB               = [$header.endian]")

		// read and verify the map type
		mapType := readS1
		if (mapType >= 3) throwChunkLoadErr("Map type is unsupported :: type=[$mapType]")
		header.mapType 				= [MapType.FMP05, MapType.FMP10, MapType.FMP10RLE][mapType]
		log.info("Map Type          = [$header.mapType]")

		// read general map data
		header.mapSizeInBlocks 		= Size(readS2, readS2)
		header.reserved1			= readS2
		header.reserved2			= readS2
		header.blockSizeInPixels	= Size(readS2, readS2)
		header.colourDepth			= readS2
		header.blockSize			= readS2
		header.noOfBlocks			= readS2
		header.noOfImages			= readS2
		log.info("Map Size Blocks   = [$header.mapSizeInBlocks]")
		log.info("Reserved 1        = [$header.reserved1]")
		log.info("Reserved 2        = [$header.reserved2]")
		log.info("Block Size Pixels = [$header.blockSizeInPixels]")
		log.info("Colour Depth      = [$header.colourDepth]")
		log.info("Block Size        = [$header.blockSize]")
		log.info("No. Of Blocks     = [$header.noOfBlocks]")
		log.info("No. Of Images     = [$header.noOfImages]")

		// these bytes were added in FMP v0.4, but it's easier and safer to just
		// check the number of bytes left
		if (bytesRemaining >= 4) {
			header.chromeKeyIndex	= readU1
			header.chromeKey		= Color.makeRgb(readU1, readU1, readU1)
			log.info("Chrome Key Index  = [$header.chromeKeyIndex]")
			log.info("Chrome Key        = [$header.chromeKey]")
		}

		// these bytes were added in FMP v0.5, but it's easier and safer to just
		// check the number of bytes left
		if (bytesRemaining >= 12) {
			header.blockGap			= Size(readS2, readS2)
			header.blockStagger		= Size(readS2, readS2)
			header.clickMask		= readS2
			header.risingPillarMode	= readS2 > 0
			log.info("Block Gap         = [$header.blockGap]")
			log.info("Block Stagger     = [$header.blockStagger]")
			log.info("Click Mask        = [$header.clickMask]")
			log.info("RisingPillarMode  = [$header.risingPillarMode]")
		}		
	}
}
