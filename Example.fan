using gfx
using fwt
using web
using afFantomMappy

class Example {
    Void main() {
        fmaBuf  := WebClient(`http://static.alienfactory.co.uk/fantom-docs/alienEpidemic.fma`).getBuf
        pngBuf  := WebClient(`http://static.alienfactory.co.uk/fantom-docs/alienEpidemic.png`).getBuf
        pngFile := File.createTemp("alienEmdemic", "png").deleteOnExit
        pngFile.out.writeBuf(pngBuf).close

        map      := MapLoader.loadMap(fmaBuf.in)
        blocks   := Image(pngFile)
        renderer := FmaRenderer(map.mapHeader, blocks, true)
        canvas   := MappyCanvas(map, renderer)
        
        animate  := (Func?) null; animate = |->| {
            canvas.animate
            canvas.repaint
            Desktop.callLater(30ms, animate)
        }
        
        Window(null) {
            it.resizable = false
            it.title     = "Alien Epidemic"
            it.size      = Size(320, 240)
            it.content   = canvas
            it.onOpen.add(animate)
        }.open
    }    
}

class MappyCanvas : Canvas {
    private MappyMap    map
    private Renderer    renderer
    private Int         speedX    := Int.random(1..4)
    private Int         speedY    := Int.random(1..4)
    
    new make(MappyMap map, Renderer renderer) {
        doubleBuffered  = true
        this.map        = map
        this.renderer   = renderer
    }

    Void animate() {
        mapViewer.updateAnimBlocks
        viewer := mapViewer.layerViewers[0]
        viewer.translatePixels(speedX, speedY)

        if (viewer.coorInPixels.x < 0) {
            speedX = -speedX ; viewer.translatePixels(speedX, 0)
        }
        if (viewer.coorInPixels.x >= (mapViewer.mapHeader.mapSizeInPixels.w - size.w)) {
            speedX = -speedX ; viewer.translatePixels(speedX, 0)
        }
        if (viewer.coorInPixels.y < 0) {
            speedY = -speedY ; viewer.translatePixels(0, speedY)
        }
        if (viewer.coorInPixels.y >= (mapViewer.mapHeader.mapSizeInPixels.h - size.h)) {
            speedY = -speedY ; viewer.translatePixels(0, speedY)
        }
    }

    once MapViewer mapViewer() {
        mapViewer := MapViewer(map, renderer, Rect(Point.defVal, size))

        x := Int.random(0..<map.mapHeader.mapSizeInPixels.w - size.w)
        y := Int.random(0..<map.mapHeader.mapSizeInPixels.h - size.h)
        mapViewer.coorInPixels = Point(x, y)
        
        return mapViewer
    }
    
    override Void onPaint(Graphics g) {
        g.brush = Color.black
        g.fillRect(0, 0, size.w, size.h)
        mapViewer.draw(g)
    }
}