# Dependency Management Script

This script provides a robust solution for managing software dependencies in your projects. It ensures that all necessary tools are available and meet the specified version requirements. With features for handling both mandatory and optional dependencies, as well as support for debugging and execution control, this script is an essential tool for any software development workflow.

## Features

- **Dependency Verification**: Checks if the required tools are installed with the correct versions.
- **Optional Dependencies**: Handles optional tools gracefully, allowing the script to proceed even if some non-critical tools are missing.
- **Debugging Support**: Includes a debug mode for detailed execution logs.
- **Execution Control**: Ability to execute fallback commands for missing dependencies or incorrect versions.
- **Comprehensive Logging**: Provides detailed information about the dependency checking process.

## Getting Started

### Prerequisites

- Bash shell environment.
- Access to standard Unix command-line tools (`sed`, `command`, etc.).

### Installation

1. Clone the repository or download the script to your project directory.
2. Ensure that the script is executable:
   ```
   chmod +x dependency_script.sh
   ```
3. Modify the script to include your specific dependencies and any other customizations you require.

### Usage

To use the script in your project:

1. Source the script in your Bash scripts where dependency checking is required:
   ```bash
   source /path/to/dependency_script.sh
   ```
2. Call the `dependency` function with the required parameters to check each tool. For example:
   ```bash
   dependency "node" "v12.*" "sudo apt install nodejs"
   ```
3. Optionally, use the `optional` function for non-critical dependencies.

## Functions

- `dependency <tool_name> <version_pattern> [fallback_command] [version_flag]`: Main function to check for a mandatory dependency.
- `optional <tool_name> <version_pattern> [fallback_command] [version_flag]`: Function to check for an optional dependency.
- Additional utility functions for internal use.

## Customization

You can customize the script by defining your own dependencies and modifying helper functions to suit your specific requirements.

## Contributing

Contributions to improve the script or extend its functionality are welcome. Please submit a pull request or open an issue to discuss your ideas.

## License

This script is open-source and free to use. Refer to the LICENSE file for more details.

