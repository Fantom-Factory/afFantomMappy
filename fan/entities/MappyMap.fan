
**
** A standard bean class representing a .FMP map. See [MapViewer]`affantommappy::MapViewer` for 
** details on rendering a 'MappyMap' to the screen.
** 
@Js
class MappyMap {
	
	** This is the maximum number of `Layer`s that can be contained within a 'MappyMap'.
	** 
	** Has a constant value of '8'.
	static const Int MAX_NO_OF_LAYERS	:= 8
	
	MapHeader 	mapHeader		:= MapHeader()
	Int:Layer	layers			:= [:]
	Block[]		blocks			:= [,]
//	MapObject[] mapObjects 		:= [,]
//	String[] 	mapObjectImages := [,]
	AnimBlock[]	animBlocks		:= [,]
	Int[]		colours			:= [,]
//	PixelData[]	imageData		:= [,]
	Str[]? 		description
	Str[]?		textStrings
	
}
