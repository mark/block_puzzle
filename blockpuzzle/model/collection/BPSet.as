class blockpuzzle.model.collection.BPSet {
    
    var hash:Object;
    var length:Number;
    
	/**********************
	*                     *
	* Constructor methods *
	*                     *
	**********************/
	
    function BPSet(of:Object) {
        this.hash = new Object();
        length = 0;

        if (of instanceof Array) {
            for (var i = 0; i < of.length; i++) {
                insert( of[i] );
            }
        } else if (of) {
            this.hash = of;
            for (var k in of) { length++; }
        }
    }

	function another(of:Object):BPSet {
		return new BPSet(of);
	}
	
	/****************
	*               *
	* Array methods *
	*               *
	****************/
	
	function fetch(id:Number) {
	    return hash[ id ];
	}
	
    function theFirst() {
		for (var k in hash) {
		    return hash[ k ];
		}
	}
    
	function theNextAfter(current:Object) {
	    var foundCurrent = false;
	    
	    for (var k in hash) {
            if (foundCurrent) return hash[k]; // We already found the current, so this one is next

	        if (current == hash[k]) foundCurrent = true; // We've found the current, so next one is golden.
	    }
	    
	    return theFirst(); // We got to the end of the list & didn't find another.
	}
    
	/********************
	*                   *
	* Insert and Remove *
	*                   *
	********************/
	
	function insert(what:Object) {
	    if (contains(what) ) return;
	    length++;
        hash[ what.id() ] = what;
	}
	
	function remove(what:Object) {
	    if (! contains(what) ) return;
	    length--;
	    delete hash[ what.id() ];
	}
	
	/**************
	*             *
	* Set methods *
	*             *
	**************/
	
	function contains(obj:Object):Boolean {
		return hash[ obj.id() ] != null;
	}
	
	function union(other:BPSet):BPSet {
		var newSet = another();
		
		each( function(obj) { newSet.insert(obj); } );
		other.each( function(obj) { newSet.insert(obj); } );
		
		return newSet;
	}

	function intersection(other:BPSet):BPSet {
		var newSet = another();
		
		each( function(obj) { if (other.contains(obj)) newSet.insert(obj); } );
		
		return newSet;
	}

	function minus(other:BPSet):BPSet {
		var newSet = another();
		
		each( function(obj) { if (! other.contains(obj)) newSet.insert(obj); } );
		
		return newSet;
	}

    /*********************
    *                    *
    * Functional methods *
    *                    *
    *********************/
    
    function each(meth) {
        for (var k in hash) {
            _call(meth, [ hash[k] ]);
        }
	}
    
	function select(meth) {
	    var newSet = another();
	    
		for (var k in hash) {
			if (_call(meth, [ hash[k] ])) {
				newSet.insert(hash[k]);
			}
		}
		
		return newSet;
	}
	
	function reject(meth) {
		var newSet = another();
		
		for (var k in hash) {
			if (_call(meth, [ hash[k] ])) {
				newSet.insert(hash[k]);
			}
		}
		
		return newSet;
	}
	
	function map(meth) {
		var newSet = another();
		
		for (var k in hash) {
		    var result = _call(meth, [ hash[k] ]);
			newSet.insert(result);
		}
		
		return newSet;
	}
	
	function inject(initial, meth) {
		var newObject = initial;

        for (var k in hash) {
            newObject = _call(meth, [ newObject, hash[k] ]);
        }
		
		return newObject;
	}
	
	/*********
	*        *
	* _call* *
	*        *
	*********/

    function _call(meth, args) {
        if (! meth instanceof Function) meth = args[0][meth];
        
        return meth.apply(null, args);
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
	
    function howMany():Number			   { return length; }

    function areThereAny():Boolean         { return howMany() > 0;  }
    
    function isEmpty():Boolean		       { return howMany() == 0; }
    
    function mustBeNone():Boolean		   { return howMany() == 0; }

    function areMoreThan(n:Number):Boolean { return howMany() >  n; }
    
    function areAtLeast(n:Number):Boolean  { return howMany() >= n; }
    
    function areAtMost(n:Number):Boolean   { return howMany() <= n; }

    function areLessThan(n:Number):Boolean { return howMany() <  n; }

	/**********
	*         *
	* Must Be *
	*         *
	**********/
	
    function mustBe(meth):Boolean {
		var newSet = select(meth);
		return howMany() == newSet.howMany();
	}

    function mustNotBe(meth):Boolean {
		var newSet = reject(meth);
		return howMany() == newSet.howMany();
	}
    
    function someMustBe(meth):Boolean {
		var newSet = select(meth);
		return newSet.areThereAny();
	}
    
	/***************
	*              *
	* Must Be Only *
	*              *
	***************/
	
	function mustBeOnly(obj):Boolean {
		return (length == 1) && (theFirst() == obj);
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
		
		for (var k in hash) {
			string += hash[k] + ", ";
		}
				
		string += " }";
		
		return string;
	}

}