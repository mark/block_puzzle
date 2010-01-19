import blockpuzzle.base.BPObject;
import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.*;
import blockpuzzle.model.data.*;
import blockpuzzle.model.game.*;
import blockpuzzle.model.collection.BPRegion;
import blockpuzzle.view.animation.BPAnimation;
import blockpuzzle.view.gui.BPButton;
import blockpuzzle.view.gui.BPGeometry;
import blockpuzzle.view.sprite.*;

class blockpuzzle.controller.game.BPActorController extends BPObject {

	var controller:BPController;

	// Saving / Loading representations
	
	var boardString:String;
	
	var attributeHash:Object;
	
	// Sprites for the actors
	
	var sprites:Object;
	var animationCounts:Object;
	
	function BPActorController(controller:BPController) {
		this.controller = controller;
		
		controller.addActorController(this);
		
		boardString = "";
		
		sprites = new Object();
		animationCounts = new Object();
	}
	
	function board():BPBoard {
		return controller.board();
	}
	
	function canBePlayer(actor:BPActor) {
		return false;
	}
	
	function isGood(actor:BPActor) {
	    return false;
	}
	
	/*********************
	*                    *
	* Movie Clip Methods *
	*                    *
	*********************/
	
	function movieClipName(actor:BPActor):String { return key(null); }
	
	function frameName(actor:BPActor):String { return null; }
	
	function modifyMovieClip(actor:BPActor, movieClip:MovieClip) { }
	
	function regionForActorAtLocation(actor:BPActor, location:BPPatch):BPRegion {
		return new BPRegion( [location] );
	}
	
	function key(options):String {
		return null;
	}
	
	function getDimensions(actor:BPActor) {
		//actor.setDimensions(1.0, 1.0);
		return [ 1.0, 1.0 ];
	}
	
	function registrationAtCenter(actor:BPActor):Boolean { return false; }

	function resolveEvent(action:BPAction, eventType:String, source:BPActor, target:BPActor):Boolean {
		var eventMethod:Function;

		eventMethod = this["can" + eventType + target.key()];

		if (eventMethod == null) eventMethod = this["can" + eventType];

		return eventMethod.call(this, action, source, target);
	}

	function performedActionFromLocation(actor:BPActor, action, originalPosition:BPPatch) {
		// SUBCLASS ONLY!
	}

    /*****************
    *                *
    * Sprite Methods *
    *                *
    *****************/
    
    function spriteForActor(actor:BPActor):BPCompositeSprite {
        // Note that this might not return a sprite, if one does not exist...
        return sprites[ actor.id() ];
    }
    
    function generateSpriteForActor(actor:BPActor, geometry:BPGeometry):BPCompositeSprite {
        var parent   = geometry.layer('actorLayer');
        var centered = registrationAtCenter(actor);
        
        // Generate the sprite itself...
        var sprite = new BPCompositeSprite(actor, { parent: parent, actor: actor, centered: centered, geometry: geometry });
        
        // Store it as the sprite for the provided actor...
        sprites[actor.id()] = sprite;

        // Initialize the sprite...
        initializeSprite(actor, sprite);

        // The sprite starts out idle...
        //spriteIdle(actor);
        
        return sprite;
    }
    
    function displayActor(actor:BPActor, geometry:BPGeometry) {
        var sprite = spriteForActor(actor);
        
        if (sprite == null) sprite = generateSpriteForActor(actor, geometry);
        
        if (actor.location != null) placeActor(actor, sprite);
        
        resizeActor(actor, sprite);
    }
    
    function placeActor(actor:BPActor, sprite:BPSprite):BPAnimation {
        // Place the sprite in the actor's location...
        return sprite.goto(actor.location);
    }
    
    function resizeActor(actor:BPActor, sprite:BPSprite):BPAnimation {
        // Resize the sprite to the current screen size...
		return sprite.resize(getDimensions(actor));
    }
    
    function initializeSprite(actor:BPActor, sprite:BPCompositeSprite) {
        // Set it to the correct clip and frame
        var clip = sprite.addSpriteLayer(movieClipName(actor), 0);
        if (frameName(actor)) clip.setFrame(frameName(actor));
        
    }
    
    /*************************
    *                        *
    * Idle Animation Methods *
    *                        *
    *************************/
    
    function idleAnimation(actor:BPActor):BPAnimation {
        return null;
    }
    
    function idlePeriod(actor:BPActor):Number {
        return -1; // No idle animation
    }
    
    function animationCreated(actor:BPActor, anim) {
        if (animationCounts[ actor.id() ] == null) animationCounts[ actor.id() ] = 0;
        
        animationCounts[ actor.id() ]++;
        
        //trace("++ Actor " + actor + " has " + animationCounts[ actor.id() ] + " animations. <" + anim.id() + ">");
    }
    
