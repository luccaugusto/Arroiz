#!/usr/bin/env python3

import os
import json
import subprocess
import argparse


def duration_to_seconds(duration):
    """Convert a Duration object with Hours, Minutes, Seconds to total seconds."""
    return int(duration.get("Hours", 0)) * 3600 + int(duration.get("Minutes", 0)) * 60 + int(duration.get("Seconds", 0))


def parse_args():
    parser = argparse.ArgumentParser(
        description="A script to automate ripping DVD titles using HandBrakeCLI.", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument("-i", "--input", default="/dev/sr0", help="The input device or source file.")
    parser.add_argument("-o", "--output", default="ripped_titles", help="The directory to save ripped titles to.")
    parser.add_argument("-p", "--preset", default="slower", help="The HandBrakeCLI preset to use for ripping.")
    parser.add_argument("-n", "--name", required=True, help="The name of the media (e.g., the movie title), used for output files.")
    parser.add_argument(
        "-t", "--title", type=int, default=None, help="If specified, only this title will be ripped and the script will exit."
    )
    parser.add_argument(
        "-e",
        "--extras-only",
        default=False,
        action="store_true",
        help="Skip main title and only rip extras.",
    )
    return parser.parse_args()


def get_titles_info(source_device):
    # This command scans the DVD for all titles (-t 0) and outputs information in JSON
    # the awk command filters out non relevant output
    command = f"HandBrakeCLI -i {source_device} -t 0 --json 2>/dev/null | awk '/JSON Title Set/{{f=1}}f'"
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        output = result.stdout
        # The awk command ensures we start from the "JSON Title Set" line.
        # We need to find the beginning of the actual JSON object, which is
        # the first opening curly brace.
        json_start = output.find("{")
        if json_start == -1:
            print("Error: Could not find JSON in HandBrakeCLI output.")
            return None

        json_str = output[json_start:]
        return json.loads(json_str)
    except FileNotFoundError:
        print("Error: HandBrakeCLI not found. Make sure it's in your PATH.")
        return None
    except subprocess.CalledProcessError as e:
        print(f"Error running HandBrakeCLI: {e.stderr}")
        return None
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON from HandBrakeCLI output: {e}")
        return None


def rip_title(title, source_device, output_file, preset):
    """Rip a single title from the source device.

    Args:
        title: The title information dictionary
        source_device: The source device or file path
        output_file: Full path to the output file
        preset: The HandBrake preset to use
    """
    title_number = title.get("Index")

    command = [
        "HandBrakeCLI",
        "-i",
        source_device,
        "-t",
        str(title_number),
        "-o",
        output_file,
        "--encoder",
        "x264",
        "--quality",
        "22",
        "--all-subtitles",
        "--all-audio",
        "--encoder-preset",
        preset,
        "--encoder-level",
        "4.1",
        "--encoder-tune",
        "film",
        "--deinterlace",
    ]
    print(f"Ripping title {title_number}  to {output_file}...")

    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, encoding="utf-8", errors="replace")

    # We read and print the output line by line, while also storing it.
    captured_output = []
    if process.stdout:
        for line in iter(process.stdout.readline, ""):
            # Echo only the last line to not polute the terminal
            print(f"\r{line.strip()}\x1b[K", end="", flush=True)
            captured_output.append(line)
        process.stdout.close()

    return_code = process.wait()

    if return_code == 0:
        print(f"\nSuccessfully ripped title {title_number}.")
        return {"status": "success", "path": output_file, "title_number": title_number}
    else:
        print(f"\nError ripping title {title_number}:")
        full_output = "".join(captured_output)

        # Get the directory of the output file for the error log
        output_dir = os.path.dirname(output_file)
        error_log_file = os.path.join(output_dir, f"title_{title_number}_error.log")
        with open(error_log_file, "w") as f:
            f.write(f"Failed to rip title {title_number}.\n\n")
            f.write("--- Parameters ---\n")
            f.write(f"Title Info: {json.dumps(title, indent=2)}\n")
            f.write(f"Source Device: {source_device}\n")
            f.write(f"Output File: {output_file}\n")
            f.write(f"Preset: {preset}\n\n")
            f.write("--- Command ---\n")
            f.write(str(" ".join(command) + "\n\n"))
            f.write("--- HandBrakeCLI Output ---\n")
            f.write(str(full_output))

        print(f"Error details saved to {error_log_file}")
        return {"status": "failure", "path": error_log_file, "title_number": title_number}


