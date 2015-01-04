
**
** Chunk BODY :: An array of short ints containing positive offsets into BKDT,
** and negative offsets into ANDT. i.e. this is the actual map data.
** 
@Js
internal class ChunkLoaderBODY : ChunkLoader {
	
	new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}

    // ---- Public Methods ----------------------------------------------------

	override Void loadChunk(MappyMap map) {
		mapHeader := map.mapHeader

		layerData := LayerData(mapHeader.mapSizeInBlocks)

		for (y := 0; y < mapHeader.mapSizeInBlocks.h; y++) {
			for (x := 0; x < mapHeader.mapSizeInBlocks.w; x++) {
				data := readS2

				// does the RLE not wrap around rows?
				if (mapHeader.mapType == MapType.FMP10RLE) {
					rleCount := data

					if (rleCount > 0) {
						while (rleCount > 0) {
							layerData.set(x, y, readS2)
							x++; rleCount--;
						}
					} else {
						rleVal := readS2
						while (rleCount < 0) {
							layerData.set(x, y, rleVal)
							x++; rleCount++;
						}
					}
					x-- // correct for RLE
				} else {
					layerData.set(x, y, data)

					if (layerData.get(x, y) >= 0) {
						if (mapHeader.mapType == MapType.FMP05)
							layerData.div(x, y, mapHeader.blockSize)
					} else {
						if (mapHeader.mapType == MapType.FMP05) 
							layerData.div(x, y, 16)
					}
				}
			}
		}

		// find the chunk layer index
        layerIndex := 0
        if (chunkName != "BODY") {
	        try {
	        	layerIndex = chunkName.getRange(-1..-1).toInt
	        } catch (ParseErr pe) {
	        	throwChunkLoadErr("Cannot find Layer index, invalid chunk name :: chunkName=[$chunkName]")
	        }
        }

		layer := Layer(mapHeader, layerData, map.blocks, map.animBlocks)
		map.layers[layerIndex] = layer
	}
}
