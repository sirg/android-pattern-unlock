## Android Pattern Unlock
Enable quick unlocking of android phone by piping ```input...``` commands to ```adb shell```.

This is useful, if you pair/connect your phone with _adb_ wirelessly without having it in reach.
Once unlocked, you can run scrcpy to poke through the phone while it's elsewhere in your house.

If set up in advance, could be useful in case of a broken screen.

### Usage
- make sure your phone is connected: ```adb devices```
- set environment variable with your phone unlock pattern: ```export PHONE_PATTERN="1 2 3 4 5 6"```
- ```unlock.sh | adb shell```

Unless your phone is the same as mine, you will need to customize the coordinates in the script.
Turning on pattern tracing (_Make Pattern Visible_) in settings may be helpful.

Timing of sleep between commands can also be flaky: if your phone is not unlocking reliably, tweak them.

### Warning:
Obviously, this has all sorts of security weaknesses. Don't use in unsecured environments.
Protect your pattern. Better yet, use a more secure locking mechanism.
