import blockpuzzle.base.BPObject;
import blockpuzzle.io.*;
import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.*;
import blockpuzzle.controller.mailbox.BPMailbox;
import blockpuzzle.controller.pen.*;
import blockpuzzle.model.game.*;
import blockpuzzle.view.clock.*;
import blockpuzzle.view.gui.*;

class blockpuzzle.controller.game.BPController extends BPObject {
    
    var serverURL:String;
    var serverName:String; // The name for the game on the server...

    var gameboard:BPBoard;
    var __grid:BPGrid;
    
    var geom:BPGeometry;
    
    var patchController:BPPatchController; // Needed to load the patches into & out from xml
    var actorControllers:Array;
    var controllerClasses:Array; // What controller classes to instantiate?
    
	var defaultGeometry:BPGeometry;

    var interfaceId:Number;
    var allInterfaceElements:Array;
	var interfaceElements:Object; // *Named* user interface elements ...
    var currentBank:String;

	var currentPen; // Keep untyped for now...
	var pens:Array;
	
    var currentSelection; // What the pens are selecting... (actor/region mostly)
    var cursor; // The display element for the current selection
    
    var gameQueue:BPUndoManager;   // To keep the editor queue separate from the game queue
    var editorQueue:BPUndoManager; // To keep the previous editor undo queue, when switching into play mode

    var callbackFunction:Function; // The function that gets called when a new level is loaded.
    
    var levelLoader:BPLevelLoader;
    var interfaceLoader:BPInterfaceLoader;
    
	/******************
	*                 *
	* Default Buttons *
	*                 *
	******************/
	
	static var PlayButton = new BPButton("playGame",  null, { iconSet: "Standard Icons" });
	static var EditButton = new BPButton("editLevel", null, { iconSet: "Standard Icons" });

    static var HandButton  = new BPButton("grabHand",  null, { iconSet: "Standard Icons", group: "EditorPens" });
    static var PatchButton = new BPButton("patchHand", null, { iconSet: "Standard Icons", group: "EditorPens" });
    static var RectButton  = new BPButton("rectHand",  null, { iconSet: "Standard Icons", group: "EditorPens" });

    static var CropButton         = new BPButton("cropRect",     null, { iconSet: "Standard Icons" });
    static var InsertTopButton    = new BPButton("insertTop",    null, { iconSet: "Standard Icons" });
    static var InsertBottomButton = new BPButton("insertBottom", null, { iconSet: "Standard Icons" });
    static var InsertLeftButton   = new BPButton("insertLeft",   null, { iconSet: "Standard Icons" });
    static var InsertRightButton  = new BPButton("insertRight",  null, { iconSet: "Standard Icons" });

    static var PrevLevelButton = new BPButton("previousLevel", null, { iconSet: "Standard Icons" });
    static var NextLevelButton = new BPButton("nextLevel",     null, { iconSet: "Standard Icons" });

    static var SaveButton  = new BPButton("saveBoard",  null, { iconSet: "Standard Icons" });
    static var ClearButton = new BPButton("clearBoard", null, { iconSet: "Standard Icons" });

    static var UndoButton  = new BPButton("undo",  null, { iconSet: "Standard Icons" });
    static var ResetButton = new BPButton("reset", null, { iconSet: "Standard Icons" });

	/**************
	*             *
	* Constructor *
	*             *
	**************/
	
    function BPController() {
		this.interfaceElements = new Object();
		
		this.actorControllers = new Array();

		pens = new Array();
		
		gameQueue = new BPUndoManager();
		editorQueue = new BPUndoManager();

        levelLoader = new BPLevelLoader(this);
        interfaceLoader = new BPInterfaceLoader(this);
        allInterfaceElements = new Array();
        
        useControllers(arguments);
        autoloadClasses();
        
		// Initialization methods
		setupTimer();
		
		createControllers();
		
		createPens();
		
		createInterface();
		
		Mouse.addListener(this);
    }

    /******************
    *                 *
    * Control Methods *
    *                 *
    ******************/
    
    // With this method, you can add 
    function addToEvent(action:BPAction) {
        // OVERRIDE ME!
    }
    
    function beat(){
		board().sendBeat();

		if (beatLevel())
		    onBeatLevel();
	}
	
	function beatLevel() {
	    // OVERRIDE ME!
		return false;
	}
	
	function onBeatLevel() {
	    //trace("You Win!")
	
		//getInterface("timer").beatLevel();
	    // OVERRIDE ME!
	}
	
    /************************
    *                       *
    * Game Property Methods *
    *                       *
    ************************/
    
