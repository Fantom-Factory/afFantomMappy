using gfx::Rect

** Implement to define a low level renderer for block images.
@Js
mixin Renderer {
	
	** Draws an image of a 'Block' as given by 'imageIndex' at the given coordinates.
	abstract Void drawImage(Obj gfx, Int imageIndex, Int dstPixX, Int dstPixY, RendererDrawMode drawMode)	
	
	** Called just before a `Layer` is drawn so the desired clipping region may be set.
	virtual Void setClip(Obj gfx, Rect viewBounds) {}

	** Called after a `Layer` is drawn to restore the clipping region to what it used to be.
	virtual Void restoreClip(Obj gfx) {}
}


** Used in Pillar Rising Mode to determine which side of the block should be drawn.
@Js
enum class RendererDrawMode {
	
	** Specifies the whole block should be drawn
	drawAll,

	** Specifies only the left hand side of the image should be drawn (used in Pillar Rising Mode)
	drawLeftSideOnly,

	** Specifies only the right hand side of the image should be drawn (used in Pillar Rising Mode)
	drawRightSideOnly
}