#!/usr/bin/env python3


import argparse
import os
import re
import subprocess
import sys

# NOTE: colors aren't displayed in lf where this is meant to be used
from colorama import Fore, Style, init


def main():
    # Initialize colorama for cross-platform colored terminal output
    init()

    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Pretty-print file information for Word documents',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument('filename', nargs='?', help='Word document to analyze')
    args = parser.parse_args()

    # If no filename provided, show help message and exit
    if not args.filename:
        parser.print_help()
        sys.exit(0)

    try:
        # Run the file command and capture its output
        result = subprocess.run(['file', args.filename],
                                capture_output=True, text=True, check=True)
        raw_output = result.stdout.strip()

        # Check if it's a Word document
        if "Composite Document File V2 Document" not in raw_output:
            print(
                f"{Fore.RED}Error:{Style.RESET_ALL} This doesn't appear to be a Word document.")
            sys.exit(1)

        # Extract metadata using regex patterns
        filename = os.path.basename(args.filename)
        filetype = extract_value(raw_output, rf'{filename}:\s*(.*?),')
        title = extract_value(raw_output, r'Title:\s*(.*?),')
        author = extract_value(raw_output, r'Author:\s*(.*?),')
        template = extract_value(raw_output, r'Template:\s*(.*?),')
        revision = extract_value(raw_output, r'Revision Number:\s*(.*?),')
        operating_system = extract_value(raw_output, r'Os:\s*(.*?),')
        version = extract_value(raw_output, r'Version\s*(.*?),')
        code_page = extract_value(raw_output, r'Code page:\s*(.*?),')

        edit_time = extract_value(raw_output, r'Total Editing Time:\s*(.*?),')
        last_printed = extract_value(raw_output, r'Last Printed:\s*(.*?),')
        creation_date = extract_value(
            raw_output, r'Create Time/Date:\s*(.*?),')
        last_saved = extract_value(
            raw_output, r'Last Saved Time/Date:\s*(.*?)')

        # Print formatted output
        print(
            f"\n{Fore.CYAN}╔══════════════════════════════════════════════╗{Style.RESET_ALL}")
        print(f"{Fore.CYAN}║{Style.RESET_ALL}{' ' * 11}{Fore.YELLOW}WORD DOCUMENT INFORMATION{Style.RESET_ALL}{' ' * 10}{Fore.CYAN}║{Style.RESET_ALL}")
        print(
            f"{Fore.CYAN}╚══════════════════════════════════════════════╝{Style.RESET_ALL}")

        print(f"\n{Fore.YELLOW}General:{Style.RESET_ALL}")
        print(f"  {Fore.CYAN}Filename:{Style.RESET_ALL} {filename}")
        print(
            f"  {Fore.CYAN}Type:{Style.RESET_ALL} {Fore.GREEN}{filetype}{Style.RESET_ALL}")
        print(
            f"  {Fore.CYAN}OS:{Style.RESET_ALL} {operating_system or 'Not specified'}")
        print(f"  {Fore.CYAN}Version:{Style.RESET_ALL} {version or 'Not specified'}")
        print(
            f"  {Fore.CYAN}Code Page:{Style.RESET_ALL} {code_page or 'Not specified'}")

        print(f"\n{Fore.YELLOW}Document Properties:{Style.RESET_ALL}")
        print(f"  {Fore.CYAN}Title:{Style.RESET_ALL} {title or 'Not specified'}")
        print(f"  {Fore.CYAN}Author:{Style.RESET_ALL} {author or 'Not specified'}")
        print(
            f"  {Fore.CYAN}Template:{Style.RESET_ALL} {template or 'Not specified'}")
        print(
            f"  {Fore.CYAN}Revision:{Style.RESET_ALL} {revision or 'Not specified'}")

        print(f"\n{Fore.YELLOW}Time Information:{Style.RESET_ALL}")
        print(f"  {Fore.CYAN}Created:{Style.RESET_ALL} {format_date(creation_date)}")
        print(f"  {Fore.CYAN}Last Saved:{Style.RESET_ALL} {format_date(last_saved)}")
        print(
            f"  {Fore.CYAN}Last Printed:{Style.RESET_ALL} {format_date(last_printed)}")
        print(
            f"  {Fore.CYAN}Total Editing Time:{Style.RESET_ALL} {edit_time or 'Not specified'}")

    except subprocess.CalledProcessError as e:
        print(
            f"{Fore.RED}Error running file command:{Style.RESET_ALL} {e}", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} 'file' command not found. Please install it.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"{Fore.RED}Unexpected error:{Style.RESET_ALL} {e}", file=sys.stderr)
        sys.exit(1)


def extract_value(text, pattern):
    """Extract a value using regex pattern"""
    match = re.search(pattern, text)
    if match:
        return match.group(1).strip()
    return None


def format_date(date_str):
    """Format date string to make it more readable"""
    if not date_str:
        return "Not specified"
    return date_str


if __name__ == "__main__":
    main()
