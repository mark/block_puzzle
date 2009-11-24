﻿import blockpuzzle.base.BPObject;import blockpuzzle.controller.event.BPAction;import blockpuzzle.controller.event.BPEvent;import blockpuzzle.controller.game.*;import blockpuzzle.model.data.BPDirection;import blockpuzzle.model.game.*;import blockpuzzle.view.gui.BPGrid;class blockpuzzle.model.game.BPPatch extends BPObject {	// Controller		var controller:BPPatchController;		// Model		var gameboard:BPBoard;		var locationX:Number;	var locationY:Number;		var info:Object;	// View	var movieClip:MovieClip;	var animationCount:Number;		var frameName:String;	function BPPatch(controller:BPPatchController, key:String) {		this.controller = controller;		this.info = new Object();				this.animationCount = 0;				listenFor("BPPatchAnimationCreated", this, animationCreated);		listenFor("BPPatchAnimationDestroyed", this, animationDestroyed);		setKey(key);		setFrame();	}	// Get rid of this patch, doesn't use undo	function destroy() {		movieClip.removeMovieClip();	}	/****************	*               *	* Board methods *	*               *	****************/		function board():BPBoard {		return gameboard;	}		function attach(gameboard:BPBoard, locationX:Number, locationY:Number) {		this.gameboard = gameboard;				this.locationX = locationX;		this.locationY = locationY;	}		/*******************	*                  *	* Location methods *	*                  *	*******************/		function x():Number {		return locationX;	}		function y():Number {		return locationY;	}	function depth():Number {		return y() * board().width() + x();	}		function distance(other:BPPatch):Number {		var dx = x() - other.x();		var dy = y() - other.y();				return Math.sqrt(dx * dx + dy * dy);	}		function reposition(locationX:Number, locationY:Number) {	    this.locationX = locationX;	    this.locationY = locationY;	    	    if (movieClip) {	        	    }	}		/*******************	*                  *	* Neighbor methods *	*                  *	*******************/		function inDirection(direction:BPDirection, steps:Number):BPPatch {		if (steps == null) steps = 1;				return board().getPatch(x() + steps * direction.dx(), y() + steps * direction.dy());	}		/****************	*               *	* Event methods *	*               *	****************/		function enterEvent(action:BPAction, actor:BPActor) {		return controller.resolveEvent(action, BPEvent.ENTER_EVENT, actor, this);	}		function exitEvent(action:BPAction, actor:BPActor) {		return controller.resolveEvent(action, BPEvent.EXIT_EVENT, actor, this);	}	/*********************	*                    *	* Movie Clip Methods *	*                    *	*********************/		function display(grid:BPGrid) {    	generateMovieClip(grid);		place(grid);		setFrame();	}		function generateMovieClip(grid:BPGrid) {	    var layer = grid.layer('patchLayer');		layer["Patch_" + id()].removeMovieClip();		movieClip = layer.attachMovie(controller.movieClipName(), "Patch_" + id(), id());		movieClip._grid = grid;		return movieClip;	}		function generateMovieClipOverlay(grid:BPGrid) {        var layer = grid.layer('patchLayer');        var geom = grid.geometry();		var overlayMC;				_root["Patch_Overlay_" + depth()].removeMovieClip();        		overlayMC = movieClip.duplicateMovieClip("Patch_Overlay_" + id(), 10000 + id());		overlayMC.gotoAndStop(movieClip._currentframe);				overlayMC._x = geom.leftForPatch(this);		overlayMC._y = geom.topForPatch(this);				overlayMC._width  = geom.lengthForCells(1.0);		overlayMC._height = geom.lengthForCells(1.0);				return overlayMC;	}		function place(grid:BPGrid) {		var geom = grid.geometry();				if (geom) {    		movieClip._x = geom.leftForPatch(this);    		movieClip._y = geom.topForPatch(this);    		movieClip._width  = geom.lengthForCells(1.0);    		movieClip._height = geom.lengthForCells(1.0);    		    		controller.modifyMovieClip(this, movieClip);    		movieClip._visible = true;		} else {		    movieClip._visible = false;		}		/*		// This is more advanced patch placement features.  Might be reimplemented later?  Depends on the Tile Library				if (scaleFactor > 0.0) {			movieClip._width = location.gameboard.widthForCells(scaleFactor);			movieClip._height = location.gameboard.heightForCells(scaleFactor);		}				if (registrationAtCenter) {			movieClip._x += location.gameboard.widthForCells(0.5);			movieClip._y += location.gameboard.heightForCells(0.5);		}		*/	}	function setFrame() {		movieClip.gotoAndStop(controller.frameName(this));		frameName = controller.frameName(this);	}	function setFrameName(fname:String){			movieClip.gotoAndStop(fname);		frameName = fname;	}	function getFrameName(){		return frameName;	}		    /********************    *                   *    * Animation methods *    *                   *    ********************/        // These should make their way into a Sprite class, I think...        function animationCreated(m, s, animation) {        animationCount ++;    }        function animationDestroyed(m, s, animation) {        animationCount --;                if (animationCount == 0) idle();    }    function idle() {        var idleInSeconds = controller.idlePeriod(this);        if (idleInSeconds >= 0) controller.idleAnimation(this).startInSeconds(idleInSeconds);    }    	/*****************************	*                            *	* Saving and Loading methods *	*                            *	*****************************/	function exportPatch():String {		return controller.exportPatch(this);	}	/***************	*              *	* Info methods *	*              *	***************/		function key():String {		return info.key;	}		function setKey(newKey:String) {		info.key = newKey;		// setFrame();	}	function isA(testKey:String):Boolean {		return key() == testKey;	}		function get(infoKey:String) {		return info[infoKey];	}		function set(infoKey:String, value) {		info[infoKey] = value;	}		/******************	*                 *	* Utility methods *	*                 *	******************/		function toString():String {		return "(" + key() + ": " + locationX + ", " + locationY + ")";	}}