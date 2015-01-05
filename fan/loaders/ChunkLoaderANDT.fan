
**
** Chunk ANDT :: Contains ANISTR structures.
** 
@Js
internal class ChunkLoaderANDT : ChunkLoader {
	
		new make(Str chunkName, Buf chunkData, Endian endian) : super(chunkName, chunkData, endian) {}

    // ---- Public Methods ----------------------------------------------------

	override Void loadChunk(MappyMap map) {
		
		// an expensive way of counting the no of AnimBlocks
		aniBlockCount := 0
		index := chunkSize - 16
		while (chunkData[index] != 255) {	// TODO: it should be a signed byte != -1
			aniBlockCount++
			index -= 16
		}

		intSize		:= 1
		imageSize	:= 1
		if (map.mapHeader.mapType == MapType.FMP05) {
			imageSize 	= map.mapHeader.blockSize
			intSize		= 4
		}

		log.info("Reading [${aniBlockCount}] AniBlock properties...")

		AnimBlock[] animBlocks := [,] 
		index = chunkSize - 16
		aniBlockCount = 0
		while (chunkData.get(index) != 255) {	// TODO: it should be a signed byte != -1
			animBlock := AnimBlock()

			animBlock.animFunc		= fromType(chunkData[index+0])
			animBlock.delay			= chunkData[index+1]
			animBlock.delayCountdown= chunkData[index+2]
			animBlock.userData		= chunkData[index+3]

			offset1 				:= getInt(index + 8)
			offset2 				:= getInt(index + 12)
			noOfFrames 				:= (offset2 - offset1) / intSize
			Int[] frames 			:= [,]
			startFrame 				:= (getInt(index + 4) - offset1) / intSize
			animBlock.frames		= frames

			// we can't set the current frame if it hasn't got any frames!
			if (noOfFrames > 0)
				animBlock.frameIndex = startFrame

			// convert values between map types
			if (map.mapHeader.mapType != MapType.FMP05)
				offset1 = (offset1 * 4) - chunkSize

			(0..<noOfFrames).each |j| {
				frames.add(getInt(chunkSize + offset1 - 4) / imageSize) 
				offset1 += 4
			}
			index -= 16

			log.debug("AniBlock [${aniBlockCount}] sequence = ${frames}")

			animBlocks.add(animBlock)
		}

		map.animBlocks = animBlocks

		skip(bytesRemaining)
	}

	protected Int getInt(Int index) {
		d1 := chunkData[index+0].shiftl(8*3)
		d2 := chunkData[index+1].shiftl(8*2)
		d3 := chunkData[index+2].shiftl(8*1)
		d4 := chunkData[index+3].shiftl(8*0)
		data := d1.or(d2).or(d3).or(d4)
		
		if (endian == Endian.little) {
			b1 := data.and(0x000000ff).shiftl(8*3)
			b2 := data.and(0x0000ff00).shiftl(8*1)
			b3 := data.and(0x00ff0000).shiftr(8*1)
			b4 := data.and(0xff000000).shiftr(8*3)
			data = b1.or(b2).or(b3).or(b4)
		}

		return data
	}
	
	protected static |AnimBlock| fromType(Int type) {
		switch (type) {
			case 0:
				return AnimFunc().none;
			case 1:
				return AnimFunc().loopForward;
			case 2:
				return AnimFunc().loopReverse;
			case 3:
				return AnimFunc().animateOnce;
			case 4:
				return AnimFunc().animateOnceAndHalt;
			case 5:
				return AnimFunc().pingPongForwardOutwardLeg;
			case 6:
				return AnimFunc().pingPongForwardReturnLeg;
			case 7:
				return AnimFunc().pingPongReverseOutwardLeg;
			case 8:
				return AnimFunc().pingPongReverseReturnLeg;
			case 9:
				return AnimFunc().animateOnceFinished;
			default:
				throw Err("AnimBlock Type '$type' is not supported");
		}
	}	
}
