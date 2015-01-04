
**
** Chunk BKDT :: Contains BLKSTR structures.
** 
@Js
internal class ChunkLoaderBKDT : ChunkLoader {
	
	new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}

    // ---- Public Methods ----------------------------------------------------

	override Void loadChunk(MappyMap map) {
		mapHeader 		:= map.mapHeader
		imageByteSize	:= 1
		
		if (mapHeader.mapType == MapType.FMP05)
			// the "+1" caters for a colour depth of 15
			imageByteSize = mapHeader.blockSizeInPixels.w * mapHeader.blockSizeInPixels.h * ((mapHeader.colourDepth + 1) / 8)	

		log.info("Reading [$mapHeader.noOfBlocks] block properties...")
		(0..<mapHeader.noOfBlocks).each |i| {			
			block := Block()

			block.imageIndex[BlockLayer.background ] = readS4 / imageByteSize
			block.imageIndex[BlockLayer.foreground1] = readS4 / imageByteSize
			block.imageIndex[BlockLayer.foreground2] = readS4 / imageByteSize
			block.imageIndex[BlockLayer.foreground3] = readS4 / imageByteSize

			block.userData[1] = readS4
			block.userData[2] = readS4
			block.userData[3] = readS2
			block.userData[4] = readS2
			block.userData[5] = readU1
			block.userData[6] = readU1
			block.userData[7] = readU1

			bits := readU1
			block.collisionFlag[BlockCorner.topLeft]		= bits.and(0x01) != 0 
			block.collisionFlag[BlockCorner.topRight]		= bits.and(0x02) != 0 
			block.collisionFlag[BlockCorner.bottomLeft]		= bits.and(0x04) != 0 
			block.collisionFlag[BlockCorner.bottomRight]	= bits.and(0x08) != 0 
			block.flag[BlockFlag.trigger]					= bits.and(0x10) != 0
			block.flag[BlockFlag.unused1]					= bits.and(0x20) != 0
			block.flag[BlockFlag.unused2]					= bits.and(0x40) != 0
			block.flag[BlockFlag.unused3]					= bits.and(0x80) != 0

			if (mapHeader.textStringUserDataIndex != null) {
				textStringIndex := block.userData[mapHeader.textStringUserDataIndex]
				block.textString = map.textStrings[textStringIndex]
			}

			map.blocks.add(block)
		}
	}
}
