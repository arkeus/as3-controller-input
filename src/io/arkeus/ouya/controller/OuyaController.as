package io.arkeus.ouya.controller {
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	import io.arkeus.ouya.control.ButtonControl;
	import io.arkeus.ouya.control.DirectionalPadControl;
	import io.arkeus.ouya.control.JoystickControl;
	import io.arkeus.ouya.control.TriggerControl;

	/**
	 * A class containing the bindings for a single Ouya controller.
	 */
	public class OuyaController extends GameController {
		/** The O face button. */
		public var o:ButtonControl;
		/** The U face button. */
		public var u:ButtonControl;
		/** The Y face button. */
		public var y:ButtonControl;
		/** The A face button. */
		public var a:ButtonControl;

		/** Left shoulder button. */
		public var lb:ButtonControl;
		/** Left shoulder trigger. */
		public var lt:TriggerControl;
		/** Left joystick. */
		public var leftStick:JoystickControl;

		/** Right shoulder button. */
		public var rb:ButtonControl;
		/** Right shoulder trigger. */
		public var rt:TriggerControl;
		/** Right joystick. */
		public var rightStick:JoystickControl;

		/** Directional pad. */
		public var dpad:DirectionalPadControl;

		public function OuyaController(device:GameInputDevice) {
			super(device);
		}

		override protected function bindControls():void {
			var controlMap:Object = {};
			for (var i:uint = 0; i < device.numControls; i++) {
				var control:GameInputControl = device.getControlAt(i);
				controlMap[control.id] = control;
			}

			if (controlMap['BUTTON_100'] != null) {
				// Bindings on Ouya
				o = new ButtonControl(this, controlMap['BUTTON_96']);
				u = new ButtonControl(this, controlMap['BUTTON_99']);
				y = new ButtonControl(this, controlMap['BUTTON_100']);
				a = new ButtonControl(this, controlMap['BUTTON_97']);

				lb = new ButtonControl(this, controlMap['BUTTON_102']);
				rb = new ButtonControl(this, controlMap['BUTTON_103']);
				lt = new TriggerControl(this, controlMap['BUTTON_104']);
				rt = new TriggerControl(this, controlMap['BUTTON_105']);

				leftStick = new JoystickControl(this, controlMap['AXIS_0'], controlMap['AXIS_1'], controlMap['BUTTON_106'], true);
				rightStick = new JoystickControl(this, controlMap['AXIS_11'], controlMap['AXIS_14'], controlMap['BUTTON_107'], true);

				dpad = new DirectionalPadControl(this, controlMap['BUTTON_19'], controlMap['BUTTON_20'], controlMap['BUTTON_21'], controlMap['BUTTON_22']);
			} else {
				// Bindings on PC
				o = new ButtonControl(this, controlMap['BUTTON_6']);
				u = new ButtonControl(this, controlMap['BUTTON_7']);
				y = new ButtonControl(this, controlMap['BUTTON_8']);
				a = new ButtonControl(this, controlMap['BUTTON_9']);

				lb = new ButtonControl(this, controlMap['BUTTON_10']);
				rb = new ButtonControl(this, controlMap['BUTTON_11']);
				lt = new TriggerControl(this, controlMap['BUTTON_18']);
				rt = new TriggerControl(this, controlMap['BUTTON_19']);

				leftStick = new JoystickControl(this, controlMap['AXIS_0'], controlMap['AXIS_1'], controlMap['BUTTON_12'], true);
				rightStick = new JoystickControl(this, controlMap['AXIS_3'], controlMap['AXIS_4'], controlMap['BUTTON_13'], true);

				dpad = new DirectionalPadControl(this, controlMap['BUTTON_14'], controlMap['BUTTON_15'], controlMap['BUTTON_16'], controlMap['BUTTON_17']);
			}
		}

		override public function reset():void {
			a.reset();
			o.reset();
			y.reset();
			a.reset();
			lb.reset();
			rb.reset();
			lt.reset();
			rt.reset();
			leftStick.reset();
			rightStick.reset();
			dpad.reset();
		}
	}
}
