# Smart Garage Door Opener (and Closer)

One day in the past, I decided that I wanted to be able to control my garage door with my phone so I built this.

First I had to figure out how to control the garage door. My garage door, as I'm sure many others, can be opened or closed by shorting 2 wires that provide power to the garage door opener button.

I also needed a way of knowing whether the door was open or closed.

Here is the [circuit](https://crcit.net/c/15f76ae4) that I built for this project.

![](https://raw.githubusercontent.com/maxned/GarageDoorControl/master/circuit.png =250x)

Using the transistor we can shortly short the 2 wires going into the garage door causing it to either open or close depending on the current position. If the garage door is either opening or closing, toggling it again causes it to stop wherever it is.

The toggle switch is attached to the garage door opener rail so that it was toggled when the garage door completely opens. This is needed to know the current state of the door.

It takes about 12 seconds for my garage door to either open or close completely.

# Dependencies

- [Homebridge](https://homebridge.io)
- [GarageCommand](https://www.npmjs.com/package/homebridge-garagedoor-command) Homebridge plugin
- [RPyC](https://rpyc.readthedocs.io)

# Homebridge Config

This is the configuration for the GarageCommand Homebridge plugin/accessory that goes in the `~/.homebridge/config.json` file.

```
{
    "accessory": "GarageCommand",
    "name": "Garage Door",
    "open": "~/GarageDoorControl/control.py open",
    "close": "~/GarageDoorControl/control.py close",
    "state": "~/GarageDoorControl/control.py state",
    "status_update_delay": 12,
    "poll_state_delay": "5"
}
```

# Files

`garage_control.py`: The main logic of the garage door opening. Outputs the correct keywords for the Homebridge plugin.

`control.py`: Contacts `garage_control.py` using RPyC to either open/close the garage or get the current state.

# Running on Boot

To run `garage_control.py` on boot type in `crontab -e` and add `@reboot /home/pi/GarageDoorControl/garage_control.py`.

Make sure to also enable Homebridge to run on boot as well by following the instructions [here](https://github.com/nfarina/homebridge/wiki/Running-HomeBridge-on-a-Raspberry-Pi#running-homebridge-on-bootup).

# Future Work

I am using the Raspberry Pi Zero W and it is really slow when calling the `control.py` script. It takes a while to start executing a python script as well as import rpyc. An improvement would be to not use Python at all but to just use the shell which would be a lot faster.

Another improvement would be to use a more powerful Raspberry Pi.