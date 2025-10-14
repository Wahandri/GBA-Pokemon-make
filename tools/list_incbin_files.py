#!/usr/bin/env python3
"""Collect INCBIN file paths referenced in C headers/sources."""
from __future__ import annotations

import pathlib
import re
import sys
from typing import Iterable

# Match INCBIN macros like INCBIN_U32("path") or INCBIN_S8("path").
INCBIN_REGEX = re.compile(r"INCBIN_[US](?:8|16|32)\s*\(\s*\"([^\"]+)\"")

# Directories to scan for C/C header files containing INCBIN macros.
SEARCH_ROOTS: tuple[str, ...] = ("src", "include")


def iter_source_files() -> Iterable[pathlib.Path]:
    """Yield all .c and .h files under the configured roots."""
    for root in SEARCH_ROOTS:
        for path in pathlib.Path(root).rglob('*'):
            if path.suffix.lower() in {'.c', '.h'}:
                yield path


def collect_incbin_paths() -> list[str]:
    """Return a sorted list of unique INCBIN file paths."""
    paths: set[str] = set()
    for path in iter_source_files():
        try:
            contents = path.read_text(encoding='utf-8')
        except UnicodeDecodeError:
            contents = path.read_text(encoding='latin-1')
        for match in INCBIN_REGEX.finditer(contents):
            paths.add(match.group(1))
    return sorted(paths)


def main() -> None:
    incbin_paths = collect_incbin_paths()
    for entry in incbin_paths:
        print(entry)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(1)
