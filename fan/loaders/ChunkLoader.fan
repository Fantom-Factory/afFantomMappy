
@Js
abstract internal class ChunkLoader {
	protected static const Log 	log := ChunkLoader#.pod.log

	** The 4 character name of the chunk. e.g. ANDT, BODY
	Str		chunkName
	
	** The actual Chunk Data
    Buf		chunkData
	
	Endian	endian
	

	
	// ---- Constructors ------------------------------------------------------
	
	new make(Str chunkyName, Buf chunkyData, Endian endiany) {
		chunkName	= chunkyName
		chunkData	= chunkyData
		endian		= endiany
	}

	
	
    // ---- Public Methods ----------------------------------------------------
	
	** The total number of bytes in this chunk.
	public Int chunkSize() {
		chunkData.size
	}
	
	** The number of 'bytes' yet to be read for this chunk.
	public Int bytesRemaining() {
		chunkData.remaining
	}
	
	** Pretty print
	override Str toStr() {
		"ChunkLoader :: Name=[$chunkName] Size=[$chunkSize]"
	}	
	
	** The method invoked to load the chunk. All data loaded should by placed in
	** the given Map. 
	** Throws ChunkLoadErr should be thrown should anything go wrong. 
	abstract Void loadChunk(MappyMap map)
	
	
	
    // ---- Protected Methods -------------------------------------------------
	
	** Throws a `ChunkLoadErr` with a formatted message
	protected Void throwChunkLoadErr(Obj msg) {
		throw ChunkLoadErr("Chunk $chunkName - $msg")
	}
	
	** Reads the next *n* bytes from the Map input stream and turns them into a 'Str'.
	protected Str readStr(Int noOfChars) {
		if (noOfChars < 0) throw ArgErr("Input parameter [noOfChars] can not be less than zero :: noOfChars=[$noOfChars]")
		if (noOfChars > bytesRemaining) throwChunkLoadErr("No more bytes left in Chunk!")

		// convert the bytes into a Str
		return chunkData.readChars(noOfChars)
	}

	** Reads characters until a terminating zero is found and returns the 'Str'.
	** Note the zero is consumed.
	protected Str readLine() {
		str := ""
		while (chunkData.peek != 0)
			str += chunkData.readChar.toChar
		
		// consume the zero
		chunkData.read
		
		return str 
	}
	
	** Read the next byte as an unsigned 8-bit number
	protected Int readU1() {
		if (1 > bytesRemaining) throwChunkLoadErr("No more bytes left in Chunk!")
		return chunkData.readU1
	}		

	** Read the next byte as a signed 8-bit number
	protected Int readS1() {
		if (1 > bytesRemaining) throwChunkLoadErr("No more bytes left in Chunk!")
		return chunkData.readS1
	}	

	** Read the next 2 bytes as a signed 16-bit number using configured `endian`
	protected Int readS2() {
		if (2 > bytesRemaining) throwChunkLoadErr("No more bytes left in Chunk!")
		data := chunkData.readU2
		// Damn it! JS Bufs have no Endian, so we gotta do it ourselves!
		if (endian == Endian.little) {
			b1 := data.and(0x00ff).shiftl(8)
			b2 := data.and(0xff00).shiftr(8)
			data = b1.or(b2)
		}
		
		// sign it
		if (data >= 32768) data -= 65536;
		return data
	}	

	** Read the next 4 bytes as a signed 32-bit number using configured `endian`
	protected Int readS4() {
		if (4 > bytesRemaining) throwChunkLoadErr("No more bytes left in Chunk!")
		// Damn it! JS Bufs have no Endian, so we gotta do it ourselves!
		data := chunkData.readU4
		if (endian == Endian.little) {
			b1 := data.and(0x000000ff).shiftl(8*3)
			b2 := data.and(0x0000ff00).shiftl(8*1)
			b3 := data.and(0x00ff0000).shiftr(8*1)
			b4 := data.and(0xff000000).shiftr(8*3)
			data = b1.or(b2).or(b3).or(b4)
		}
		return data
	}	
		
    ** Skips the next *n* 'bytes' from the Map InStream
	protected Void skip(Int noOfBytes) {
		if (noOfBytes < 0) throw ArgErr("Input parameter [noOfBytes] can not be less than zero :: noOfBytes=[$noOfBytes]")
		if (noOfBytes > bytesRemaining) throwChunkLoadErr("No more bytes left in Chunk!")

		chunkData.seek(chunkData.pos + noOfBytes)
	}
	
	
    // ---- Package Methods ---------------------------------------------------

	
}
