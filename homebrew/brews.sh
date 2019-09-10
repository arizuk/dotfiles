# Make sure using latest Homebrew
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# upgrade

# Add Repository
brew tap homebrew/versions || true
brew tap homebrew/binary || true

# Packages
brew install zsh
brew install git
brew install tig
brew install tmux
brew install nkf
brew install lv
brew install wget
brew install tree
brew install coreutils
brew install ngrep
brew install htop-osx
brew install the_silver_searcher
brew install hub

# Remove outdated versions
brew cleanup
