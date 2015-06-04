
** As thrown by 'FantomMappy'.
@Js
const class FantomMappyErr : Err {
	new make(Str msg := "", Err? cause := null) : super.make(msg, cause) {}
}

** Thrown if there was a problem loading a map Chunk.
@Js
const class ChunkLoadErr : FantomMappyErr {
	new make(Str msg := "", Err? cause := null) : super.make(msg, cause) {}	
}