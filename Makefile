APP_NAME := NFOViewer
APP_BUNDLE := build/$(APP_NAME).app
CONTENTS := $(APP_BUNDLE)/Contents
MACOS := $(CONTENTS)/MacOS
RES := $(CONTENTS)/Resources

SWIFT_SOURCES := $(wildcard src/*.swift)

.PHONY: all clean run

all: $(APP_BUNDLE)

$(APP_BUNDLE): $(SWIFT_SOURCES) resources/Info.plist
	@mkdir -p $(MACOS) $(RES)
	@cp resources/Info.plist $(CONTENTS)/Info.plist
	@cp resources/dos437.ttf $(RES)/dos437.ttf
	iconutil -c icns -o $(RES)/icon.icns icon.iconset
# Compile + link a Cocoa app
	@swiftc -O \
	  -o $(MACOS)/$(APP_NAME) \
	  $(SWIFT_SOURCES) \
	  -framework Cocoa \
	  -framework CoreText

# Optional but common: ensure executable bit
	@chmod +x $(MACOS)/$(APP_NAME)

run: all
	open $(APP_BUNDLE)

clean:
	rm -rf build
