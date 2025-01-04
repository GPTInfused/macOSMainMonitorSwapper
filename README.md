# macOS Main Display Swapper

A simple Swift-based command-line tool that swaps the main monitor on macOS while maintaining the relative positioning of all connected displays.

Inspired by [hmscreens](https://github.com/mikeakers/hmscreens), this tool is ideal for users who frequently switch their primary monitor but want to keep their display arrangement intact.

## Features

- Swap the main monitor with ease.
- Preserve the positioning of all other displays.
- Lightweight and fast.
- Simple command-line interface.
- Limitation: As of v1.2, the tool currently supports only two monitors. Support for multiple monitors is under development and will be available in future updates.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/GPTInfused/macOSMainMonitorSwapper.git
   cd MainDisplaySwapper
   ```

2. Build the project using Xcode or the Swift Package Manager (SPM):

   ```bash
   swift build -c release
   ```

3. Copy the executable to a directory in your PATH for easy access:

   ```bash
   cp .build/release/swapMainDisplay /usr/local/bin/
   ```

## Usage

Run the tool from the command line:

```bash
swapMainDisplay
```

After execution, your main monitor will be swapped with another display in your setup. The relative arrangement of displays will remain unchanged.

## How It Works

The tool leverages macOS APIs to identify connected displays, determine the current main monitor, and swap it with another display while retaining their spatial configuration. This avoids the hassle of rearranging windows or adjusting display positions manually.

## Compatibility

- macOS 10.13 (High Sierra) or later

## Contributing

Contributions are welcome! If you encounter any issues, have suggestions, or would like to contribute, please:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Acknowledgments

- Inspired by [hmscreens](https://github.com/mikeakers/hmscreens).
- Thanks to the macOS development community for their resources and tools.

