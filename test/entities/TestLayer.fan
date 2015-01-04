using gfx::Size

class TestLayer : Test {
	
	Void testWidthAndHeightValues() {
		map := MappyMap()
		map.mapHeader.blockSizeInPixels = Size(31, 17)
		map.mapHeader.mapSizeInBlocks	= Size(58, 33)
		layer := Layer(map.mapHeader, LayerData(Size(58, 33)), Block[,], AnimBlock[,])

		verifyEq(layer.sizeInBlocks.w, 58)
		verifyEq(layer.sizeInBlocks.h, 33)
		verifyEq(layer.sizeInPixels.w, 58 * 31)
		verifyEq(layer.sizeInPixels.h, 33 * 17)
	}



	Void testGetBlock() {
		map := MappyMap()
		map.mapHeader.blockSizeInPixels = Size(31, 17)
		map.blocks = Block[Block()]
		layer := Layer(map.mapHeader, LayerData(Size(58, 33)), map.blocks, AnimBlock[,])

		// just assert it doesn't throw ArrayIndexOutOfBounds...
		layer.blockAt(12, 15)
		layer.blockAt(31, 17)
	}

}
