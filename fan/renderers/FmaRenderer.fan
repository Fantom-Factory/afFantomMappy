using gfx::Image
using gfx::Rect
using gfx::Size

@Js
const class FmaRenderer : Renderer {
	
	private const Image blockImages
	private const Bool	includesBlock0
	private const Int 	blockWidth
	private const Int 	blockHeight
	private const Int 	halfBlockWidth

			** Defaults to 'false'. Set to 'true' in ctor via it block
			const Bool	renderImage0
	
	new make(MapHeader mapHeader, Image blockImages, Bool includesBlock0 := true) {
		this.blockImages = blockImages
		this.includesBlock0 = includesBlock0
		
		blockWidth		= mapHeader.blockSizeInPixels.w
		blockHeight		= mapHeader.blockSizeInPixels.h
		halfBlockWidth	= mapHeader.blockSizeInPixels.w / 2
		renderImage0	= false
	}
	
	** 'gfx' may be anything as long as it implements 'copyImage(Image image, Rect src, Rect dest)'
	override Void drawImage(Obj gfx, Int imageIndex, Int dstPixX, Int dstPixY, RendererDrawMode drawMode) {
		
		if (!renderImage0 && imageIndex == 0)
			return
		
		if (!includesBlock0 && imageIndex == 0)
			return

		if (includesBlock0)
			imageIndex--
		
		row := imageIndex % blocksPerRow
		col := imageIndex / blocksPerRow
		
		srcX := row * blockWidth
		srcY := col * blockHeight
		
		switch (drawMode) {
			case RendererDrawMode.drawAll:
				gfx->copyImage(blockImages, Rect(srcX, srcY, blockWidth, blockHeight), Rect(dstPixX, dstPixY, blockWidth, blockHeight))
	
			case RendererDrawMode.drawLeftSideOnly:
				gfx->copyImage(blockImages, Rect(srcX, srcY, halfBlockWidth, blockHeight), Rect(dstPixX, dstPixY, halfBlockWidth, blockHeight))
	
			case RendererDrawMode.drawRightSideOnly:
				gfx->copyImage(blockImages, Rect(srcX+halfBlockWidth, srcY, halfBlockWidth, blockHeight), Rect(dstPixX+halfBlockWidth, dstPixY, halfBlockWidth, blockHeight))
		}		
	}
	
	** We need to delay accessing 'blockImages' for if constructed before a FWT window, there's no GFXEnv to create the Image with
	private Int blocksPerRow() {
		blockImages.size.w / blockWidth
	}
}
