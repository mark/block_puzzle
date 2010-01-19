import blockpuzzle.controller.game.BPTile;

class blockpuzzle.controller.game.BPTileLibrary {
	
	var tiles:Array;

	function BPTileLibrary(tiles:Array) {
		this.tiles = tiles;
	}
	
	function addTile(tile:BPTile) {
	    tiles.push(tile);
	}
	
	function defaultKey():String {
		return tiles[0].key();
	}
	
	function keyForTile(tile:String):String {
		for (var i = 0; i < tiles.length; i++) {
			if (tiles[i].actsAsTile(tile)){
				//trace(tile)
				//trace(tiles[i].key())
				return tiles[i].key();
			}
		}
		//trace(tile)
		//trace(defaultKey())
		return defaultKey();
	}
	
	function frameForKey(key:String):String {
		for (var i = 0; i < tiles.length; i++) {
			if (tiles[i].key() == key)
				return tiles[i].frame();
		}
		
		return null;
	}
	
	function tileForKey(key:String):String {
		for (var i = 0; i < tiles.length; i++) {
			if (tiles[i].key() == key)
				return tiles[i];
		}
		
		return null;
	}
	
}