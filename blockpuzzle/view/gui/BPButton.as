import blockpuzzle.base.JSON;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPButton {
    
    static var DEFAULT_BUTTON_ICON_SET = "Button Icons";
    static var DEFAULT_BUTTON_BACKGROUND_SET = "Button Background";
    
    var method:String;
    
    var objects:Array;

    var options:Object;
    
    var controller:Object; // Will be BPPen
    
    function BPButton(method, objects, options) {
        this.method = method;
        
        if (objects instanceof Array)
            this.objects = objects;
        else if (objects)
            this.objects = [ objects ];
        else
            this.objects = [];
            
        this.options = options;
    }

    function setController(controller) {
        this.controller = controller;
    }
    
    function icon():String {
        if (options.icon)
            return options.icon;            
        else if (objects[0])
            return objects[0].toString();
        else
            return method;            
    }
    
    function iconSet():String {
        if (options.iconSet)
            return options.iconSet;
        else
            return DEFAULT_BUTTON_ICON_SET;
    }
    
    function background():String {
        if (options.background)
            return options.background;
        else
            return null;
    }
    
    function backgroundSet():String {
        if (options.backgroundSet)
            return options.backgroundSet;
        else
            return DEFAULT_BUTTON_BACKGROUND_SET;
    }
    
    function group():String {
        return options.group;
    }
    
    function callOnDown():Boolean {
        return options.onDown;
    }
    
    function call() {
        controller.respondTo(method, objects);
    }
    
    function toString():String { return "<Button: " + method + ">"; }
    
    static function loadFromXml(xml:XML) {
        var meth = xml.attributes.action;
        
        var objects = null;
        var options = new Object();
        
        if (xml.attributes.params) {
            var json = new JSON();
            
            try {
                objects = json.parse(xml.attributes.params);
            } catch(ex) {
                //trace(ex.name + ":" + ex.message + ":" + ex.at + ":" + ex.text);
            }
        }

        options.icon          = xml.attributes.icon;
        options.iconSet       = xml.attributes.iconSet;
        options.background    = xml.attributes.background;
        options.backgroundSet = xml.attributes.backgroundSet;
        options.group         = xml.attributes.group;
        options.onDown        = xml.attributes.onDown != null;
        
        return new BPButton(meth, objects, options);
    }
    
    function toXml() {
        var s = new String();

        s += "<button action='" + method + "'";
        
        if (objects.length > 0) {
            var json = new JSON();
            s += " params='" + json.stringify(objects) + "'";
        }
        
        if (options.icon)          s += " icon='" + options.icon + "'";
        if (options.iconSet)       s += " iconSet='" + options.iconSet + "'";
        if (options.background)    s += " background='" + options.background + "'";
        if (options.backgroundSet) s += " backgroundSet='" + options.backgroundSet + "'";
        if (options.group)         s += " group='" + options.group + "'";
        if (options.onDown)        s += " onDown='true'";
        s += " />\n";
        
        return s;
    }
    
}