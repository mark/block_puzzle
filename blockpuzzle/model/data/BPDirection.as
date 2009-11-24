class blockpuzzle.model.data.BPDirection {
    
	var offsetX:Number;
	var offsetY:Number;
	
	// Direction constants

	static var I     = new BPDirection( 0,  0);
                     
	static var North = new BPDirection( 0, -1);
	static var South = new BPDirection( 0,  1);
                     
	static var East  = new BPDirection( 1,  0);
	static var West  = new BPDirection(-1,  0);

	// Numeric constants
	
    static var TO_DEGREE = 180.0 / Math.PI;

	/*****************************************
	*                                        *
	* Constructor and Initialization methods *
	*                                        *
	*****************************************/
	
	// This should be private
	function BPDirection(offsetX:Number, offsetY:Number) {
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}
	
	static function getDirection(arrowKey:Number):BPDirection {
		if (arrowKey < 37 || arrowKey > 40)
			return I;
		else
			return [West, North, East, South][arrowKey - 37];
	}
	
	/*****************
	*                *
	* Atomic methods *
	*                *
	*****************/
	
	function dx():Number {
		return offsetX;
	}
	
	function dy():Number {
		return offsetY;
	}

	/************
	*           *
	* Operators *
	*           *
	************/
	
	function inverse():BPDirection {
		return new BPDirection(-dx(), -dy());
	}
	    
	function rotateClockwise():BPDirection {
		return new BPDirection(-dy(), dx());
	}
	
	function rotateCounterClockwise():BPDirection {
		return new BPDirection(dy(), -dx());
	}
	
	/*********************
	*                    *
	* Comparison methods *
	*                    *
	*********************/
	
	function equals(other):Boolean {
		return dx() == other.dx() && dy() == other.dy();
	}
	
	function opposite(other):Boolean {
		return dx() == -other.dx() && dy() == -other.dy();
	}
	
	/****************
	*               *
	* Angle methods *
	*               *
	****************/
	
	function rotationInRadians():Number {
        return Math.atan2(dy(), dx());
	}
	
	function rotationInDegrees():Number {
        return rotationInRadians() * TO_DEGREE;
    }
    
	/******************
	*                 *
	* Utility methods *
	*                 *
	******************/
	
	function toString():String {
	    if (this.equals(North)) return "North";
	    if (this.equals(South)) return "South";
	    if (this.equals(East))  return "East";
	    if (this.equals(West))  return "West";

		return "->(" + offsetX + ", " + offsetY + ")";
	}

}