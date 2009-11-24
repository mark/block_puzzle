class blockpuzzle.model.data.BPColor {
	
	var name:String;
	var cap:String;
	var lower:String;
	var hex:Number;
	
	static var Colors = new Array();
	
	function BPColor(name, cap, lower, hex) {
		this.name = name;
		this.cap = cap;
		this.lower = lower;
		this.hex = hex;
		
		if (name != "No Color") BPColor.Colors.push(this);
	}
	
	static var Red =	 new BPColor("Red",	     "R", "r", 0xDD0000);
	static var Orange =	 new BPColor("Orange",	 "O", "o", 0xFF6600);
	static var Yellow =	 new BPColor("Yellow",	 "Y", "y", 0xFFFF33);
	static var Green =	 new BPColor("Green",	 "G", "g", 0x00DD00);
	static var Cyan =    new BPColor("Cyan",     "C", "c", 0x00FFFF);
	static var Blue =	 new BPColor("Blue",	 "B", "b", 0x0000DD);
	static var Purple =	 new BPColor("Purple",	 "P", "p", 0x990099);
	static var Black =	 new BPColor("Black",	 "K", "k", 0x000000);
	static var Grey =    new BPColor("Grey",     "E", "e", 0x999999);

	static var NoColor = new BPColor("No Color", "X", "x", 0xFFFFFF);
	
	static function getColor(by:String):BPColor {
		for (var i = 0; i < Colors.length; i++) {
			var color = Colors[i];
			if (by == color.name || by == color.cap || by == color.lower)
				return color;
		}
		return NoColor; // No color found
	}
		
	function toString():String {
		return "Color{" + name + ": #" + hex + "}"
	}

}