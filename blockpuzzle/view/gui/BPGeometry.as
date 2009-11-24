import blockpuzzle.model.game.BPPatch;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPGeometry {
	
	var grid:BPGrid;
	
	var top:Number;
	var left:Number;
	
	var patchSize:Number;
	
	// Depth Location Constants
	
	static var INTERFACE_DEPTH = 100;
	static var FLOOR_DEPTH = 1000;
	static var OVERLAY_DEPTH = 1500;
	static var ACTOR_DEPTH = 2000;
	static var CURSOR_DEPTH = 3000;
	
	// The global geometry object
	
	static var geom:BPGeometry;
	
	function BPGeometry(top:Number, left:Number, patchSize:Number) {
		this.top = top;
		this.left = left;
		this.patchSize = patchSize;
		
		BPGeometry.geom = this;
	}
	
    /**********************
    *                     *
    * Calculation Methods *
    *                     *
    **********************/
    
	function topForPatch(patch:BPPatch):Number {
		return top + patchSize * patch.y();
	}
	
	function yCenterForPatch(patch:BPPatch):Number {
		return top + patchSize * (patch.y() + 0.5);
	}
	
	function leftForPatch(patch:BPPatch):Number {
		return left + patchSize * patch.x();
	}
	
	function xCenterForPatch(patch:BPPatch):Number {
		return left + patchSize * (patch.x() + 0.5);
	}
	
	function screenToGridX(screenX:Number):Number {
		return Math.floor((screenX - left) / patchSize);
	}
	
	function screenToGridY(screenY:Number):Number {
		return Math.floor((screenY - top) / patchSize);
	}

	function lengthForCells(cells:Number):Number {
		return patchSize * cells;
	}

    function patchBoundsToScreenBounds(bounds) {
        var screenBounds = new Object();

        screenBounds.left = left + patchSize * bounds.left;
        screenBounds.right = left + patchSize * (bounds.right + 1) - 1;
        screenBounds.top = top + patchSize * bounds.top;
        screenBounds.bottom = top + patchSize * (bounds.bottom + 1) - 1;
        
        return screenBounds;
    }
    
    function centerInRect(top:Number, left:Number, bottom:Number, right:Number, rows:Number, columns:Number) {
        //calculate screen location based on width and height of board
		var hfc = lengthForCells(rows);
		var wfc = lengthForCells(columns);
		top  = (right - left)/2 - (wfc / 2) + left;
		left = (bottom - top)/2 - (hfc / 2) + top;
    }
    
    /***************
    *              *
    * Grid Methods *
    *              *
    ***************/
    
    function setGrid(grid:BPGrid) {
        this.grid = grid;
    }
    
    function layer(layerName:String) {
        return grid.layer(layerName);
    }
    
    /***************************
    *                          *
    * Loading & Saving Methods *
    *                          *
    ***************************/
    
    function toXml() {
        return "<geometry type='rect' size='" + patchSize + "' />\n";
    }
    
    static function loadFromXml(xml:XML):BPGeometry {
        return new BPGeometry(Number(xml.attributes.top), Number(xml.attributes.left), Number(xml.attributes.size));
    }
    
}