	function setServer(newServerURL:String) {
		serverURL = newServerURL;
	}

    function server():String {
        return serverURL;
    }
    
    // Can be overridden, but probably doesn't need to be
    function createBoard():BPBoard {
        return new BPBoard(this);
    }

    function board():BPBoard {
        return gameboard;
    }
    
    function setBoard(board:BPBoard) {
		if (this.board() != null)
			this.board().destroy();

		gameboard = board;
		
        attachBoardToGrid();
	}
    
    function grid():BPGrid {
        return __grid;
    }
    
    function setGrid(newGrid:BPGrid) {
        if (newGrid == this.__grid) return;
        
        this.__grid = newGrid;
        
        attachBoardToGrid();
    }
    
	// Override this, but call super if you want to use this:
    function startGame() {
        currentPen.currentPlayer = board().allActors().thatCanBePlayer().theFirst();
    }

    /*********************
    *                    *
    * Controller Methods *
    *                    *
    *********************/

    function useControllers(controllerClasses:Array) {
        this.controllerClasses = controllerClasses;
    }
    
    // This looks for all of the likely Patch & Actor classes for this controller.
    // So if this is XxxxController, it looks for all of the classes named Xxxx*Controller, where * is not empty.
    function autoloadClasses() {
        var name = className(); // # => "XxxxController"
        var prefix = name.substring(0, name.length - "Controller".length); // # => "Xxxx"
        
        //trace("className = " + name + ", prefix = " + prefix);
        
        for (var klass in _global) {
            // eg. XxxxPatchController
            
            //  [...........Starts with prefix............]    [............Ends with "Controller"...............]    [* is not empty]
	        if (klass.substring(0, prefix.length) == prefix && klass.substr(- "Controller".length) == "Controller" && klass  !=   name) {
	            //trace("\tfound " + klass);
	            controllerClasses.push(_global[klass]);
	        }
	    }
	    
    }
    
	function createControllers() {
		for (var i = 0; i < controllerClasses.length; i++) {
		    var klass = controllerClasses[i];
		    new klass(this);		    
		}
	}
	
	function setPatchController(patchController:BPPatchController) {
		this.patchController = patchController;
	}

	function addActorController(actorController:BPActorController) {
	    actorControllers.push(actorController);
	    return actorController;
	}
	
	function actorControllerFor(key:String, options):BPActorController {
        for (var i = 0; i < actorControllers.length; i++) {
            if (key.toLowerCase() == actorControllers[i].key(options).toLowerCase())
                return actorControllers[i];
        }
        
        return null;
	}

	/****************
	*               *
	* Timer Methods *
	*               *
	****************/
	
	function setupTimer() {
	    var mailbox = new BPMailbox();
		var clock = new BPClock();
		
        var gameTimer = new BPTimer("Game");
        
        mailbox.listenFor("BPTimerStart",  gameTimer, this, initialize);
        mailbox.listenFor("BPTimerActive", gameTimer, this, everyFrame);
        mailbox.listenFor("BPTimerTick",   gameTimer, this, everySecond);
	}
	
	function initialize() {
	    // OVERRIDE ME!
	}
	
	function everyFrame() {
	    // OVERRIDE ME!
	}
	
	function everySecond() {
	    // OVERRIDE ME!
	}
	
	/******************
	*                 *
	* Loading methods *
	*                 *
	******************/

    function createLevel(width:Number, height:Number, callback:Function) {
    	//finishAnimations();

    	if (board() != null) board().destroy();

    	setBoard(createBoard());

    	board().patchesWide = width;
    	board().patchesHigh = height;

    	for (var row = 0; row < height; row++) {
    		for (var col = 0; col < width; col++) {
    			var newPatch = patchController.createPatch(col, row);
    		}
    	}

    	startGame();
    	callback.call();

    	_root.setNameAndAuthor("Untitled Level", "Author");

    	board().gameIsStarted = true;
    	
    	attachBoardToGrid();
    }

    function loadLevel(id:Number, callback:Function) {
        this.callbackFunction = callback;
        levelLoader.load(id);
    }
    
    function loadLevelFromLocal(id:Number, callback:Function) {
        this.callbackFunction = callback;
        levelLoader.load({ local: "../xml/" + id + ".xml" });
    }
	
	function levelLoaded(board:BPBoard) {
		//board.display();
		setBoard(board);
		startGame();
		
		callbackFunction.call();
        
		board.gameIsStarted = true;
		
		post("BPLevelLoaded", board);
	}
	
