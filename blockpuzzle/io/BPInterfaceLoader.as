import blockpuzzle.base.BPObject;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.io.*;
import blockpuzzle.view.gui.BPGuiElement;

class blockpuzzle.io.BPInterfaceLoader extends BPLoader {
    
    static var GUI_ELEMENT_CLASSES = {
        pen:         "blockpuzzle.controller.pen.BPPen",
        buttonArray: "blockpuzzle.view.gui.BPButtonArray",
        label:       "blockpuzzle.view.gui.BPLabel",
        image:       "blockpuzzle.view.gui.BPImage",
        grid:        "blockpuzzle.view.gui.BPGrid"
    }
    
    function BPInterfaceLoader(controller:BPController) {
        super(controller);
    }
    
    function action(interfaceId) {
        return "game/" + controller.serverName + "/interface/" + interfaceId;
    }
    
    /****************************
    *                           *
    * Success Condition Methods *
    *                           *
    ****************************/
    
    function loadSucceeded(loadRequest:BPLoadRequest) {
        var interfaceXml = new XML(loadRequest.get('interface'));
		
        for (var i = 0; i < interfaceXml.childNodes.length; i++) {
            loadInterfaceElementFromXml( interfaceXml.childNodes[i] );
        }
	    
	    controller.interfaceLoaded(loadRequest.info);
    }
    
    /****************************
    *                           *
    * Interface Loading Methods *
    *                           *
    ****************************/
    
    function loadInterfaceElementFromXml(element:XML) {
        var guiElement;
        
        //var klassName = element.attributes['class'] ? element.attributes['class'] : element.nodeName;
        var classPath = GUI_ELEMENT_CLASSES[element.nodeName].split('.');
        var klass = BPObject.classWithName(classPath);

        if (klass) {
            guiElement = klass.loadFromXml(controller, element);

            ////trace("element.nodeName = " + element.nodeName + "\tguiElement = " + guiElement);
        }
////trace("guiElementXML = " + klassName)
        
        if (guiElement && guiElement instanceof BPGuiElement) {
            var banks = element.attributes.bank.split(",");
            
            for (var i = 0; i < banks.length; i++) {
                controller.setBank(banks[i]);
            
                controller.register(guiElement);
            }

            if (element.attributes.top && element.attributes.left) {
                guiElement.at(Number(element.attributes.top), Number(element.attributes.left));
            }
            
            if (element.attributes.scale != null) {
                guiElement.scale(Number(element.attributes.scale));
            }
            
            if (element.attributes.name != null) {
                guiElement.setName(element.attributes.name);
            }
        }
    }
    
    /******************
    *                 *
    * Utility Methods *
    *                 *
    ******************/
    
    // function classWithName(name:String) {
    //     //var local = _global[name];
    //     //if (local) { ////trace("found _global." + name); return local; }
    //     //
    //     //var gui = _global.blockpuzzle.view.gui[GUI_ELEMENT_CLASSES[name]];
    //     //if (gui) { ////trace("found _global.blockpuzzle.view.gui." + GUI_ELEMENT_CLASSES[name]); return gui; }
    //     //
    //     //var pen = _global.blockpuzzle.controller.pen[name];
    //     //if (pen) { ////trace("found _global.blockpuzzle.controller.pen." + name); return pen;}
    //     
    //     return null;
    // }

}