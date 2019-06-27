# Smart Garage Door Opener (and Closer)

One day in the past, I decided that I wanted to be able to control my garage door with my phone so I built this.

First I had to figure out how to control the garage door. My garage door, as I'm sure many others, can be opened or closed by shorting 2 wires that provide power to the garage door opener button.

I also needed a way of knowing whether the door was open or closed.

Here is the [circuit](https://crcit.net/c/15f76ae4) that I built for this project.

<p align="center">
  <img src="https://raw.githubusercontent.com/maxned/GarageDoorControl/master/circuit.png" width="300" title="Github Logo">
</p>

Using the transistor we can shortly short the 2 wires going into the garage door causing it to either open or close depending on the current position. If the garage door is either opening or closing, toggling it again causes it to stop wherever it is.

The toggle switch is attached to the garage door opener rail so that it was toggled when the garage door completely opens. This is needed to know the current state of the door.

It takes about 12 seconds for my garage door to either open or close completely.

Interrupting the door while it is opening or closing will be ignored and the door will continue opening or closing. This is because the garage door is unpredictable if interrupted in while the door is moving.

# Dependencies

- [Homebridge](https://homebridge.io)
- [GarageCommand](https://www.npmjs.com/package/homebridge-garagedoor-command) Homebridge plugin
- [WiringPi](http://wiringpi.com/)

Here are the commands you can use to install everything you will need if you are running Raspbian Lite.

```
sudo apt install npm
sudo npm install -g homebridge
npm install -g homebridge-garagedoor-command
sudo apt install wiringpi
```

# Homebridge Config

This is the configuration for the GarageCommand Homebridge plugin/accessory that goes in the `~/.homebridge/config.json` file.

```
{
    "accessory": "GarageCommand",
    "name": "Garage Door",
    "open": "~/GarageDoorControl/control.sh open",
    "close": "~/GarageDoorControl/control.sh close",
    "state": "~/GarageDoorControl/control.sh state",
    "status_update_delay": 12,
    "poll_state_delay": "5"
}
```

# Running on Boot

To run Homebridge and correctly setup the GPIO pins on boot type `crontab -e` and add the following lines:
```
@reboot /home/pi/GarageDoorControl/control.sh setup
@reboot /usr/local/bin/homebridge
```
