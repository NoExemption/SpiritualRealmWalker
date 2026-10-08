from pathlib import Path
from PIL import Image
from tool_paths import options
args = options()
root = args.project_root
frames=[Image.open(args.frames_dir/f'frame_{i:03d}.png').convert('RGB').resize((960,600),Image.Resampling.LANCZOS) for i in range(120)]
output=(args.output_dir/'character-select-ascension-preview.webp') if args.output_dir else root/'Art/Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/ascension/previews/character-select-ascension-preview.webp'
output.parent.mkdir(parents=True,exist_ok=True)
frames[0].save(output,format='WEBP',save_all=True,append_images=frames[1:],duration=100,loop=0,quality=75,method=4)
print(f'web_preview={output} bytes={output.stat().st_size}')
