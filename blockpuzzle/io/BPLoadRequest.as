import blockpuzzle.io.*;

class blockpuzzle.io.BPLoadRequest {
    
    var loader:BPLoader;
    var request:String;
    var info;
    var data:LoadVars;
    
    var shouldLoad:Boolean;
    
    function BPLoadRequest(loader:BPLoader, info) {
        // Provided to the constructor
        this.loader = loader;
        this.info   = info;

        // Calculated by the constructor
        if (info.local)
            this.request = info.local;
        else
            this.request = loader.request(info);

        this.data = new LoadVars();
        
        // Initialize
        this.shouldLoad = true;
        
        data.loadRequest = this;
        data.onLoad = function(success){ this.loadRequest.loadCompleted(success); }

        // Initialize the loader...
		loader.beforeLoad(this);

        // Actually perform the load...
		data.load( request );
    }
    
    /************************
    *                       *
    * From the BPController *
    *                       *
    ************************/
    
    function cancel() {
        shouldLoad = false;
    }

    /********************
    *                   *
    * From the LoadVars *
    *                   *
    ********************/
    
    function loadCompleted(success:Boolean) {
        if (success && shouldLoad) {
            loader.loadSucceeded(this);
        } else if (! success) {
            loader.loadFailed(this);
        } else {
            loader.loadCancelled();
        }
    }
 
    /********************
    *                   *
    * From the BPLoader *
    *                   *
    ********************/
    
    function get(name:String) {
        return data[name];
    }
    
    function set(name:String, value) {
        data[name] = value.toString();
    }

}