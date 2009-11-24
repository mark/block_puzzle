import blockpuzzle.base.BPObject;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPGuiElement extends BPObject {
    
    static var namedElements = new Object();
    
    var name:String;
    
    var controller:BPController;
    var banks:Array;
    
    var movieClip:MovieClip;
    
    var top:Number;
    var left:Number;
    var fraction:Number;
    
    function BPGuiElement(controller:BPController, makeBlankMovieClip:Boolean) {
        this.controller = controller;
        this.banks = new Array();
        
        this.top = 0.0;
        this.left = 0.0;
        this.fraction = 1.0;
        
        if (makeBlankMovieClip) createMovieClip();
    }

    /*********************
    *                    *
    * Movie Clip Methods *
    *                    *
    *********************/
    
    function movieClipName():String {
        return "Gui_Element_" + id();
    }
    
    function depth():Number {
        return BPGeometry.INTERFACE_DEPTH + id();
    }
    
    function isHit():Boolean {
        return movieClip.hitTest(_xmouse, _ymouse);
    }
    
    function createMovieClip(linkageName:String):MovieClip {
        if (linkageName != null)
            movieClip = _root.attachMovie(linkageName, movieClipName(), depth());
        else
            movieClip = _root.createEmptyMovieClip(movieClipName(), depth());
            
        movieClip._controller = this;
        //movieClip._visible = true;
        movieClip._visible = false;
        
        return movieClip;
    }
    
    /****************
    *               *
    * Mouse Methods *
    *               *
    ****************/
    
    function xScreen() {
        return movieClip._xmouse;
    }
    
    function yScreen() {
        return movieClip._ymouse;
    }
    
    /*******************
    *                  *
    * Position Methods *
    *                  *
    *******************/
    
    function at(top:Number, left:Number):BPGuiElement {
        this.top = top;
        this.left = left;
        
        movieClip._x = left;
        movieClip._y = top;
        
        return this;
        
        //trace("top = " + top + "\tleft = " + left);
    }

    function scale(fraction:Number):BPGuiElement {
        movieClip._width = movieClip._width * fraction;
        movieClip._height = movieClip._height * fraction;
        this.fraction = fraction;
        
        return this;
    }

    /***************
    *              *
    * Name Methods *
    *              *
    ***************/
    
    function setName(name:String) {
        if (namedElements[name] == null) {
            this.name = name;
            namedElements[name] = this;
        } else {
            //trace("ERROR: Duplicate name: '" + name + "'");
        }
    }
    
    function isNamed(name:String):Boolean {
        return this.name == name;
    }

    static function named(name:String) {
        return namedElements[name];
    }
    
    /***************
    *              *
    * Bank Methods *
    *              *
    ***************/
    
    function addToBank(bank:String) {
        banks.push(bank);
    }

    function allBanks():String {
        return banks.join(",");
    }
    
    /****************
    *               *
    * Event Methods *
    *               *
    ****************/
    
    function onMouseDown() { }
    function onMouseUp() { }
    function onMouseMove() { }

    function addMouseEvents() {
        var guiElement = this;
        
        movieClip.onMouseDown = function() { if (guiElement.movieClip.hitTest(_xmouse, _ymouse)) guiElement.onMouseDown(); };
        movieClip.onMouseUp   = function() { if (guiElement.movieClip.hitTest(_xmouse, _ymouse)) guiElement.onMouseUp();   };
        movieClip.onMouseMove = function() { if (guiElement.movieClip.hitTest(_xmouse, _ymouse)) guiElement.onMouseMove(); };
    }

    function removeMouseEvents() {
        movieClip.onMouseDown = null;
        movieClip.onMouseUp = null;
        movieClip.onMouseMove = null;
    }

    /******************
    *                 *
    * Display Methods *
    *                 *
    ******************/
    
    function hide() { movieClip._visible = false; removeMouseEvents(); }
    function show() { movieClip._visible = true;  addMouseEvents();    }

}
