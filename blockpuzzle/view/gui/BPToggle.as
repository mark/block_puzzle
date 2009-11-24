import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPToggle extends BPGuiElement {
    
    var leftFunction:String;
    var rightFunction:String;
    
    var options:Object;
    
    var editActive:Boolean;
    var inDrag:Boolean;
    var dragStart:Number;
    var toggleStart:Number;
    
    function BPToggle(leftFunction:String, rightFunction:String, options:Object) {
        this.leftFunction = leftFunction;
        this.rightFunction = rightFunction;
        this.options = options;

        handleBackground.handle.gotoAndStop("Normal");
        editActive = false;
        inDrag = false;
        dragStart = 0;
        toggleStart = 0;

        activate();
    }

    /***************
    *              *
    * Mouse Events *
    *              *
    ***************/
    
    function mouseDown() {
    	if (handleBackground.hitTest(_xmouse, _ymouse)) {
    		if (handleBackground.handle.hitTest(_xmouse, _ymouse)) {
    			initDrag();
    		} else {
    			inPress = true;
    		}
    	}
    }

    function mouseMove() {
    	if (inDrag) duringDrag();
    }

    function mouseUp() {
    	endDrag();
    }

    /*******************
    *                  *
    * Toggle Functions *
    *                  *
    *******************/
    
    function initDrag() {
    	inDrag = true;
    	dragStart = handleBackground._xmouse;
    	toggleStart = handleBackground.handle._x;
    	handleBackground.handle.gotoAndStop("Highlight");
    }

    function duringDrag() {
    	var current = handleBackground._xmouse;
    	var newX = toggleStart + (current - dragStart);

    	if (newX < 0) newX = 0;
    	if (newX > 60) newX = 60;

    	handleBackground.handle._x = newX;
    }

    function endDrag() {
    	if (inDrag && Math.abs(handleBackground._xmouse - dragStart) < 2) {
    		// Really a press action

    		if (editActive) {
    			deactivate();
    		} else {
    			activate();
    		}
    	}

    	if (inPress && handleBackground.hitTest(_xmouse, _ymouse)) {
    		if (editActive) {
    			deactivate();
    		} else {
    			activate();
    		}
    	}

    	inPress = false;
    	inDrag = false;
    	handleBackground.handle.gotoAndStop("Normal");

    	if (handleBackground.handle._x > 30) {
    		if (! editActive)
    			activate();
    		else
    			handleBackground.handle._x = 60;

    	} else {
    		if (editActive)
    			deactivate();
    		else
    			handleBackground.handle._x = 0;
    	}
    }

    function activate() {
    	editActive = true;
    	handleBackground.handle._x = 60;
    	myEditText.gotoAndStop("On");

    	if (_root.activateFunction)
    		getURL("javascript:" + activateFunction);
    }

    function deactivate() {
    	editActive = false;
    	handleBackground.handle._x = 0;
    	myEditText.gotoAndStop("Off");

    	if (_root.deactivateFunction)
    		getURL("javascript:" + deactivateFunction);
    }
}