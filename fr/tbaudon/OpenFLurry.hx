package fr.tbaudon ;

#if (android && openfl)
import openfl.utils.JNI;
#end


class OpenFLurry {
	
	/**************************************************************/
	// JNI LINKING
	/*
	 * jni type cheat sheet :
	 * parameter type beetween (), return type after ()
	 * nonBasicObject : Lpath/to/class;
	 * void : V
	 * bool : Z
	 * int : I
	 * Sample : (Ljava/lang/String;I)Z = function(String, Int) : bool
	 */
	// STATIC METHOD
	#if android
	private static var startSession_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLurry", "init", "(Ljava/lang/String;Z)V");
	private static var logEvent_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLurry", "logEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V");
	private static var endTimedEvent_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLurry", "endTimedEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var onPageView_jni = JNI.createStaticMethod("fr.tbaudon.OpenFLurry", "logPage", "()V");
	#end
	
	public static function initSession(apiKey : String, verbose : Bool = false) {
		#if android
		startSession_jni(apiKey, verbose);
		#end
	}
	
	public static function logEvent(eventName : String, params : Map<String, String> = null, timed : Bool = false) {
		#if android
		var keys : String = "";
		var values : String = "";
		
		if (params != null) {
			var serializedMap = serializeMap(params);
			keys = serializedMap.keys;
			values = serializedMap.values;
		}	
			
		logEvent_jni(eventName, keys, values, timed);
		#end
	}
	
	public static function endTimedEvent(eventName :String, params : Map<String, String> = null) {
		#if android
		var keys : String = "";
		var values : String = "";
		
		if (params != null) {
			var serializedMap = serializeMap(params);
			keys = serializedMap.keys;
			values = serializedMap.values;
		}	
		
		endTimedEvent_jni(eventName, keys, values);
		#end
	}
	
	static public function onPageView() {
		#if android
		onPageView_jni();
		#end
	}
	
	static function serializeMap(map : Map<String, String>) : { keys : String, values : String } {
		var k : String = "";
		var v : String = "";
		
		for (key in map.keys()) {
			k += key + ';';
			v += map[key] + ';';
		}
		
		k = k.substr(0, k.length - 1);
		v = v.substr(0, v.length - 1);
		
		return { keys : k, values : v };
	}
}