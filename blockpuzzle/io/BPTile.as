class blockpuzzle.io.BPTile {
	
	var _frame:String;

	var _key:String;
	
	var xmlChars:String;

	function BPTile(key:String, xmlChars:String, frame:String) {
		this._key = key;
		this.xmlChars = xmlChars;
		this._frame = frame == null ? key : frame;
	}

	function key() {
		return _key;
	}
	
	function frame() {
		return _frame;
	}
	
	function actsAsTile(tile:String):Boolean {
		return xmlChars.indexOf(tile) != -1;
	}
	
	function toXml():String {
		return xmlChars.charAt(0);
	}
	
}