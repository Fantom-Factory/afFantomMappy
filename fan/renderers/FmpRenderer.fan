using gfx::Color
using gfx::Image
using gfx::Rect
using gfx::Size

//class FmpRenderer : Renderer {
//	private	const Int	blockWidth
//	private	const Int	blockHeight
//	private const Int	halfBlockWidth
//	
//	private Image[]		blockImages		:= [,]
//	
//	new make(MappyMap map) {
//		blockWidth  	= map.getMapHeader.getBlockWidth
//		blockHeight 	= map.getMapHeader.getBlockHeight
//		halfBlockWidth	= blockWidth / 2
//		
//		PixelData[] imageData	:= map.getImageData
//		
//		imageData.each |pixelData, imageIndex| {
//			opaqueImages.add(Image.makePainted(Size(blockWidth, blockHeight)) |g| {
//				i := 0
//				(0..<blockHeight).each |y| {
//					(0..<blockWidth).each |x| {
//						col := pixelData.getRawPixelData.get(i++)
//						g.brush = Color(col, false)
//						g.fillRect(x, y, 1, 1)
//					}
//				}
//			})
//			
//			transparentImages.add(Image.makePainted(Size(blockWidth, blockHeight)) |g| {
//				g.brush = Color(0xff000000, true)
//				g.alpha = 128
//				g.fillRect(0, 0, blockWidth, blockHeight)
//				i := 0
//				(0..<blockHeight).each |y| {
//					(0..<blockWidth).each |x| {
//						col := pixelData.getRawPixelData.get(i++)
//						if (col.and(0xffffff) > 0) {
//							g.alpha = 255
//							g.brush = Color(col, true)
//							g.fillRect(x, y, 1, 1)
//						} else {
//							g.alpha = 128
//							g.brush = Color(col, true)
//							g.fillRect(x, y, 1, 1)							
//						}
//					}
//				}
//			})
//		}
//	}
//
//	override Void drawImage(Obj? objGfx, Int imageIndex, Int dstPixX, Int dstPixY, Bool transparency, Int modification) {
//		g := objGfx as Gfx
//		
//		Image? image
//		
//		if (transparency) {
//			image = transparentImages[imageIndex]
//			if (image == null)
//				image = opaqueImages[imageIndex]
//		} else
//			image = opaqueImages[imageIndex]
//
//		// and draw it
//		switch (modification) {
//		case Renderer.NONE:
//			g.drawImage(image, dstPixX, dstPixY)
//
//		case Renderer.DRAW_LEFT_SIDE_ONLY:
//			g.copyImage(image, Rect(0, 0, halfBlockWidth, blockHeight), Rect(dstPixX, dstPixY, halfBlockWidth, blockHeight))
//
//		case Renderer.DRAW_RIGHT_SIDE_ONLY:
//			g.copyImage(image, Rect(halfBlockWidth, 0, halfBlockWidth, blockHeight), Rect(dstPixX+halfBlockWidth, dstPixY, halfBlockWidth, blockHeight))
//		}		
//	}
//
//	
//}
