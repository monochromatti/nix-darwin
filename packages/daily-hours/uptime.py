"""CLI tool to show uptime hours per day on NixOS/systemd systems."""

import argparse
import subprocess
import sys
from collections import defaultdict
from datetime import date, datetime, timedelta


def get_week_start(d: date) -> date:
    return d - timedelta(days=d.weekday())


def get_boot_sessions():
    result = subprocess.run(
        ["journalctl", "--list-boots", "--no-pager"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print("Error: Could not read boot logs", file=sys.stderr)
        sys.exit(1)

    sessions = []
    for line in result.stdout.strip().split("\n")[1:]:
        parts = line.split()
        if len(parts) < 10:
            continue
        start_str = f"{parts[3]} {parts[4]}"
        end_str = f"{parts[7]} {parts[8]}"
        try:
            start = datetime.strptime(start_str, "%Y-%m-%d %H:%M:%S")
            end = datetime.strptime(end_str, "%Y-%m-%d %H:%M:%S")
            sessions.append((start, end))
        except ValueError:
            continue
    return sessions


def calculate_daily_uptime(sessions):
    daily = defaultdict(float)
    for start, end in sessions:
        current = start
        while current.date() < end.date():
            midnight = datetime.combine(
                current.date() + timedelta(days=1), datetime.min.time()
            )
            hours = (midnight - current).total_seconds() / 3600
            daily[current.date()] += hours
            current = midnight
        hours = (end - current).total_seconds() / 3600
        daily[current.date()] += hours
    return daily


def main():
    parser = argparse.ArgumentParser(description="Show uptime hours per day")
    parser.add_argument(
        "--weeks",
        "-w",
        type=int,
        default=1,
        help="Number of weeks to show (default: 1, current week)",
    )
    parser.add_argument(
        "--subtract",
        "-s",
        type=float,
        default=0,
        help="Subtract this number from all hours",
    )
    args = parser.parse_args()

    sessions = get_boot_sessions()
    if not sessions:
        print("No boot sessions found.")
        return

    daily = calculate_daily_uptime(sessions)

    today = date.today()
    current_week_start = get_week_start(today)
    cutoff = current_week_start - timedelta(weeks=args.weeks - 1)

    filtered = {d: h for d, h in daily.items() if d >= cutoff}

    if not filtered:
        print("No uptime data for the selected period.")
        return

    print(f"{'Date':<12} {'Hours':>8}")
    print("-" * 21)
    for d in sorted(filtered.keys()):
        hours = filtered[d] - args.subtract
        print(f"{d.isoformat():<12} {hours:>8.2f}")


if __name__ == "__main__":
    main()
