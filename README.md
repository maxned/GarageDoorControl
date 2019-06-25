# Smart Garage Door Opener (and Closer)

One day in the past, I decided that I wanted to be able to control my garage door with my phone so I built this.

First I had to figure out how to control the garage door. My garage door, as I'm sure many others, can be opened or closed by shorting 2 wires that provide power to the garage door opener button.

I also needed a way of knowing whether the door was open or closed.

I am using [Homebridge](https://homebridge.io) with the [GarageCommand](https://www.npmjs.com/package/homebridge-garagedoor-command) plugin.

Here is the [circuit](https://crcit.net/c/15f76ae4) that I built for this project.

![](https://github.com/maxned/GarageDoorOpener/circuit.svg)

Using the transistor we can shortly short the 2 wires going into the garage door causing it to either open or close depending on the current position. If the garage door is either opening or closing, toggling it again causes it to stop wherever it is.

The toggle switch is attached to the garage door opener rail so that it was toggled when the garage door completely opens. This is needed to know the current state of the door.

It takes about 12 seconds for my garage door to either open or close completely.

# Files

`garage_control.py`: The main logic of the garage door opening. Outputs the correct keywords for the Homebridge plugin.

`open.sh`: Signals `garage_control.py` to open the garage door.

`close.sh`: Signals `garage_control.py` to close the garage door.

`state.sh`: Signals `garage_control.py` to output the current state of the garage door.

# Important

To run `garage_control.py` on boot type in `crontab -e` and add `@reboot /home/pi/GarageDoorControl/garage_control.py`.

Make sure to also enable Homebridge to run on boot as well.