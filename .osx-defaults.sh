####### Global ##########

# Enable Dark Mode - Requires log out
defaults write "Apple Global Domain" AppleInterfaceStyle -string "Dark"

# Finder: Show File Name extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Auto hide menu bar
defaults write "Apple Global Domain" _HIHideMenuBar -bool true

####### Finder ##########

# Finder: Show File Name extensions
defaults write com.apple.finder AppleShowAllFiles -bool true

# Search on the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

##### Trackpad ##########

# Secondary Click on right corner - Requires log out
defaults write "Apple Global Domain"  ContextMenuGesture -integer 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -integer 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -integer 2

# Silent clicking
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -bool false

##### Dock ##########

# Autohide
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

# Minimize effect
defaults write com.apple.dock mineffect -string scale

# Size
defaults write com.apple.dock tilesize -int 32

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t animate opening applications
defaults write com.apple.dock launchanim -bool false

# Top right screen corner -> Notification Center
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-tr-modifier -int 0


# Add Applications to Dock

# Usage: add_user_app_to_dock Spotify
add_user_app_to_dock () {
    defaults read com.apple.dock | grep -qi "$1"
    if [[ "$?" != 0 ]]; then
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/'"$1"'.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    fi
}

# Usage: add_system_app_to_dock Calendar
add_system_app_to_dock () {
    defaults read com.apple.dock | grep -qi "$1"
    if [[ "$?" != 0 ]]; then
        defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/'"$1"'.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    fi
}

add_system_app_to_dock Calendar
add_system_app_to_dock Mail
add_system_app_to_dock Safari
add_user_app_to_dock iTerm
add_user_app_to_dock Spotify
add_user_app_to_dock Visual\ Studio\ Code
add_user_app_to_dock Slack
add_user_app_to_dock Whatsapp

killall Dock

####### Menu Bar ########

# Clock
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d h:mm a"
defaults write com.apple.menuextra.clock isAnalog -bool false

killall SystemUIServer