	function attachBoardToGrid(board:BPBoard, grid:BPGrid) {
	    if (board == null) board = this.board();
	    if (board == null) return;

	    if (grid  == null) grid  = this.grid();
	    if (grid  == null) return;
	    
	    //trace("attachBoardToGrid(" + board + ", " + grid + ")");
	    
        board.allPatches().each( function(patch) {
            patch.display(grid);
        });
        
        board.allActors().each( function(actor) {
            actor.display(grid);
        });
        
        grid.setBoard(board);
	}
	
	/*****************
	*                *
	* Saving Methods *
	*                *
	*****************/
	
    // This should handle most cases... override if necessary
	function exportPatch(patch:BPPatch):String {
        var char = board().allActors().thatAre('includeOnBoard').thatAreAt(patch).theFirst();
		
	    if (char != null) {
	        return char.toXml();
	    } else {
    	    return patch.exportPatch();
	    }
	}

	function toXml():String {
		var xmlOutput = "<level>\n\n";
	
		for(var y = 0; y < board().height(); y++){
			var rowString = "";

			for(var x = 0; x < board().width(); x++){
                rowString += exportPatch(board().getPatch(x, y));
			}
			
			xmlOutput += "\t<row>" + rowString + "</row>\n";
		}
    
        xmlOutput += "\n";
        
		board().allActors().thatAreNot('includeOnBoard').each( function(actor) {
		    var objectToXml = actor.toXml();

		    if (objectToXml) xmlOutput += objectToXml + "\n";
		} );

	    // insert a hook here, eg for Atomic

		xmlOutput += "</level>";

		return xmlOutput;
 	}

	function saveOnServer() {
	    gameQueue.reset();
        
    	var levelData = toXml();

    	var saveRequest = new LoadVars();
    	var serverResponse = new LoadVars();

    	// What to save

    	saveRequest.game = serverName;
    	saveRequest.level_data = levelData;
    	saveRequest.level_id = board().serverId;
    	// saveRequest.level_name = levelName.text;
    	saveRequest.key = _root.key;

    	saveRequest.sendAndLoad("http://0.0.0.0:4000/save", serverResponse);

    	serverResponse.onLoad = function() {
    	    if (this.success == '1') {
        		//trace("Save succeeded");
        	} else {
        		//trace("Save failed: " + this.message);
        	}	
    	}
	}

	function saveAsOnServer() {
		// var myVars = new LoadVars();
        // 
		// myVars.data = toXml();
        // myVars.game_id = gameId();
        // 
		// var serverResponse = new LoadVars();
		// myVars.sendAndLoad(ServerURL + "/upload/level/", serverResponse, "POST");

		// Need to parse result and get back new serverId!
	}

	/********************
    *                   *
    * Interface Methods *
    *                   *
    ********************/
    
    function createInterface() {
        // OVERRIDE ME!
    }
    
    function place():BPButtonArray {
        var buttons = new Array();
        
        for (var i = 0; i < arguments.length; i++) {
            if (arguments[i] instanceof Array)
                buttons.push(arguments[i]);
            else
                buttons.push( [ arguments[i] ]);
        }
        
        var buttonArray = new BPButtonArray(this, buttons);
        
        register(buttonArray);
        
        return buttonArray;
    }
    
	// Interface banks
	
	function setBank(bank:String) {
	    if (interfaceElements[bank] == null)
	        interfaceElements[bank] = new Array();
	    
	    currentBank = bank;
	}

	function register(element) {
		interfaceElements[currentBank].push(element);
		element.addToBank(currentBank);
		
		for (var i = 0; i < allInterfaceElements.length; i++) {
		    if (element == allInterfaceElements[i]) return;
		}
		
		allInterfaceElements.push(element);
		
		if (element instanceof BPGrid) {
		    setGrid(element);
		}
	}
	
	function elementNamed(name:String) {
		for (var i = 0; i < allInterfaceElements.length; i++) {
		    var element = allInterfaceElements[i];
		    if (element.isNamed(name)) return element;
		}
		
		return null;
	}
	
	function elementOfClass(name:String):BPGuiElement {
		for (var i = 0; i < allInterfaceElements.length; i++) {
		    var element = allInterfaceElements[i];
		    if (element.className() == name) return element;
		}
		
		return null;
	}
	
    function hideBank(bank) {
        if (bank == null) bank = currentBank;
        
        for (var i = 0; i < interfaceElements[bank].length; i++) {
            interfaceElements[bank][i].hide();
        }
    }

    function showBank(bank) {
        if (bank == null) bank = currentBank;
        
        for (var i = 0; i < interfaceElements[bank].length; i++) {
            interfaceElements[bank][i].show();
        }
    }

