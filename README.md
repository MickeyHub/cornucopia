<div align="center">
  <img style="margin: 0 auto" src="Cornucopia/Cornucopia/Assets.xcassets/AppIcon.appiconset/AppIcon@3x.png" width="200" height="200"/>
</div>

⚠️ This project has been ended up with the fact that it's impossible to load dynamic libraries from sandbox on devices with iOS10+ 😂

# Cornucopia

Cornucopia is an app like App Store, you can install a huge amount of plugins (not so many yet) from the "grocery tab" which will fetch data from the another repo called [Cornucopia Center](https://github.com/MickeyHub/cornucopia_center). All you have to do is deploying this app onto your iPhone. and choose the plugins you wanna use.

# Cornucopia Center

This is another repo which holds all of the available plugins. All new plugins will be published to this repo and be accessible to you. feel free to create PR to submit your plugin. I'll review the code and the functionality making sure it's useful and harmless before going on the market.

# Idea

I think many functionalities shouldn't be an individual app. Instead, we can collect all of this kind of functionality into one place where people can check and pick like buy things in the grocery. All of those are in one app, not many apps taking up much space on the screen.

# Plugin

Plugin is actually a dynamic framework shipping with a manifest file called 'Cornucopia.plist' which describes the plugin and used in Grocery. for safety reason, we should better use swift because it features namespace which is used to avoid conflict over symbols.

# Limitation

Since all of the plugins are frameworks without codesigning, so it's impossible to submit this app to the App Store. you can run it onto your iPhone straight away, I'm considering deploy it with an Enterprise Account.

# Road Map

This app is still under development. The functionalities are relatively simple. The plugin center has only few plugins. Don't worry, I'll improve it constantly and make more and more practical plugins. And also, I'll be glad to see you publishing your plugins. (Navigate to [Cornucopia Center](https://github.com/MickeyHub/cornucopia_center) to know how to make and publish your own plugin)
