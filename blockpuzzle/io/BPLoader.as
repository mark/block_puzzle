import blockpuzzle.controller.game.BPController;
import blockpuzzle.io.*;

class blockpuzzle.io.BPLoader { // extends BPObject ???
    
    var controller:BPController;
    
    function BPLoader(controller:BPController) {
        this.controller = controller;
    }

    /******************
    *                 *
    * The Request URL *
    *                 *
    ******************/
    
    function request(info):String {
        return controller.server() + "/" + action(info);
    }
    
    function action(info):String {
        // OVERRIDE ME!
        return "";
    }
    
    /********************
    *                   *
    * Starting the Load *
    *                   *
    ********************/
    
    function load(info):BPLoadRequest {
		return new BPLoadRequest(this, info);
    }

    /**********************
    *                     *
    * Processing the Load *
    *                     *
    **********************/
    
    function beforeLoad(loadRequest:BPLoadRequest) {
        // OVERRIDE ME!!!
    }
    
    function loadSucceeded(loadRequest:BPLoadRequest) {
        // OVERRIDE ME!!!
    }
    
    function loadFailed(loadRequest:BPLoadRequest) {
        // OVERRIDE ME!!!
    }

    function loadCancelled(loadRequest:BPLoadRequest) {
        // OVERRIDE ME!!!
    }
    
}