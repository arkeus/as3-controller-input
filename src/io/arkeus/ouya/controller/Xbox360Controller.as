package io.arkeus.ouya.controller {
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	import io.arkeus.ouya.control.ButtonControl;
	import io.arkeus.ouya.control.DirectionalPadControl;
	import io.arkeus.ouya.control.JoystickControl;
	import io.arkeus.ouya.control.TriggerControl;

	/**
	 * A class containing the bindings for a single Xbox 360 controller.
	 */
	public class Xbox360Controller extends GameController {
		/** The A face button. */
		public var a:ButtonControl;
		/** The B face button. */
		public var b:ButtonControl;
		/** The X face button. */
		public var x:ButtonControl;
		/** The Y face button. */
		public var y:ButtonControl;

		public var lb:ButtonControl;
		public var lt:TriggerControl;
		public var leftStick:JoystickControl;

		public var rb:ButtonControl;
		public var rt:TriggerControl;
		public var rightStick:JoystickControl;

		public var dpad:DirectionalPadControl;

		public var back:ButtonControl;
		public var start:ButtonControl;

		public function Xbox360Controller(device:GameInputDevice) {
			super(device);
		}

		override protected function bindControls():void {
			var controlMap:Object = {};
			for (var i:uint = 0; i < device.numControls; i++) {
				var control:GameInputControl = device.getControlAt(i);
				controlMap[control.id] = control;
			}

			a = new ButtonControl(this, controlMap['BUTTON_4']);
			b = new ButtonControl(this, controlMap['BUTTON_5']);
			x = new ButtonControl(this, controlMap['BUTTON_6']);
			y = new ButtonControl(this, controlMap['BUTTON_7']);

			lb = new ButtonControl(this, controlMap['BUTTON_8']);
			rb = new ButtonControl(this, controlMap['BUTTON_9']);
			lt = new TriggerControl(this, controlMap['BUTTON_10']);
			rt = new TriggerControl(this, controlMap['BUTTON_11']);

			leftStick = new JoystickControl(this, controlMap['AXIS_0'], controlMap['AXIS_1'], controlMap['BUTTON_14']);
			rightStick = new JoystickControl(this, controlMap['AXIS_2'], controlMap['AXIS_3'], controlMap['BUTTON_15']);

			dpad = new DirectionalPadControl(this, controlMap['BUTTON_16'], controlMap['BUTTON_17'], controlMap['BUTTON_18'], controlMap['BUTTON_19']);

			back = new ButtonControl(this, controlMap['BUTTON_12']);
			start = new ButtonControl(this, controlMap['BUTTON_13']);
		}

		override public function reset():void {
			a.reset();
			b.reset();
			x.reset();
			y.reset();
			lb.reset();
			rb.reset();
			lt.reset();
			rt.reset();
			leftStick.reset();
			rightStick.reset();
			dpad.reset();
			back.reset();
			start.reset();
		}
	}
}
