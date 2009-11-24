import blockpuzzle.controller.game.BPController;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPSelectionRectangle {
    
    var clip:MovieClip;
    
    var controller:BPController;
    var grid:BPGrid;
    
    function BPSelectionRectangle(controller:BPController, grid:BPGrid) {
        this.controller = controller;
        this.grid = grid;
        
        this.clip = _root.createEmptyMovieClip("BPSelectionRectangle", BPGeometry.CURSOR_DEPTH);
    }
    
    function redrawForBounds(bounds) {
        clip.clear();
        clip.lineStyle(2, 0);
        
        var screenBounds = grid.geometry().patchBoundsToScreenBounds(bounds);
        
        dashTo(screenBounds.left,  screenBounds.top,    screenBounds.right, screenBounds.top,       6,    6);
        dashTo(screenBounds.right, screenBounds.top,    screenBounds.right, screenBounds.bottom,    6,    6);
        dashTo(screenBounds.right, screenBounds.bottom, screenBounds.left,  screenBounds.bottom,    6,    6);
        dashTo(screenBounds.left,  screenBounds.bottom, screenBounds.left,  screenBounds.top,       6,    6);
        
        show();
    }
    
    function hide() { clip._visible = false; }
    function show() { clip._visible = true; }
    
    function dashTo(startx, starty, endx, endy, len, gap) {
    	// ==============
    	// mc.dashTo() - by Ric Ewing (ric@formequalsfunction.com) - version 1.2 - 5.3.2002
    	// 
    	// startx, starty = beginning of dashed line
    	// endx, endy = end of dashed line
    	// len = length of dash
    	// gap = length of gap between dashes
    	// ==============
    	
    	// if too few arguments, bail
    	if (arguments.length < 6) {
    		return false;
    	}
    	// init vars
    	var seglength, deltax, deltay, delta, radians, segs, cx, cy;

    	// calculate the legnth of a segment
    	seglength = len + gap;

    	// calculate the length of the dashed line
    	deltax = endx - startx;
    	deltay = endy - starty;
    	delta = Math.sqrt((deltax * deltax) + (deltay * deltay));

    	// calculate the number of segments needed
    	segs = Math.floor(Math.abs(delta / seglength));

    	// get the angle of the line in radians
    	radians = Math.atan2(deltay,deltax);

    	// start the line here
    	cx = startx;
    	cy = starty;

    	// add these to cx, cy to get next seg start
    	deltax = Math.cos(radians)*seglength;
    	deltay = Math.sin(radians)*seglength;

    	// loop through each seg
    	for (var n = 0; n < segs; n++) {
    		clip.moveTo(cx,cy);
    		clip.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
    		cx += deltax;
    		cy += deltay;
    	}

    	// handle last segment as it is likely to be partial
    	clip.moveTo(cx,cy);
    	delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
    	if(delta>len){
    		// segment ends in the gap, so draw a full dash
    		clip.lineTo(cx+Math.cos(radians)*len,cy+Math.sin(radians)*len);
    	} else if(delta>0) {
    		// segment is shorter than dash so only draw what is needed
    		clip.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
    	}
    	// move the pen to the end position
    	clip.moveTo(endx,endy);
    }

}