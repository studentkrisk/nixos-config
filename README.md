# about

this is my nixos config!

i try to make everything declarative and modular.

in case you have a t2 macbook (which are becoming increasingly rare these days with apple silicon), this is a nice minimal example! the firmware/brcm folder also may be useful for you, as you would otherwise have to get it from an existing macos install.


## ratcheting

this is an idea i stole from [qntm](https://qntm.org/ratchet). effectively, when switching off a depricated feature, you do not allow yourself to add more instances, but the currently living ones can stay. then, whenever you remove a instance, the number will *ratchet* down and prevent you from adding any more. qntm goes into more nuance, but all that is unecessary for my purposes.
