"""Project-relative inputs and disposable output locations for art tools."""
import argparse
from pathlib import Path


def options():
    parser = argparse.ArgumentParser()
    parser.add_argument('--project-root', type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument('--cache-dir', type=Path)
    parser.add_argument('--frames-dir', type=Path)
    parser.add_argument('--output-dir', type=Path)
    parser.add_argument('--source', type=Path)
    parser.add_argument('--reference', type=Path)
    args = parser.parse_args()
    args.project_root = args.project_root.resolve()
    args.cache_dir = args.cache_dir or args.project_root / '.godot/tool-output'
    args.cache_dir.mkdir(parents=True, exist_ok=True)
    args.frames_dir = args.frames_dir or args.cache_dir / 'idle-preview-frames'
    return args