    function animationStopped(actor:BPActor, anim) {
        animationCounts[ actor.id() ]--;
        
        //trace("-- Actor " + actor + " has " + animationCounts[ actor.id() ] + " animations. <" + anim.id() + ">");

        if (animationCounts[ actor.id() ] == 0) spriteIdle(actor);
    }
    
    function spriteIdle(actor:BPActor) {
        var idleInSeconds = idlePeriod(actor);

        if (idleInSeconds >= 0) idleAnimation(actor).startInSeconds(idleInSeconds);
    }
    
    /*********************
    *                    *
    * Default Animations *
    *                    *
    *********************/
    
    function animateMove(actor:BPActor, action:BPMoveAction) {
	    return spriteForActor(actor).goto(action.newPosition, { speed: 3.0 });
	}
	
	/************************
	*                       *
	* Default Event methods *
	*                       *
	************************/
	
	// Active form
	function canStepOn(action:BPAction, source:BPActor, target:BPActor)        { action.succeed(); }
	
	// Passive form
	function canBeSteppedOnBy(action:BPAction, source:BPActor, target:BPActor) { action.fail();    }
	
	// Active form
	function canLeave(action:BPAction, source:BPActor, target:BPActor)         { action.succeed(); }
	
	// Passive form
	function canBeLeftBy(action:BPAction, source:BPActor, target:BPActor)      { action.succeed(); }

    /*************************
    *                        *
    * Representation Methods *
    *                        *
    *************************/
    
    function setBoardString(boardString:String) {
        this.boardString = boardString;
    }
    
    function attributes(attributeHash:Object) {
        this.attributeHash = attributeHash;
    }
    
    /******************
    *                 *
    * Loading Methods *
    *                 *
    ******************/
    
	function createActor(options):BPActor {
		var actor = new BPActor(this, key(options), options);
		initializeActor(actor);

		return actor;
	}

	function initializeActor(actor) {
	    // SUBCLASS ME!
	}
	
    function loadActor(where, options):BPActor {
		var newActor = createActor(options);
		
		if (where instanceof BPBoard) {
		    where.addActor(newActor);
		} else if (where instanceof BPPatch) {
		    where.board().addActor(newActor, where);
		}
		
		return newActor;
	}
	
    function loadFromBoard(patch, tile:String) {
        if (boardString.indexOf(tile) != -1)
            loadActor(patch, { char: tile });
    }
    
	function loadActorFromXml(board:BPBoard, properties:Array):BPActor {
	    var x:Number, y:Number;
	    var options = new Object();
	    
	    var includeLocation = attributeHash.location == null || attributeHash.location == true;

	    for (var k = 0; k < properties.length; k++) {
			var key = properties[k].nodeName;
			var value = properties[k].childNodes[0].nodeValue;
			
			if (key == "x" && includeLocation) {
			    x = Number(value);
			} else if (key == "y" && includeLocation) {
			    y = Number(value);
			} else if (attributeHash[key] == "Number") {
			    options[key] = Number(value);
			} else if (attributeHash[key] == "Boolean") {
			    options[key] = (value == "yes");
			} else if (attributeHash[key] == "Color") {
			    options[key] = BPColor.getColor(value);
			} else if (attributeHash[key] == "String") {
			    options[key] = value;
			} else if (attributeHash[key] == "Direction") {
			    options[key] = BPDirection[value];
			}
		}
	    
	    if (includeLocation) {
	        var patch = board.getPatch(x, y);
	        
	        return loadActor(patch, options);
	    } else {
	        return loadActor(board, options);
	    }
	}
	
	/*****************
	*                *
	* Saving Methods *
	*                *
	*****************/
	
	function includeOnBoard(actor:BPActor) {
		return boardString.length > 0;
	}
	
	function toXml(actor:BPActor):String {
	    if (includeOnBoard(actor)) return boardString.charAt(0);

        var xml = "\t<" + actor.key() + ">\n";
        
        if (attributeHash.location == null || attributeHash.location == true) {
            xml += "\t\t<x>" + actor.location.x() + "</x>\n";
            xml += "\t\t<y>" + actor.location.y() + "</y>\n";
        }
        
        for (var attr in attributeHash) {
            if (attr != "location") {
                if (attributeHash[attr] == "Boolean") {
                    xml += "\t\t<" + attr + ">" + (actor.get(attr) ? "yes" : "no") + "</" + attr + ">\n";
                } else if (attributeHash[attr] == "Color") {
                    xml += "\t\t<" + attr + ">" + actor.get(attr).name + "</" + attr + ">\n";
                } else {
                    xml += "\t\t<" + attr + ">" + actor.get(attr) + "</" + attr + ">\n";
                }
            }
        }
        
        xml += "\t</" + actor.key() + ">\n";
        
        return xml;
	}
	
	/*****************
	*                *
	* Utlity Methods *
	*                *
	*****************/
	
	function getDescriptionString():String {
		return "";
	}
	
	function button(options):BPButton {
	    return new BPButton("addActor", key(options), { onDown: true });
	}

}