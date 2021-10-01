#  Safari Wallet

## Pop-up

### Setting up the pop-up

1. Open this repo as a project in Xcode

2. In the leftmost top bar breadcrumb, which should be on "macOS" by default, switch it to "iOS"

3. Set the following breadcrumb to a mobile device, perhaps "iPhone 13 Pro"s?

4. Click the play button to start the emulator

5. Once the emulator has loaded (it might take a few minutes), open the Settings app

6. Settings > Safari > Extensions > Wallet Extension

7. Switch to on

### Developing the pop-up

Restarting the phone each time we make a change to a file is inefficient. Here is a better way:

1. Open Safari (on your computer, not the emulator)

2. Open preferences

3. Go to "Advanced" tab

4. Enable develop tab at the bottom

5. In the emulator, open safari and open the wallet extension popup

6. Focus a Safari window on your computer while leaving the emulator and popup open

7. Open the "Develop" tab at the top of your main screen and select the "Simulator - ..." option

8. Then select the "popup.html" option

9. Make changes in the debug window that pops up to see them update on the emulator automatically

I feel like there is still a better way of doing this though.
