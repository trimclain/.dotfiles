import re
import subprocess


###############################################################################
# Check Missing Icons in a Font using Wezterm
# Usage:
#   - Modify FILE_WITH_ICONS and FONT_NAME
#   - Run python check-for-missing-icons-in-font.py
# Example:
#   - Get a file with icons, e.g. https://github.com/nvim-tree/nvim-web-devicons/blob/master/lua/nvim-web-devicons/default/icons_by_file_extension.lua  # nopep8
#   - Save it as tmp.txt
#   - Update the font name if necessary
#   - Run this script
###############################################################################


# NOTE: Replace with the actual path to your file
FILE_WITH_ICONS = "tmp.txt"
# NOTE: Replace with the actual font name you are checking for
FONT_NAME = "Maple Mono NF"


def extract_icons(filepath):
    """
    Reads a file, finds lines containing "icon = \"*?\"", extracts the value
    assigned to "icon", and returns a list of these values.

    Args:
        filepath (str): The path to the file to read.

    # nopep8
    Returns:
        list: A list of strings, where each string is the value assigned to "icon".
              Returns an empty list if the file is not found or no matching lines are found.
    """
    icons = []
    try:
        with open(filepath, 'r') as f:
            for line in f:
                match = re.search(r'icon = "(.*?)"', line)
                icons.append(match.group(1))

    except FileNotFoundError:
        print(f"Error: File not found at {filepath}")
    return icons


def check_font_output(icon):
    """
    # nopep8
    Captures the output of a subprocess command and checks if it contains FONT_NAME.

    Returns:
        bool: True if FONT_NAME is found in the output, False with message otherwise.
    """
    try:
        # Replace this with the actual command you are running
        command = "wezterm ls-fonts --text".split(" ")
        result = subprocess.run(
            command + [icon], capture_output=True, text=True, check=True)
        output = result.stdout
        if FONT_NAME in output:
            return True
        else:
            print(f"Icon '{icon}' is not found in 'Maple Mono NF'.")
            return False
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        print(f"Stderr: {e.stderr}")
        return False
    except FileNotFoundError:
        print("Error: The command was not found.")
        return False


if __name__ == "__main__":
    file_path = FILE_WITH_ICONS
    extracted_icons = extract_icons(file_path)
    for i, icon in enumerate(extracted_icons):
        print(f"{i}: {icon}")
        check_font_output(icon)