    function loadInterface(interfaceId:Number) {
        interfaceLoader.load(interfaceId);
    }

    function interfaceLoaded(interfaceId:Number) {
        this.interfaceId = interfaceId;
        
        post("BPInterfaceLoaded");
    }
    
    /*************
    *            *
    * Respond To *
    *            *
    *************/
    
    function respondTo(meth:String, args:Array) {
        var respondMethod:Function;
        var responder:Object;
        
        if (respondMethod == null) {
            responder = currentPen;
            respondMethod = responder[meth];
        }
        
        if (respondMethod == null) {
            responder = this;
            respondMethod = responder[meth];
        }
        
        for (var i = 0; i < pens.length; i++) {
            if (respondMethod == null) {
                responder = pens[i];
                respondMethod = responder[meth];
            }
        }
        
        // //trace("responder = " + responder + ", responder.name() = " + responder.name() + ", args = " + args);
        
        respondMethod.apply(responder, args);
        
        if (responder.name()) switchToPen(responder.name());
    }
    
    /**************************
    *                         *
    * Basic Interface Methods *
    *                         *
    **************************/

    function playGame() {
        switchToPen("play");        
    }
    
    function editLevel() {
        switchToPen("actor");
    }
    
    function previousLevel() {
        loadLevel(board().getServerIndex() - 1);
    }
    
    function nextLevel() {
        loadLevel(board().getServerIndex() + 1);
    }

    function undo() {
        BPUndoManager.undoQueue().undo();
    }
    
    function reset() {
        BPUndoManager.undoQueue().reset();
    }
    
    function saveBoard() {
        //saveOnServer();
        //trace("Board:\n" + toXml());
    }
    
    /********************
    *                   *
    * Playing & Editing *
    *                   *
    ********************/
    
    function play() {
        hideBank("Editor Elements");
        showBank("Play Elements");
    }
    
    function edit() {
        hideBank("Play Elements");
        showBank("Editor Elements");

        var gameTimer = BPClock.clock.timerNamed("Game");
        gameTimer.reset();
        gameTimer.pause();
    }

    /**************
    *             *
    * Pen Methods *
    *             *
    **************/
    
    function createPens() {
        //useDefaultPens();
    }
    
    function useDefaultPens() {
        new BPGamePen(this);
    
        new BPObjectPen(this);
        new BPPatchPen(this);
        new BPRectanglePen(this);
    }
    
    function registerPen(pen:BPPen) {
        pens.push(pen);
    }
    
    function switchToPen(name:String) {
        for (var i = 0; i < pens.length; i++) {
            var pen = pens[i];
            
            if (pen.name() == name) {
                currentPen.unset();
                currentPen = pen;
                currentPen.set();
                
                if (pen.isEditorPen()) {
                    gameQueue.reset();
                    editorQueue.set();
                    
                    this.edit();
                } else {
                    gameQueue.set();
                    
                    this.play();
                }
                
                return;
            }
        }
    }

    /********************
    *                   *
    * Selection methods *
    *                   *
    ********************/

    function select(newSelection) {
        currentSelection = newSelection;
    }
    
    function selection() {
        return currentSelection;
    }

    /****************
    *               *
    * Mouse Methods *
    *               *
    ****************/
    
    // The only one that matters is the onMouseUp method, so that if the mouse gets released when it is not on
    // a BPGrid of a BPWell, the mouse event gets cancel()-ed.
    
    function onMouseUp() {
        if (mouse() == null) return;
        
        for (var i = 0; i < allInterfaceElements.length; i++) {
            var element = allInterfaceElements[i];
            if ((element instanceof BPWell || element instanceof BPGrid) && element.isHit())
                return;
        }
        
        mouse().upOnNothing();
    }
    
    function onMouseMove() {
        if (mouse() == null) return;
        
        for (var i = 0; i < allInterfaceElements.length; i++) {
            var element = allInterfaceElements[i];
            if ((element instanceof BPWell || element instanceof BPGrid) && element.isHit())
                return;
        }
        
        mouse().dragOnNothing();
    }
    
    /*****************
    *                *
    * Helper Methods *
    *                *
    *****************/
    
    function toString() {
        return className();
    }

    // Interface XML generators
    
    function interfaceToXml() {
        var s = new String();

        for (var i = 0; i < allInterfaceElements.length; i++) {
            var element = allInterfaceElements[i];
            
            s += allInterfaceElements[i].toXml();
        }
        
        for (var i = 0; i < pens.length; i++) {
            s += pens[i].toXml(currentPen == pens[i]);
        }
        
        return s;
    }

}
