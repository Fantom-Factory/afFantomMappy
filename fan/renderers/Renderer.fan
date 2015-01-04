using gfx::Rect

@Js
mixin Renderer {
	
	** Draws an image as given by 'imageIndex' at the given coordinates.
	abstract Void drawImage(Obj gfx, Int imageIndex, Int dstPixX, Int dstPixY, RendererDrawMode drawMode)	
	
	** This is called just before a `Layer` is drawn to allow the 'Renderer' to set the desired 
	** clipping region.
	virtual Void setClip(Obj gfx, Rect viewBounds) {}

	** This is called after a `Layer` is drawn to restore the clipping region to what it used to be.
	virtual Void restoreClip(Obj gfx) {}
}

@Js
enum class RendererDrawMode {
	
	** Specifies the whole block should be drawn
	drawAll,

	** Specifies only the left hand side of the image should be drawn (used in Pillar Rising Mode)
	drawLeftSideOnly,

	** Specifies only the right hand side of the image should be drawn (used in Pillar Rising Mode)
	drawRightSideOnly
}