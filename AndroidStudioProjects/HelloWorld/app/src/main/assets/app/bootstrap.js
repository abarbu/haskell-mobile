/*
// declare the extended NativeScriptActivity functionality
var extendsObject = {
    onCreate: function(savedState){
        // call the base NativeScriptActivity.onCreate method
        // the "this" variable points to a NativeScriptActivity instance
        this.super.onCreate(savedState);

        // create a button and set it as the main content
        var button = new android.widget.Button(this);
        button.setText("Hello World");

        this.setContentView(button);
    }
}

// pass the extends object to create a new NativeScriptActivity instance
var mainActivity = com.tns.NativeScriptActivity.extends(extendsObject);
*/

function log(message) {
        var arrayToLog = [];
        if (message.length > 4000) {
            var i;
            for (i = 0; i * 4000 < message.length; i++) {
                arrayToLog.push(message.substr((i * 4000), 4000));
            }
        }
        else {
            arrayToLog.push(message);
        }
        for (i = 0; i < arrayToLog.length; i++) {
        android.util.Log.w("TNS.JS", arrayToLog[i]);
        }
}

/*
// pass the extends object to create a new NativeScriptActivity instance
var mainActivity = (function(_super) {
 log("Go!");
 __extends(mainActivity, _super);
 function mainActivity() { log("Created!!!"); _super.call(this); }
 mainActivity.prototype.onCreate = function(savedState){
    log("Oncreate");
    // call the base NativeScriptActivity.onCreate method
    // the "this" variable points to a NativeScriptActivity instance
    this.super.onCreate(savedState);

    // create a button and set it as the main content
    var button = new android.widget.Button(this);
    button.setText("Hello World");

    this.setContentView(button);
    };
    log("Return");
    return mainActivity;
})(com.tns.NativeScriptActivity);
*/

var mainActivity = new com.tns.NativeScriptActivity();
mainActivity.onCreate = function(savedState){
  log("Oncreate");
  // call the base NativeScriptActivity.onCreate method
  // the "this" variable points to a NativeScriptActivity instance
  this.super.onCreate(savedState);

  // create a button and set it as the main content
  var button = new android.widget.Button(this);
  button.setText("Hello World");

  this.setContentView(button);
};

log("HEllo")

var applicationInitObject = {
    getActivity: function(intent) {
        // this method is called whenever a new instance of NativeScriptActivity is about to be created
        log("Activity");
        return mainActivity;
    },
    onCreate: function() {
    log("First method called");
        // This is the first method called. Called from the android.app.Application.onCreate method.
    }
}

// The NativeScriptRuntime exposes the app object within the global context
app.init(applicationInitObject);