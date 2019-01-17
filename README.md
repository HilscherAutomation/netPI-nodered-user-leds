## Node-RED + LED node

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem

### Debian with Node-RED and LED node to control netPI's user LEDs

The image provided hereunder deploys a container with installed Debian, Node-RED and LED node to control the two orange user LEDs of a netPI.

Base of this image builds the latest version of [debian:stretch](https://hub.docker.com/r/resin/armv7hf-debian/tags/) with installed Internet of Things flow-based programming web-tool [Node-RED](https://nodered.org/) and one extra node *LED* providing access to the two LEDs.

#### Container prerequisites

##### Port mapping

To allow the access to the Node-RED programming tool over a web browser the container TCP port `1880` needs to be exposed to the host.

##### Privileged mode

The two orange user LEDs are physically connected to the signals BCM12 and BCM13. On netPI these two LED signals appear in `/sys/class/leds` as it is usual for LED handling under Linux. The LED devices under this class have the names `user0:orange:user` and `user1:orange:user`.

Only an enabled privileged mode option lifts the enforced container limitations to allow usage of Host Linux `/sys/class` devices in a container.

#### Getting started

STEP 1. Open netPI's landing page under `https://<netpi's ip address>`.

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under **Containers > Add Container**

* **Image**: `hilschernetpi/netpi-nodered-user-leds`

* **Port mapping**: `Host "1880" (any unused one) -> Container "1880"` 

* **Restart policy"** : `always`

* **Runtime > Privileged mode** : `On`

STEP 4. Press the button **Actions > Start/Deploy container**

Pulling the image may take a while (5-10mins). Sometimes it takes so long that a time out is indicated. In this case repeat the **Actions > Start/Deploy container** action.

#### Accessing

After starting the container open Node-RED in your browser with `http://<netpi's ip address>:<mapped host port>` e.g. `http://192.168.0.1:1880`. One extra node *LED* in the nodes *output* library palette provides you access to the two user LEDs `LED1` and `LED2`. Double click the node to configure which LED to control. Inject a value 0 or 1 to it to switch on/off the LED.

The LED node initially was not written for netPI platform only, but for others too that may have a different number of LEDs. This is why the flexible node iterates the `/var/platform` folder for symbolic links named `LEDx` during its initialization. All `LEDx` links found will be turned to configureable LEDs e.g. LED1, LED2 ... .

#### Automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry systems. This is why the Dockerfile includes the [balena.io](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

#### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
