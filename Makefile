# Build the package for iOS Simulator
build:
	swift build -v

# Clean the build directory
clean:
	swift package clean
	rm -rf .build

.PHONY: build clean
