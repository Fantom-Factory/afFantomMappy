using gfx::Rect
using gfx::Size

** Renders a `Layer` to the screen. 
** This class may be used independently of (or even without) a `MapViewer`.
** 
** See `MapViewer` for a discussion on offsets.
@Js
class LayerViewer : Viewer {
	
	private Int		tallestPillar
	
	** The 'Layer' this 'Viewer' renders.
			Layer	layer			{ private set }
	
	** Creates a 'LayerViewer'.
	new make(Layer layer, MapHeader mapHeader, Renderer renderer, Rect viewBounds) : super(mapHeader, renderer, viewBounds) {
		this.layer = layer
		pillarRiserMode	= mapHeader.risingPillarMode
	}

	@NoDoc
	override Void draw(Obj gfx, BlockLayer[] blockLayers := [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3]) {

		drawInternal(gfx, viewBounds, blockLayers)
		
		// FIXME: Old works again! - but should refactor
//		drawInternalOld(gfx, true, true, true, true, true, super.viewBounds.x, super.viewBounds.y, super.viewBounds.w, super.viewBounds.h)
	}

	@NoDoc
	override Void drawPartial(Obj gfx, Rect dirty, BlockLayer[] blockLayers := [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3]) {
		drawInternal(gfx, dirty, [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3])		
	}
	
