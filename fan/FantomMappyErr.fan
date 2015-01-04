
@Js
const class FantomMappyErr : Err {
	new make(Str msg := "", Err? cause := null) : super.make(msg, cause) {}
}

@Js
const class ChunkLoadErr : FantomMappyErr {
	new make(Str msg := "", Err? cause := null) : super.make(msg, cause) {}	
}