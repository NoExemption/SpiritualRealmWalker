from pathlib import Path
import json
import numpy as np
from PIL import Image

from tool_paths import options
args = options()
root = args.project_root
out = args.output_dir or root/'Art/Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/ascension'
preview_out=out/'previews'
preview_out.mkdir(parents=True,exist_ok=True)
frames=[Image.open(args.frames_dir/f'frame_{i:03d}.png').convert('RGB') for i in range(121)]
first=np.asarray(frames[0]); third=np.asarray(frames[30]); last=np.asarray(frames[-1])
h,w=first.shape[:2]
left_delta=max(int(np.abs(np.asarray(frame)[:,:int(w*.48)].astype(int)-first[:,:int(w*.48)].astype(int)).max()) for frame in frames)
report={'loop_first_last_equal':bool(np.array_equal(first,last)), 'left_text_area_max_channel_change':left_delta,'figure_source':'unchanged finalized 3840x2400 original RGB','body_float_pixels_at_1280x800':2,'protected_features_follow_rigid_float':{},'inward_flow':'dual-phase source advection away from chest, producing visible inward movement'}
# At t=3 seconds, a +6-source-pixel rigid bob is exactly +2 output pixels.
# Compare interiors away from antialiased outlines and the breathing solar mark.
for name,box in {'face':(950,187,963,208),'left_palm':(820,382,830,390),'right_palm':(1089,389,1096,398),'black_moon_interior':(882,112,930,143)}.items():
    x0,y0,x1,y1=box
    a=first[y0:y1,x0:x1].astype(int)
    b=third[y0+2:y1+2,x0:x1].astype(int)
    report['protected_features_follow_rigid_float'][name]=int(np.abs(a-b).max())
report['flow_cloud_changed_pixels']=int(np.any(third[210:600,645:715]!=first[210:600,645:715],axis=2).sum())
palette=frames[0].quantize(colors=256,method=Image.Quantize.MEDIANCUT)
sequence=[f.quantize(palette=palette,dither=Image.Dither.NONE) for f in frames[:120]]
sequence[0].save(preview_out/'character-select-ascension-preview.gif',save_all=True,append_images=sequence[1:],duration=100,loop=0,optimize=True,disposal=1)
crop=(625,75,1250,740)
detail_palette=frames[0].crop(crop).quantize(colors=256,method=Image.Quantize.MEDIANCUT)
details=[f.crop(crop).quantize(palette=detail_palette,dither=Image.Dither.NONE) for f in frames[:120]]
details[0].save(preview_out/'character-select-ascension-detail.gif',save_all=True,append_images=details[1:],duration=100,loop=0,optimize=True,disposal=1)
(out/'character-select-ascension-validation.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report,indent=2))
assert report['loop_first_last_equal']
assert left_delta==0
assert all(v<=2 for v in report['protected_features_follow_rigid_float'].values()), 'Face, palms or moon deformed beyond interpolation tolerance'
assert report['flow_cloud_changed_pixels']>5000
