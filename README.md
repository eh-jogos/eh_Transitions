# eh_Transitions

Godot Plugin to help with transition effects. It has an autoload which will be above any other canvas layer with a ColorRect taking the full screen. Then you can use the SceneChanger node to change scenes with a transition of your choice. The SceneChanger node takes a custom resource of type TransitionData as one of it's editor parameter and will do the transition based on it.

There are some Sample transition datas ready in the addon folder that you can use with simple transitions like curtain or sweep. Not using any transition data will result in a simple fade.

In each transition data you can specify:
- **color** - the color of the ColorRect in teh autoload
- **duration** - the duration of each half of the transition
- **mask** - the grayscale image that will be used to guide the transition
- **smooth_size** - the amount of "feathering" or "smoothness" you want between what is still visible and what is already opaque during the transition
- **transition_in** - the behavior of the "in" transition.
- **transition_out** - the behavior of the "out" transition.

There is also two test scenes setup to transition from one to the other and you can use them to test transtion datas and see an example of how to use the scene changer.

You likely will want to have your own loading manager for loading scenes, so in that case you can use the public methods to integrate your loading manager to the eh_Transitions autoload. In that case take a look at the `eh_SceneChanger`script for some examples of how you might want to do it, or even, extend the `eh_SceneChanger` and override the methods you need.

## License
This is Licensed under MIT as you and see in the LICENSE file, so use it however you want, in any comercial projects or not, just link this repository or this readme in the credits or somewhere.

## Support
If you like this project and want to support it, any improvements pull request is welcomed!

Or if you prefer, you can also send a tip through [ko-fi](https://ko-fi.com/eh_jogos) or take a look at my [patreon](https://www.patreon.com/eh_jogos)!
