# NFO Viewer
A simple, lightweight viewer for Code Page 437 text files (sometimes called "ANSI Art"), commonly distributed as `.nfo` files, especially in Scene releases.

## Building from source
```
git clone 
make
```


## Optionally "install" to Applications folder
```
sudo cp -R build/NFOViewer.app /Applications/NFOViewer.app

# tell Gatekeeper to stfu
sudo xattr -dr com.apple.quarantine /Applications/NFOViewer.app

# register with launch services
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/NFOViewer.app
```
