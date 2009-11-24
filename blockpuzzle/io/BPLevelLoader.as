import blockpuzzle.controller.game.*;
import blockpuzzle.io.*;
import blockpuzzle.model.game.BPBoard;

class blockpuzzle.io.BPLevelLoader extends BPLoader {
    
    function BPLevelLoader(controller:BPController) {
        super(controller);
    }
    
    function action(levelIndex) {
        return "download/" + controller.serverName + "/" + levelIndex;
    }
    
    /****************************
    *                           *
    * Success Condition Methods *
    *                           *
    ****************************/
    
    function loadSucceeded(loadRequest:BPLoadRequest) {
        var gb = createBoard();
		gb.setServerId(    loadRequest.get('level_id')   );
		gb.setServerIndex( loadRequest.info              );
		gb.setServerName(  loadRequest.get('level_name') );
        
		//controller.setBoard(gb);

		var levelData = new XML( loadRequest.get('level_data') );
		
		loadLevel(gb, levelData.childNodes[0]);
		
        controller.levelLoaded(gb);
    }
    
    function loadFailed(loadRequest:BPLoadRequest) {
        //trace("LOAD FAILED: " + loadRequest.info);
    }
    
    /************************
    *                       *
    * Level Loading Methods *
    *                       *
    ************************/
    
    // Can be overridden, but probably doesn't need to be
    function createBoard():BPBoard {
        return new BPBoard(controller);
    }

    function loadRow(board:BPBoard, row:Number, data:String) {
        board.patchesWide = data.length;
		board.patchesHigh++;

		for (var col = 0; col < data.length; col++) {
		    var tile = data.charAt(col);
		    
			var newPatch = controller.patchController.loadPatch(board, tile, col, row);

			for (var i = 0; i < controller.actorControllers.length; i++)
			    controller.actorControllers[i].loadFromBoard(newPatch, tile);
		}
		
    }

    function loadLevel(board:BPBoard, level:XML) {
		var rowNum = 0;
        
		for (var i = 0; i < level.childNodes.length; i++){
			if (level.childNodes[i].nodeName == "row"){
				var row = level.childNodes[i].childNodes[0].nodeValue;
				loadRow(board, rowNum, row);
				rowNum++;
			} else if (level.childNodes[i].nodeName){
			    var actorController = controller.actorControllerFor(level.childNodes[i].nodeName);
			    
			    actorController.loadActorFromXml(board, level.childNodes[i].childNodes);
			}
		}
    }
    
}