	private Void drawInternal(Obj gfx, Rect drawBounds, BlockLayer[] blockLayers) {
		mapPixX	:= drawBounds.x + coorInPixels.x
		mapPixY	:= drawBounds.y + coorInPixels.y
		mapBlkX	:= mapPixX 		/ mapHeader.blockSizeInPixels.w
		mapBlkY	:= mapPixY 		/ mapHeader.blockSizeInPixels.h
		
		dstPixX	:= viewBounds.x + drawBounds.x
		dstPixY	:= viewBounds.y + drawBounds.y
		maxPixX	:= dstPixX 		+ drawBounds.w
		maxPixY	:= dstPixY 		+ drawBounds.h

		dstPixX	-= mapPixX 		% mapHeader.blockSizeInPixels.w
		dstPixY	-= mapPixY 		% mapHeader.blockSizeInPixels.h
		
		dstPixXReset := dstPixX
		mapBlkXReset := mapBlkX
		
		renderer.setClip(gfx, viewBounds)
		
		while (dstPixY < maxPixY) {
			mapBlkX = mapBlkXReset
			dstPixX = dstPixXReset
			
			while (dstPixX < maxPixX) {				
				block := layer.blockAt(mapBlkX, mapBlkY)
				
				blockLayers.each |blockLayer| {
					imageIndex := block.imageIndex[blockLayer]
					renderer.drawImage(gfx, imageIndex, dstPixX, dstPixY, RendererDrawMode.drawAll)
				}
				
				mapBlkX++
				dstPixX += mapHeader.blockGap.w
			}
			
			mapBlkY++
			dstPixY += mapHeader.blockGap.h
		}
		
		renderer.restoreClip(gfx)
	}

	
//	private Void drawInternalOld(Obj gfx, Bool transparency, Bool drawBackground, Bool drawForeground1, Bool drawForeground2, Bool drawForeground3, Int dstPixX, Int dstPixY, Int dstPixWidth, Int dstPixHeight) {
//		Int startX		:= dstPixX + coorInPixels.x
//		Int startY		:= dstPixY + coorInPixels.y
//		Int mapX 		:= startX / mapHeader.blockGap.w
//		Int mapY 		:= startY / mapHeader.blockGap.h
//		dstPixX			+= viewBounds.x
//		dstPixY			+= viewBounds.y
//		dstPixWidth		+= dstPixX		// this is the max pix X, hence = viewOffsetX + dstPixX + dstPixWidth
//		dstPixHeight	+= dstPixY
//
//		blockHeight := mapHeader.blockSizeInPixels.h
//
//		super.renderer.setClip(gfx, super.viewBounds)
//
//		// initialise loop variables
//		dstPixX	-= (startX % mapHeader.blockGap.w)
//		dstPixY	-= (startY % mapHeader.blockGap.h)
//
//		// if hex / isometric...
//		if (mapHeader.isIsometric) {
//			transparency = true
//			dstPixX -= mapHeader.blockStagger.w
//			dstPixY -= mapHeader.blockStagger.h
//			mapY *= 2
//
//			// all layers (pillars) need to rendered in isometric mode
//			drawBackground = true
//			drawForeground1 = true
//			drawForeground2 = true
//			drawForeground3 = true
//		}
//
//		mapXStart	 := mapX
//		dstXStart	 := dstPixX
//
//		// loop for all blocks to be rendered
//		drawModeB 	:= RendererDrawMode.drawAll
//		drawModeF 	:= RendererDrawMode.drawAll
//		myTrans		:= transparency
//		isoBh		:= pillarRiserMode ? blockHeight : 0
//		blockIndex	:= 0
//		
//		Block? block
//		
//		if (pillarRiserMode)
//			dstPixHeight += tallestPillar
//		for ( ;dstPixY < dstPixHeight; dstPixY += mapHeader.blockGap.h) {
//
//			mapX = mapXStart
//			for (dstPixX = dstXStart ;dstPixX < dstPixWidth; dstPixX += mapHeader.blockGap.w) {
//
//				if (!pillarRiserMode || (mapY < mapHeader.mapSizeInBlocks.h)) {
//					// FIXME push down into Block - have some Block : AnimBlock inheritance
////					blockIndex = layer.isAnimBlock(mapX, mapY) ? layer.getAnimBlock(mapX, mapY).frame : layer.getBlockIndex(mapX, mapY)
//				} else
//					blockIndex = 0
//
//				isoY := dstPixY
//				blockIndex--
//				
//				Bool notDrawn := true
//				// FIXME- was a do-while
//				while (notDrawn || (pillarRiserMode && block.flag[BlockPillarFlag.attachNext.toBlockflag])) {
//					notDrawn = false;
//					
//					blockIndex++
////					block = layer.getBlockAtIndex(blockIndex)
//
//					if (pillarRiserMode) {						
//						drawModeF = block.drawMode
//						
//						if (isoY == dstPixY) {
//							drawModeB = RendererDrawMode.drawAll
//							myTrans = transparency
//						} else {
//							drawModeB = drawModeF
//							myTrans = true
//						}
//					}
//
//					if (drawBackground) {
//						imageIndex := block.imageIndex[BlockLayer.background]
//						if (imageIndex != 0)
//							renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeB)
//					}
//
//					isoY -= isoBh
//					if (drawForeground1) {
//						imageIndex := block.imageIndex[BlockLayer.foreground1]
//						if (imageIndex != 0)
//							renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeF)
//					}
//
//					isoY -= isoBh
//					if (drawForeground2) {
//						imageIndex := block.imageIndex[BlockLayer.foreground2]
//						if (imageIndex != 0)
//							renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeF);
//					}
//
//					isoY -= isoBh
//					if (drawForeground3) {
//						imageIndex := block.imageIndex[BlockLayer.foreground3]
//						if (imageIndex != 0)
//							renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeF);
//					}
//
//					isoY -= isoBh
//				}
//
//				mapX++
//			}
//
//
//			// if isometric... do the next half row
//			if (mapHeader.isIsometric) {
//				mapX = mapXStart
//				mapY++
//				dstPixY += mapHeader.blockStagger.h
//				for (dstPixX = (dstXStart + mapHeader.blockStagger.w); dstPixX < dstPixWidth; dstPixX += mapHeader.blockGap.w) {
//
//					if (!pillarRiserMode || (mapY < mapHeader.mapSizeInBlocks.h)) {
//						// FIXME push down into Block - have some Block : AnimBlock inheritance
////						blockIndex = layer.isAnimBlock(mapX, mapY) ? layer.getAnimBlock(mapX, mapY).frame : layer.getBlockIndex(mapX, mapY)
//					} else
//						blockIndex = 0
//
//					Int isoY := dstPixY
//					blockIndex--
//
//					// FIXME
//					while (pillarRiserMode && block.flag[BlockPillarFlag.attachNext.toBlockflag]) {
//						blockIndex++
////						block = layer.getBlockAtIndex(blockIndex)
//						
//						if (pillarRiserMode) {						
//							drawModeF = block.drawMode
//							
//							if (isoY == dstPixY) {
//								drawModeB = RendererDrawMode.drawAll
//								myTrans = transparency
//							} else {
//								drawModeB = drawModeF
//								myTrans = true
//							}
//						}
//
//						if (drawBackground) {
//							imageIndex := block.imageIndex[BlockLayer.background]
//							if (imageIndex != 0)
//								renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeB);
//						}
//
//						isoY -= isoBh
//						if (drawForeground1) {
//							imageIndex := block.imageIndex[BlockLayer.foreground1]
//							if (imageIndex != 0)
//								renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeF);
//						}
//
//						isoY -= isoBh
//						if (drawForeground2) {
//							imageIndex := block.imageIndex[BlockLayer.foreground2]
//							if (imageIndex != 0)
//								renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeF);
//						}
//
//						isoY -= isoBh
//						if (drawForeground3) {
//							imageIndex := block.imageIndex[BlockLayer.foreground3]
//							if (imageIndex != 0)
//								renderer.drawImage(gfx, imageIndex, dstPixX, isoY, drawModeF);
//						}
//
//						isoY -= isoBh
//					}
//					mapX++
//				}
//				dstPixY -= mapHeader.blockStagger.h
//			}
//			mapY++
//		}
//
//		// restore Clip
//		renderer.restoreClip(gfx)
//	}	
}
