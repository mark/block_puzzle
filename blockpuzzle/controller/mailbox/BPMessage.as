class blockpuzzle.controller.mailbox.BPMessage {

    var message:String;
    var source:Object;
    var info:Object;
    
    function BPMessage(message:String, source:Object, info:Object) {
        this.message = message;
        this.source = source;
        this.info = info;
    }

}