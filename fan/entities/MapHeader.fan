using gfx::Color
using gfx::Size

**
** MapHeader :: This class represents the data held within the MPHD chunk.
** 
@Js
class MapHeader {
	
	Version mapVersion		:= Version.defVal

	Endian endian			:= Endian.big

	MapType mapType			:= MapType.FMP05

	Size mapSizeInBlocks	:= Size.defVal
	Int reserved1			// not used
	Int reserved2			// not used
	Size blockSizeInPixels	:= Size.defVal
	Int colourDepth
	Int blockSize
	Int noOfBlocks
	Int noOfImages

	** For colour depths 16 and 24 this returns the Colour that is
	** rendered transparent.
	** 
	** Since FMP 0.4  
	Color?	chromeKey
	
	** For a colour depths of 8, this returns the colour index into `MappyMap.colours`
	** that is rendered transparent.
	** 
	** Since FMP 0.4  
	Int?	chromeKeyIndex

	** Since FMP 0.5  
	Size? blockGap
	
	** Since FMP 0.5  
	Size? blockStagger
	
	** Since FMP 0.5  
	Int? clickMask
	
	** Since FMP 0.5  
	Bool? risingPillarMode
	
	** Used by the Block Chunk Loader. A value of 'null' means text strings have not been set.
	** This is defined in the TSTR chunk, but here seemed like a good place to stick it for now
	Int? textStringUserDataIndex	
	
	
	** This takes into account the staggered block layout of an isometric map.
	Size mapSizeInPixels() {
		w := !isIsometric ? (mapSizeInBlocks.w * blockSizeInPixels.w) : (blockStagger.w * 2 * mapSizeInBlocks.w) - blockStagger.w
		h := !isIsometric ? (mapSizeInBlocks.h * blockSizeInPixels.h) : (blockStagger.h     * mapSizeInBlocks.h) - blockStagger.h
		return Size(w, h)
	}
	
	Bool isIsometric() {
		(blockStagger != null) && (blockStagger != Size.defVal)
	}
}

@Js
enum class MapType {
	** FMP 0.5
	FMP05,
	
	** FMP 1.0
	FMP10,
	
	** FMP 1.0 RLE (Run Length Encoding)
	FMP10RLE
}
