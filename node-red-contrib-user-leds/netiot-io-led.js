module.exports = function(RED) {
    var fs = require("fs");

    function LedSet(n) {
        RED.nodes.createNode(this, n);
        this.led = n.led;
        var node = this;
        node.filename = "/var/platform/led_" + node.led.toLowerCase();

      	function update_state() {
    	    state=fs.readFileSync(node.filename).toString().trim();
    	    if (Number(state) > 0)
    	    	node.status({fill:"green",shape:"dot",text:"on"});
    	    else
        		node.status({fill:"green",shape:"ring",text:"off"});
      	}

	      update_state();

        node.on("input", function(msg) {
    	    fs.writeFileSync(node.filename, msg.payload);
	        update_state();
        });

        this.on('close', function() {
        });
    }

    function get_led_list(type) {
    	var results = [];
	    dir = "/var/platform"
    	fs.readdirSync(dir).forEach(function(file) {

	        var stat = fs.statSync(dir+'/'+file);

	        if (stat && stat.isFile()) {
			      if (file.substring(0, 4) == "led_") {
      				results.push(file.substring(4).toUpperCase());
			      }
	        }
    	});

    	return results;
    }

    if (get_led_list().length == 0)
      throw "Info: Skipping registration of netiot-io-led as no LEDs were found on this platform";
    else
      RED.nodes.registerType("netiot-io-led", LedSet);

    RED.httpAdmin.get('/netiot-io-get-led-list/:id', RED.auth.needsPermission('netiot-io.read'), function(req,res) {
        res.json(JSON.stringify(get_led_list()));
    });
}
