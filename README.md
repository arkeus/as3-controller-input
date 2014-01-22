AS3 Controller Input
====================

AS3 Controller Input is a library used for abstracting away all the game input logic within Adobe AIR, allowing you to have a simple interface to use Ouya and Xbox360 controllers within your flash game.

Warning
-------

Work in progress. Use at your own risk.

Requirements
------------
Adobe Air 3.8+ SDK (beta)
Flash Player 11.8+ (beta)

What Does It Do?
----------------

It allows you to easily get interfaces to interact with any number of connected ouya or xbox controllers. Once you grab a connected controller, you can test:

* Button presses
* Button holding
* Joystick angle
* Joystick distance
* Joystick axis values
* Trigger values

Quick Start
-----------

1. Add AS3 Controller Input to your project (copy the source files over, or add the external folder to your build path).

2. Call

		ControllerInput.initialize(stage)
	
3. Check if there are connected controllers that are ready, grab one, store a reference:

		if (ControllerInput.hasReadyController()) {
			ouyaController = ControllerInput.getReadyController() as OuyaController;
		}
	
4. Read input whenever you want!

		ouyaController.a.pressed || ouyaController.b.held // Just pressed, or held down
		ouyaController.lt.value > 0.3 // The left trigger is held down more than 30% of thew ay
		ouyaController.rightStick.angle > Math.PI / 2 && ouyaController.rightStick.distance > 0.5 // Read joystick input in multiple ways
	
Documentation
-------------

Coming soon: Code will be documented.

### Setting up the library

Before you can start using the library, you must call:

	ControllerInput.initialize(stage)
	
You must pass a reference to the main stage to it, such that it can bind event listeners. Behind the scenes this will set up all necessary listeners to reading input.

Whenever a controller is connected (and for each one already connected when you initialize the library), the controller will be placed in the ready queue. This allows you to ignore controllers, or grab new ones at your own speed.

You can check whether there are any controllers that are ready to be used by checking the return value of:

	ControllerInput.hasReadyController()
	
If this returns true, you can grab a controller that is ready to be used by calling:

	ControllerInput.getReadyController()
	
This will return a subclass of GameController. Currently, depending on the controller, it will return either an OuyaController or an Xbox360Controller. You should check the return type and set it accordingly. If it's not a controller you want to support, feel free to ignore it as getReadyController() will pull it out of the queue.

If a device is detached, the controller will have the ''removed'' property set to true. Also, the GameController instance will be added to the removed queue. You can check and read from this in the same was as with the ready queue:

	if (ControllerInput.hasRemovedController()) {
		controller = ControllerInput.getRemovedController();
		if (currentController == controller) {
			currentController = null;
		}
	}

### Control Types

There are multiple different control types, each which can be read in specific ways.

#### Button

Buttons are binary controls, such as the A button and the right shoulder button (not the trigger). These either have a value of 0 or 1.

	button.pressed - Returns true if the button was just pressed (returns true once per press).
	button.released - Returns true if the button was just released (returns true once per release).
	button.held - Returns true if the button is currently being held down (returns true as long as the button is being held down).
	button.value - 1 if it's being held down, 0 if it's not.
	
#### Trigger

Triggers are a special type of button that has a range from 0 to 1 for its value. Examples of triggers are the shoulder triggers (which can you press down partially). The trigger class is just a special helper class that adds a distance method for reading the value.

	trigger.pressed - Returns true if the button was just pressed more than halfway down.
	trigger.released - Returns true if the button was just released after being held more than halfway down.
	trigger.held - Returns true if the button is currently being held down more than half way.
	trigger.distance - Returns a Number between 0 and 1, where 0 means not being held down, 0.5 means halfway down, and 1 means all the way down.
	
#### Joysticks

Joysticks map to free range controls. Most modern controlers contain two of them. Each joystick has 2 axes (the x-axis and the y-axis), and most can be pressed down like a button. Note that most joysticks do not rest directly in the center. If a joystick has an x or y value of something small (such as 0.09) it might not be being touched at all, and should be accounted for.

	joystick.x - Returns a number from -1 (joystick all the way left) to 1 (joystick all the way right).
	joystick.y - Returns a number from -1 to 1. On some controllers -1 is up while on others 1 is up.
	joystick.angle - Returns the angle, in radians from -Math.PI to +Math.PI, of the direction the joystick is currently being held in.
	joystick.distance - Returns a distance from 0 to 1, that the joystick is being held (not touching it is 0, holding it all the way in any direction is 1)
	joystick.pressed - Returns true if the joystick was just pressed down as a button (returns true once per press).
	joystick.released - Returns true if the joystick was just released as a button (returns true once per release).
	joystick.held - Returns true if the joystick is currently being held down as a button (returns true as long as the button is being held down).
	Buttons - Each of these can be used as a button with all the same methods (eg. joystick.left.pressed):
		joystick.button - If the joystick can be pushed down, this button represents that control
		joystick.left - Treats pushing the joystick left as a button (will return pressed if you push it at least halfway left)
		joystick.right - Treats pushing the joystick left as a button (will return pressed if you push it at least halfway right)
		joystick.up - Treats pushing the joystick left as a button (will return pressed if you push it at least halfway up)
		joystick.down - Treats pushing the joystick left as a button (will return pressed if you push it at least halfway down)

#### Directional Pads

Directional pads are just a helper for containing the 4 buttons on the D-Pad.

	dpad.up - Returns a button representing the up button (you can use all button methods on it)
	dpad.down - Returns a button representing the down button (you can use all button methods on it)
	dpad.left - Returns a button representing the left button (you can use all button methods on it)
	dpad.right - Returns a button representing the right button (you can use all button methods on it)
	
	
### Controller Mappings

#### Ouya

The following is a mapping of the Ouya controller, and the various ways to read the controls.

	controller.o - Button - The O button
	controller.u - Button - The U button
	controller.y - Button - The Y button
	controller.a - Button - The A button
	
	controller.lb - Button - The L1 shoulder button
	controller.lt - Trigger - The L2 shoulder trigger
	
	controller.rb - Button - The R1 shoulder button
	controller.rt - Trigger - The R2 shoulder trigger
	
	controller.leftStick - Joystick - The left ouya joystick
	controller.rightStick - Joystick - The right ouya joystick
	
	controller.dpad - Directional Pad - The directional pad

There currently appears no way to read the home button in the middle of the controller.

#### Xbox 360

The following is a mapping of the Xbox360 controller, and the various ways to read the controls.

	controller.a - Button - The A button
	controller.b - Button - The B button
	controller.x - Button - The X button
	controller.y - Button - The Y button
	
	controller.lb - Button - The L1 shoulder button
	controller.lt - Trigger - The L2 shoulder trigger
	
	controller.rb - Button - The R1 shoulder button
	controller.rt - Trigger - The R2 shoulder trigger
	
	controller.leftStick - Joystick - The left ouya joystick
	controller.rightStick - Joystick - The right ouya joystick
	
	controller.dpad - Directional Pad - The directional pad
	
	controller.back - Button - The Back button
	controller.start - Button - The Start button

Supported Controllers
---------------------

* Ouya Controllers (PC and on Ouya)
* Xbox360 Controllers (PC only currently)

Note that the OuyaController should work consistently on the Ouya. Please let me know if it does not work on the PC (I'm currently unaware if drivers and connection method change the bindings that each control on the controller gets).

Note
----

Inspired by Terry Cavanagh's Controller class.

Topics
------

* **Flash Ouya Input**
* **Flash Game Ouya Controller**
* **AS3 Ouya Input**
* **AS3 Ouya Controller**
* **Adobe Air Ouya Input**
