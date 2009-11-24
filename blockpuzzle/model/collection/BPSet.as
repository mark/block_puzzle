class blockpuzzle.model.collection.BPSet {
    
    var array:Array;
    
	/**********************
	*                     *
	* Constructor methods *
	*                     *
	**********************/
	
    function BPSet(array:Array) {
        this.array = array ? array : new Array();
    }

	function another(array:Array):BPSet {
		return new BPSet(array);
	}
	
	function clone():BPSet {
		var ary = new Array();
		
		for (var i = 0; i < array.length; i++) {
			ary.push(array[i]);
		}
		
		return another(ary);
	}
	
	/****************
	*               *
	* Array methods *
	*               *
	****************/
	
    //function array():Array {
	//	return array;
	//}

    function theFirst() {
		return array[0];
	}
    
	function theNextAfter(current:Object) {
	    var foundCurrent = false;
	    
	    for (var i = 0; i < array.length; i++) {
            if (foundCurrent) return array[i]; // We already found the current, so this one is next

	        if (current == array[i]) foundCurrent = true; // We've found the current, so next one is golden.
	    }
	    
	    return theFirst(); // We got to the end of the list & didn't find another.
	}
    
	function isValid():Boolean {
		for (var i = 0; i < array.length; i++) {
			if (array[i] == null) return false;
		}
		
		return true;
	}
	
	/********************
	*                   *
	* Insert and Remove *
	*                   *
	********************/
	
	function insert(what:Object) {
		// if (! contains(what)) // Note: this line makes larger boards unbelievably slow!  For this to work, we need a not-O(n) imp. of contains.
			array.push(what);
			
	}
	
	function remove(what:Object) {
		for (var i = 0; i < array.length; i++)
			if (array[i] == what) {
				array.splice(i, 1);
				return;
			}
	}
	
	/**************
	*             *
	* Set methods *
	*             *
	**************/
	
	function contains(obj):Boolean {
		for (var i = 0; i < array.length; i++) {
			if (obj == array[i]) return true;
		}
		
		return false;
	}
	
	function union(other:BPSet):BPSet {
		var ary = new Array();
		
		each( function(obj) { ary.push(obj); } );
		other.each( function(obj) { ary.push(obj); } );
		
		return another(ary);
	}

	function intersection(other:BPSet):BPSet {
		var ary = new Array();
		
		each( function(obj) { if (other.contains(obj)) ary.push(obj); } );
		
		return another(ary);
	}

	function minus(other:BPSet):BPSet {
		var ary = new Array();
		
		each( function(obj) { if (! other.contains(obj)) ary.push(obj); } );
		
		return another(ary);
	}

    /*********************
    *                    *
    * Functional methods *
    *                    *
    *********************/
    
    function each(meth) {
		for (var i = 0; i < array.length; i++) {
			_call(array[i], meth);
		}
	}
    
	function select(meth) {
		var newArray = new Array();
		
		for (var i = 0; i < array.length; i++) {
			if (_call(array[i], meth)) {
				newArray.push(array[i]);
			}
		}
		
		return newArray;
	}
	
	function reject(meth) {
		var newArray = new Array();
		
		for (var i = 0; i < array.length; i++) {
			if (! _call(array[i], meth)) {
				newArray.push(array[i]);
			}
		}
		
		return newArray;
	}
	
	function map(meth) {
		var newArray = new Array();

		for (var i = 0; i < array.length; i++) {
			var obj = _call(array[i], meth);
			newArray.push(obj);
		}
		
		return newArray;
	}
	
	function inject(initial, meth) {
		var newObject = initial;

		for (var i = 0; i < array.length; i++) {
			newObject = _call2(newObject, array[i], meth);
		}
		
		return newObject;
	}
	
	/*********
	*        *
	* _call* *
	*        *
	*********/

    function _call(x, meth) {
        if (meth instanceof Function) {
            return meth.call(null, x);
        } else { // since instanceof String seems to not work.
        	return x[meth]();
        }
    }

    function _call2(accum, x, meth) {
        if (meth instanceof Function) {
            return meth.call(null, accum, x);
        } else { // since instanceof String seems to not work.
        	return x[meth](accum);
        }
    }

	/***********
	*          *
	* That Are *
	*          *
	***********/

    function thatAre(meth) {
		var ary = select(meth);
		return another(ary);
	}
    
    function thatAreNot(meth) {
		var ary = reject(meth);
		return another(ary);
	}

	/**********
	*         *
	* Of Type *
	*         *
	**********/
	    
    function ofType(key:String) {
		var ary = select( function(obj) { return obj.key() == key; } );
		return another(ary);
	}
    
    function notOfType(key:String) {
		var ary = reject( function(obj) { return obj.key() == key; } );
		return another(ary);
	}

    function areAllOfType(key:String):Boolean {
		return inject(true, function(accum, obj) { return accum && obj.isA(key); } );
	}
	
	/***********
	*          *
	* How Many *
	*          *
	***********/
	
    function howMany():Number			   { return array.length;   }

    function areThereAny():Boolean         { return howMany() > 0;  }
    
    function mustBeNone():Boolean		   { return howMany() == 0; }

    function areMoreThan(n:Number):Boolean { return howMany() > n;  }
    
    function areAtLeast(n:Number):Boolean  { return howMany() >= n; }
    
    function areAtMost(n:Number):Boolean   { return howMany() <= n; }

    function areLessThan(n:Number):Boolean { return howMany() < n;  }

	/**********
	*         *
	* Must Be *
	*         *
	**********/
	
    function mustBe(meth):Boolean {
		var ary = select(meth);
		return ary.length == howMany();
	}

    function mustNotBe(meth):Boolean {
		var ary = reject(meth);
		return ary.length == howMany();
	}
    
    function someMustBe(meth):Boolean {
		var ary = select(meth);
		return ary.length > 0;
	}
    
	/***************
	*              *
	* Must Be Only *
	*              *
	***************/
	
	// This might not play nice with union.
	function mustBeOnly(obj):Boolean {
		return (array.length == 1) && (array[0] == obj);
	}

    /******************
    *                 *
    * Trigger Methods *
    *                 *
    ******************/
    
	/******************
	*                 *
	* Utility methods *
	*                 *
	******************/
	
	function toString() {
		var string = "{ ";
		for (var i = 0; i < array.length-1; i++)
			string += array[i] + ", ";
		
		if (array.length > 0)
			string += array[array.length-1] + " ";
		
		string += "}";
		
		return string;
	}

}