#FantomMappy v1.0.4
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v1.0.4](http://img.shields.io/badge/pod-v1.0.4-yellow.svg)](http://www.fantomfactory.org/pods/afFantomMappy)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

FantomMappy is a playback library for rectangular, hexagonal and isometric tile maps created with [Mappy](http://tilemap.co.uk/mappy.php).

![Mappy Screenshot](http://pods.fantomfactory.org/pods/afFantomMappy/doc/mappy.png)

Use [Mappy](http://tilemap.co.uk/mappy.php) to create your maps, then use `FantomMappy` to embedd them in your games / applications.

## Install

Install `FantomMappy` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afFantomMappy

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afFantomMappy 1.0"]

## Documentation

Full API & fandocs are available on the [Fantom Pod Repository](http://pods.fantomfactory.org/pods/afFantomMappy/).

## Quick Start

1. Create a text file called `Example.fan`

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


2. Run `Example.fan` as a Fantom script from the command line:

        C:\> fan Example.fan
        
        [afFantomMappy] Loading Map from InputStream
        [afFantomMappy] ChunkLoader :: Name=[FORM] Size=[4]
        [afFantomMappy] ChunkLoader :: Name=[ATHR] Size=[100]
        [afFantomMappy] Author      :: Robin Burrows
        [afFantomMappy] Description :: Test map for Alien Epidemic - 8/7/98
        [afFantomMappy]             :: Altered by Alien-Factory for use in JavaMappy
        [afFantomMappy]             ::
        [afFantomMappy] Chunk [ATHR] still has [2] bytes remaining, skipping...
        [afFantomMappy] ChunkLoader :: Name=[MPHD] Size=[40]
        [afFantomMappy] FMP Version       = [1.0]
        [afFantomMappy] LSB               = [little]
        [afFantomMappy] Map Type          = [FMP10]
        [afFantomMappy] Map Size Blocks   = [40,40]
        [afFantomMappy] Reserved 1        = [17]
        [afFantomMappy] Reserved 2        = [0]
        [afFantomMappy] Block Size Pixels = [16,16]
        [afFantomMappy] Colour Depth      = [8]
        [afFantomMappy] Block Size        = [32]
        [afFantomMappy] No. Of Blocks     = [88]
        [afFantomMappy] No. Of Images     = [73]
        [afFantomMappy] Chrome Key Index  = [0]
        [afFantomMappy] Chrome Key        = [#ff00ff]
        [afFantomMappy] Block Gap         = [16,16]
        [afFantomMappy] Block Stagger     = [0,0]
        [afFantomMappy] Click Mask        = [0]
        [afFantomMappy] RisingPillarMode  = [false]
        [afFantomMappy] ChunkLoader :: Name=[EDHD] Size=[300]
        [afFantomMappy] ChunkLoader :: Name=[EPHD] Size=[40]
        [afFantomMappy] ChunkLoader :: Name=[LSTR] Size=[16]
        [afFantomMappy] ChunkLoader :: Name=[CMAP] Size=[768]
        [afFantomMappy] ChunkLoader :: Name=[BKDT] Size=[2816]
        [afFantomMappy] Reading [88] block properties...
        [afFantomMappy] ChunkLoader :: Name=[ANDT] Size=[644]
        [afFantomMappy] Reading [8] AniBlock properties...
        [afFantomMappy] ChunkLoader :: Name=[BODY] Size=[3200]



And you should see a window with an animated map:

![FantomMappy QuickStart Example](http://pods.fantomfactory.org/pods/afFantomMappy/doc/quickStart.png)

## Usage

Most of the [QuickStart](#quickStart) example is `fwt` code, the actual FantomMappy usage is quite simple.

Use [MapLoader](http://pods.fantomfactory.org/pods/afFantomMappy/api/MapLoader) to load the Mappy `.fmp` or `.fma` files:

    map := MapLoader.loadMap(inStream)

Create a `Renderer` that will render the block images:

    renderer := FmaRenderer(map.mapHeader, blockImage, true)

Use a [Viewer](http://pods.fantomfactory.org/pods/afFantomMappy/api/Viewer) to view the map, usually you would render it to an [fwt Canvas](http://fantom.org/doc/fwt/Canvas.html). You can use a [MapViewer](http://pods.fantomfactory.org/pods/afFantomMappy/api/MapViewer) or a [LayerViewer](http://pods.fantomfactory.org/pods/afFantomMappy/api/LayerViewer).

    mapViewer := MapViewer(map, renderer, Rect(x, y, w, h))
    mapViewer.draw(g)

And that's about it.