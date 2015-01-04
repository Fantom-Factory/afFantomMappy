using gfx::Point
using gfx::Rect

** Renders a `MappyMap` onto the screen. A 'MapViewer' creates a `LayerViewer` for each of the 
** `Layer`s in the `MappyMap`.
**  
** Updating the coordinates of a 'MapViewer' also updates the coordinates of all the underlying 
** `LayerViewer`s.
** 
** Note that the coordinates of a 'MapViewer' are held independently of the coordinates held by 
** the underlying `LayerViewer`s. i.e. If you were to change the coordinates of the `LayerViewer`s, 
** the coordinates held by the 'MapViewer' would remain unchanged. 
@Js
class MapViewer : Viewer {
	
	// FIXME: Have a layer enum and a Map, not an Array
	LayerViewer[]	layerViewers	:= [,]	{ private set }
	MappyMap		map						{ private set }
	
	** Creates a `LayerViewer` for each of the 'Layer's in the `MappyMap` and places the viewing 
	** area at the given offset.
	new make(MappyMap map, Renderer renderer, Rect viewBounds) : super(map.mapHeader, renderer, viewBounds) {
		this.map = map
		map.layers.each |layer| {
			layerViewers.add(LayerViewer(layer, map.mapHeader, renderer, viewBounds))
		}
		layerViewers = layerViewers.ro
		pillarRiserMode	= mapHeader.risingPillarMode
	}
	
	// see http://fantom.org/sidewalk/topic/1947#c13080
	private Bool m_pillarRiserMode := false
	override Bool pillarRiserMode {
		set {
			m_pillarRiserMode = it
			layerViewers.each |layerViewer| {
				layerViewer.pillarRiserMode = m_pillarRiserMode
			}
		}
		get { m_pillarRiserMode }
	}
 
	// see http://fantom.org/sidewalk/topic/1947#c13080
	private Point m_coorInPixels := Point.defVal
	override Point coorInPixels {
		set {
			m_coorInPixels = it
			layerViewers.each |layerViewer| {
				layerViewer.coorInPixels = m_coorInPixels
			}
		}
		get { m_coorInPixels }
	}

	// see http://fantom.org/sidewalk/topic/1947#c13080
	override Point coorInBlocks {
		set {
			coor := it
			x := it.x * mapHeader.blockSizeInPixels.w
			y := it.y * mapHeader.blockSizeInPixels.h
			coorInPixels = Point(x, y)			
			layerViewers.each |layerViewer| {
				layerViewer.coorInBlocks = coor
			}
		}
		get {	// kill me!
			x := coorInPixels.x / mapHeader.blockSizeInPixels.w
			y := coorInPixels.y / mapHeader.blockSizeInPixels.h
			return Point(x, y)
		}		
	}
	
	// see http://fantom.org/sidewalk/topic/1947#c13080
	override Void translatePixels(Int x, Int y) {
		coorInPixels = coorInPixels.translate(Point(x, y)) 
		layerViewers.each |layerViewer| {
			layerViewer.translatePixels(x, y)
		}
	}

	// see http://fantom.org/sidewalk/topic/1947#c13080
	override Void translateBlocks(Int x, Int y) {
		coorInBlocks = coorInBlocks.translate(Point(x, y)) 
		layerViewers.each |layerViewer| {
			layerViewer.translateBlocks(x, y)
		}
	}
	
	** A helper method that updates the animation of all the `AnimBlock`s in the `MappyMap`
	Void updateAnimBlocks() {
		map.animBlocks.each |animBlock| {
			animBlock.updateAnimation
		}
	}	
	
	override Void draw(Obj gfx, BlockLayer[] blockLayers := [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3]) {
		layerViewers.each |layerViewer| {
			layerViewer.draw(gfx, blockLayers)
		}
	}

	override Void drawPartial(Obj gfx, Rect dirty, BlockLayer[] blockLayers := [BlockLayer.background, BlockLayer.foreground1, BlockLayer.foreground2, BlockLayer.foreground3]) {
		layerViewers.each |layerViewer| {
			layerViewer.drawPartial(gfx, dirty, blockLayers)
		}		
	}
}
