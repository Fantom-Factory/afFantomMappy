using gfx::Point
using gfx::Rect

**
** Renders a `MappyMap` or a `Layer` (dependent on the implementation) to the screen. 
** By default the map is rendered to the top left hand corner of the screen as shown below: 
**
**    +------------------+---------+
**    |                  |         |
**    | Fan Mappy Viewer |         |
**    |                  |         |
**    |                  |         |
**    +------------------+         |
**    |                            |
**    | Screen                     |
**    |                            |
**    +----------------------------+ 
**
** (A 'Viewer' with a width and height smaller than the screen) 
**
** However, you can move the viewing area around the screen by specifying an X
** and Y view offset as shown below:
**
**    +----------------------------+
**    | Screen                     |
**    |    +------------------+    |
**    |    |                  |    |
**    |    | Fan Mappy Viewer |    |
**    |    |                  |    |
**    |    |                  |    |
**    |    +------------------+    |
**    |                            |
**    +----------------------------+ 
**
** (The same 'Viewer' with an X and Y view offset)
** 
@Js
abstract class Viewer {
	
    MapHeader		mapHeader	{ private set }
    Renderer 		renderer	{ private set }
    const 	Rect	viewBounds
	
    virtual Point	coorInPixels	:= Point.defVal
   	virtual Bool	pillarRiserMode	:= false
	
	virtual Point	coorInBlocks {
		get {
			x := coorInPixels.x / mapHeader.blockSizeInPixels.w
			y := coorInPixels.y / mapHeader.blockSizeInPixels.h
			return Point(x, y)
		}
		set {
			x := it.x * mapHeader.blockSizeInPixels.w
			y := it.y * mapHeader.blockSizeInPixels.h
			coorInPixels = Point(x, y)
		}
	}
	
	** Creates a 'Viewer'.
	new make(MapHeader mapHeader, Renderer renderer, Rect viewBounds) {
		this.mapHeader	= mapHeader
		this.renderer	= renderer
		this.viewBounds	= viewBounds
	}
	
	** TODO: add call backs for clipping
	virtual Void translatePixels(Int x, Int y) {
		coorInPixels = coorInPixels.translate(Point(x, y)) 
	}

	** TODO: add call backs for clipping
	virtual Void translateBlocks(Int x, Int y) {
		coorInBlocks = coorInBlocks.translate(Point(x, y)) 
	}
	
	** Draws Mappy data into the viewing area. gfx is object specific to the `Renderer`
	abstract Void draw(Obj gfx, BlockLayer[] blockLayers := [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3])


	** Draws but just a section of the viewing area. 
	** To be used when you do not need to render the whole screen, but just part of it.
	abstract Void drawPartial(Obj gfx, Rect dirty, BlockLayer[] blockLayers := [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3])
}