def main():
    args = parse_args()
    source_device = args.input
    output_dir = args.output
    preset = args.preset
    media_name = args.name
    extras_only = args.extras_only
    single_title = args.title

    print(f"Fetching title information from {source_device}...")
    titles_info = get_titles_info(source_device)

    if not titles_info:
        print("Error: Could not fetch title information.")
        return

    title_list = titles_info.get("TitleList")
    if not title_list:
        print("Error: Could not find 'TitleList' in the JSON output.")
        return

    print(f"Found {len(title_list)} titles.")

    # Create list of titles to rip
    titles_to_rip = []

    if single_title is not None:
        # If a specific title was requested, only rip that one
        title = next((t for t in title_list if t.get("Index") == single_title), None)
        if not title:
            print(f"Error: Title {single_title} not found")
            return
        output_file = os.path.join(output_dir, f"{media_name} {single_title}.mkv")
        os.makedirs(output_dir, exist_ok=True)
        titles_to_rip.append((title, output_file))
    else:
        # Find the main title (longest duration)
        main_title = None
        max_duration = 0
        for title in title_list:
            duration = title.get("Duration")
            if duration:
                duration_secs = duration_to_seconds(duration)
                if duration_secs > max_duration:
                    max_duration = duration_secs
                    main_title = title

        if not main_title:
            print("Error: Could not determine main title")
            return

        main_title_number = main_title.get("Index")
        print(
            f"Detected main title as #{main_title_number} (duration: {main_title['Duration']['Hours']}:{main_title['Duration']['Minutes']}:{main_title['Duration']['Seconds']})"
        )

        # Create output directories
        os.makedirs(output_dir, exist_ok=True)
        extras_dir = os.path.join(output_dir, "Extras")
        os.makedirs(extras_dir, exist_ok=True)

        # Add main title first unless extras_only is True
        if not extras_only:
            main_output_file = os.path.join(output_dir, f"{media_name}.mkv")
            titles_to_rip.append((main_title, main_output_file))

        # Add all other titles as extras
        for title in title_list:
            if title.get("Index") != main_title_number and duration_to_seconds(title.get("Duration")) > 60:
                title_number = title.get("Index")
                extra_output_file = os.path.join(extras_dir, f"{media_name} Extras {title_number}.mkv")
                titles_to_rip.append((title, extra_output_file))

    # Process all titles
    successful_rips = []
    failed_rips = []
    total_titles = len(titles_to_rip)

    print("\n--- Starting Ripping Process ---")
    print(f"Ripping {total_titles} titles")
    for index, element in enumerate(titles_to_rip):
        title, output_file = element
        print(
            f"title {index} out of {total_titles}: length {title.get("Duration").get("Hours")}:{title.get("Duration").get("Minutes")}:{title.get("Duration").get("Seconds")}"
        )
        result = rip_title(title, source_device, output_file, preset)
        if result["status"] == "success":
            successful_rips.append(result)
        else:
            failed_rips.append(result)

    # Print summary
    print("\n--- Rip Summary ---")
    print(f"Total titles found: {len(title_list)}")

    if successful_rips:
        print(f"\nSuccessfully ripped {len(successful_rips)} titles:")
        for result in successful_rips:
            print(f" - Title {result['title_number']}: {result['path']}")

    if failed_rips:
        print(f"\nFailed to rip {len(failed_rips)} titles:")
        for result in failed_rips:
            print(f" - Title {result['title_number']}: {result['path']}")


if __name__ == "__main__":
    main()
