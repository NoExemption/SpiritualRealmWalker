from pathlib import Path
import json
import numpy as np
from PIL import Image

from tool_paths import options
args = options()
root = args.project_root
frames_dir = args.frames_dir
out = args.output_dir or root/'Art/Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/idle'
preview_out = out / 'previews'
preview_out.mkdir(parents=True, exist_ok=True)
source = [Image.open(frames_dir / f'frame_{i:03d}.png').convert('RGB') for i in range(121)]
first = np.asarray(source[0])
last = np.asarray(source[120])
height, width = first.shape[:2]
y, x = np.mgrid[:height, :width]
uv_x = (x + 0.5) / width
uv_y = (y + 0.5) / height
regions = {
    'black_moon': ((.747, .204), (.085, .125)),
    'face': ((.748, .258), (.033, .049)),
    'left_hand': ((.643, .480), (.027, .029)),
    'right_hand': ((.851, .487), (.030, .032)),
}
checks = {'loop_first_last_equal': bool(np.array_equal(first, last)), 'preview_size': [width, height]}
for label, (center, radius) in regions.items():
    mask = ((uv_x-center[0])/radius[0])**2 + ((uv_y-center[1])/radius[1])**2 < .95**2
    checks[label + '_max_channel_change'] = max(int(np.abs(np.asarray(frame).astype(int)-first.astype(int))[mask].max()) for frame in source)
checks['left_text_area_max_channel_change'] = max(int(np.abs(np.asarray(frame)[:, :int(width*.48)].astype(int)-first[:, :int(width*.48)].astype(int)).max()) for frame in source)
checks['frames_with_motion'] = sum(not np.array_equal(first, np.asarray(frame)) for frame in source[1:120])
checks['changed_pixels_at_3_seconds'] = int(np.any(np.asarray(source[30]) != first, axis=2).sum())

# One stable palette avoids introducing quantization flicker between frames.
palette = source[0].quantize(colors=256, method=Image.Quantize.MEDIANCUT)
frames = [frame.quantize(palette=palette, dither=Image.Dither.NONE) for frame in source[:120]]
preview = preview_out / 'character-select-idle-preview.gif'
frames[0].save(preview, save_all=True, append_images=frames[1:], duration=100, loop=0, optimize=True, disposal=1)

# A close-up makes this intentionally very small displacement easier to inspect.
crop = (650, 300, 1260, 690)
detail_palette = source[0].crop(crop).quantize(colors=256, method=Image.Quantize.MEDIANCUT)
details = [frame.crop(crop).quantize(palette=detail_palette, dither=Image.Dither.NONE) for frame in source[:120]]
details[0].save(preview_out / 'character-select-idle-detail.gif', save_all=True, append_images=details[1:], duration=100, loop=0, optimize=True, disposal=1)

(out / 'character-select-idle-validation.json').write_text(json.dumps(checks, indent=2), encoding='utf-8')
print(json.dumps(checks, indent=2))
print(f'preview_bytes={preview.stat().st_size}')
assert checks['loop_first_last_equal'], 'Loop seam differs'
assert checks['frames_with_motion'] > 100, 'Animation is absent'
assert all(checks[k+'_max_channel_change'] == 0 for k in regions), 'Protected anatomy or moon moved'
assert checks['left_text_area_max_channel_change'] == 0, 'Text backdrop moved'
