
@Js
const class Runtime {
	
	static const Str defVer	:= "1.0(JS)"
	
	static Str version() {
		return isJs ? defVer : Runtime#.pod.version.toStr
	}

	static Bool isJs() {
		Env.cur.runtime == "js"
	}

	static Bool isJava() {
		Env.cur.runtime == "java"
	}

	static Bool isDotNet() {
		Env.cur.runtime == "dotnet"
	}
}
