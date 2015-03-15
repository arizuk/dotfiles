# Make sure using latest Homebrew
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# upgrade

# Add Repository
brew tap homebrew/versions || true
brew tap phinze/homebrew-cask || true
brew tap homebrew/binary || true
# Packages

brew install zsh
brew install git
brew install tig
brew install tmux
brew install ack
brew install nkf
brew install lv
brew install wget
brew install tree
brew install pidof
brew install cmake
brew install mosh
brew install proctools
brew install markdown
brew install coreutils
brew install brew-cask
brew install ngrep
brew install htop-osx
brew install the_silver_searcher
brew install hub
brew install rbenv
brew install ruby-build
# install packer
# install gist
# install rmtrash
# install ctags
# install pkg-config
# install libtool
# install autoconf
# install automake
#install imagemagick
brew install reattach-to-user-namespace
brew install gauche

# .dmg
# cask install google-chrome
# cask install iterm2
# cask install kobito
# cask install virtualbox
# cask install vagrant
# cask install echofon

# Remove outdated versions
brew cleanup
