
class TestBlock : Test {
	
	Block? block
	
	override Void setup() {
		block = Block()
	}

	Void testFlag() {
		block.flag[BlockFlag.trigger] = true
		verifyEq(block.flag[BlockFlag.trigger], true)
		block.flag[BlockFlag.trigger] = false
		verifyEq(block.flag[BlockFlag.trigger], false)

		block.flag[BlockFlag.unused1] = true
		verifyEq(block.flag[BlockFlag.unused1], true)
		block.flag[BlockFlag.unused1] = false
		verifyEq(block.flag[BlockFlag.unused1], false)

		block.flag[BlockFlag.unused2] = true
		verifyEq(block.flag[BlockFlag.unused2], true)
		block.flag[BlockFlag.unused2] = false
		verifyEq(block.flag[BlockFlag.unused2], false)

		block.flag[BlockFlag.unused3] = true
		verifyEq(block.flag[BlockFlag.unused3], true)
		block.flag[BlockFlag.unused3] = false
		verifyEq(block.flag[BlockFlag.unused3], false)
	}

	Void testImageIndex() {
		block.imageIndex[BlockLayer.background]  = 50
		block.imageIndex[BlockLayer.foreground1] = 53
		block.imageIndex[BlockLayer.foreground2] = 67
		block.imageIndex[BlockLayer.foreground3] = 69
		verifyEq(block.imageIndex[BlockLayer.background],  50)
		verifyEq(block.imageIndex[BlockLayer.foreground1], 53)
		verifyEq(block.imageIndex[BlockLayer.foreground2], 67)
		verifyEq(block.imageIndex[BlockLayer.foreground3], 69)
	}	
}
