
**
** A simple bean class which represents a 'Block' as used by 'Mappy'. A 'Block' may contain up to 
** 4 [layers]`BlockLayer` of images (1 background layer and 3 foreground layers), 7 fields of user 
** data, quadratic collision information and 4 other flags.
** 
@Js
class Block {
	** User data is indexed 1 <=> 7
	Int:Int				userData		:= [:]	// use a map 'cos of the "off by 1" index
	BlockLayer:Int		imageIndex		:= [:]
	BlockCorner:Bool	collisionFlag	:= [:]
	BlockFlag:Bool		flag			:= [:]
	Str?				textString
	
	RendererDrawMode drawMode() {
		if (flag[BlockPillerFlag.leftSidePillar.toBlockflag])
			return RendererDrawMode.drawLeftSideOnly
		if (flag[BlockPillerFlag.rightSidePillar.toBlockflag])
			return RendererDrawMode.drawRightSideOnly
		return RendererDrawMode.drawAll
	}
}

@Js
enum class BlockLayer {
	background,
	foreground1,
	foreground2,
	foreground3
}

@Js
enum class BlockCorner {	
    topLeft,
	topRight,
	bottomLeft,
	bottomRight
}

@Js
enum class BlockFlag {
	trigger,
	unused1,
	unused2,
	unused3	
}

@Js
enum class BlockPillerFlag {
	none			(BlockFlag.trigger,	RendererDrawMode.drawAll),
	attachNext		(BlockFlag.unused1,	RendererDrawMode.drawAll),
	leftSidePillar	(BlockFlag.unused2,	RendererDrawMode.drawLeftSideOnly),
	rightSidePillar	(BlockFlag.unused3,	RendererDrawMode.drawRightSideOnly)
	
	const BlockFlag 		toBlockflag
	const RendererDrawMode toDrawMode
	
	private new make(BlockFlag blockFlag, RendererDrawMode drawMode) {
		this.toBlockflag = blockFlag
		this.toDrawMode = drawMode
	}	
}
