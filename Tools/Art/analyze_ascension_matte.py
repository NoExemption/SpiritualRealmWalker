"""Analyze extraction alignment and produce a numeric animation coverage field.

No figure RGB is used from the generated cutout. Runtime samples original 4K art.
"""
from pathlib import Path
import cv2
import numpy as np
import json

from tool_paths import options
args = options()
ROOT = args.project_root
source_path = args.source or ROOT/'Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png'
source = cv2.imread(str(source_path))
cutout_path = args.reference or ROOT/'Art/Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/ascension/character-select-extraction-reference-v1.png'
cutout = cv2.imread(str(cutout_path), cv2.IMREAD_UNCHANGED)
if source is None or cutout is None:
    raise FileNotFoundError(f'Missing source or extraction reference: {source_path}, {cutout_path}')
if source.shape[:2] != (2400,3840):
    raise ValueError('Finalized background must be 3840x2400')
work = args.cache_dir/'ascension'
work.mkdir(parents=True,exist_ok=True)
w,h = 1920,1200
rgb = cv2.resize(source,(w,h), interpolation=cv2.INTER_AREA)
alpha = cv2.resize(cutout[:,:,3],(w,h))
# The generated extraction enlarged the subject; only its aligned silhouette
# is used as an uncertain segmentation prior, never its repainted anatomy.
affine = np.float32([[.8,0,.165*w],[0,.8,.076*h]])
prior = cv2.warpAffine(alpha,affine,(w,h))
kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(41,41))
candidate = cv2.dilate((prior>50).astype('uint8'),kernel)
mask = np.full((h,w),cv2.GC_BGD,np.uint8)
mask[candidate>0] = cv2.GC_PR_BGD
mask[prior>190] = cv2.GC_PR_FGD
def ellipse(c,r,label):
    cv2.ellipse(mask,(round(c[0]*w),round(c[1]*h)),(round(r[0]*w),round(r[1]*h)),0,0,360,label,-1)
ellipse((.7465,.209),(.0805,.1115),cv2.GC_FGD)
ellipse((.747,.251),(.021,.043),cv2.GC_FGD)
ellipse((.747,.410),(.046,.130),cv2.GC_FGD)
ellipse((.746,.637),(.039,.142),cv2.GC_FGD)
ellipse((.746,.828),(.015,.029),cv2.GC_FGD)
ellipse((.721,.778),(.013,.028),cv2.GC_FGD)
# Fixed palm/finger regions remain certain original foreground.
ellipse((.643,.480),(.026,.027),cv2.GC_FGD)
ellipse((.851,.487),(.028,.030),cv2.GC_FGD)
for center,radius in [((.584,.572),(.04,.045)),((.606,.401),(.042,.023)),((.899,.641),(.038,.042)),((.879,.436),(.035,.029)),((.812,.726),(.028,.032))]:
    ellipse(center,radius,cv2.GC_PR_FGD)
mask[:,:int(w*.485)] = cv2.GC_BGD
mask[:,int(w*.99):] = cv2.GC_BGD
bg_model=np.zeros((1,65),np.float64); fg_model=np.zeros((1,65),np.float64)
cv2.grabCut(rgb,mask,None,bg_model,fg_model,5,cv2.GC_INIT_WITH_MASK)
matte=np.where((mask==cv2.GC_FGD)|(mask==cv2.GC_PR_FGD),255,0).astype('uint8')
# Remove disconnected single specks, retaining garment islands and fine hair.
n,labels,stats,_=cv2.connectedComponentsWithStats(matte,8)
for i in range(1,n):
    if stats[i,cv2.CC_STAT_AREA] < 12: matte[labels==i]=0
full=cv2.resize(matte,(3840,2400),interpolation=cv2.INTER_LINEAR)
# Hough circle fit on original pixels: moon stays a clean rigid circle, rather
# than inheriting graph-cut inclusions of similarly dark surrounding clouds.
yy,xx=np.mgrid[:2400,:3840]
distance=np.sqrt((xx-2866.5)**2+(yy-550.5)**2)
circle=np.clip((309.8-distance)*.7+.5,0,1)*255
full[yy<660]=circle[yy<660].astype('uint8')
(work/'ascension-coverage.r8').write_bytes(full.tobytes())
removal = cv2.dilate(full,cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(81,81)))
removal = np.maximum(full,cv2.GaussianBlur(removal,(31,31),5))
(work/'ascension-removal.r8').write_bytes(removal.tobytes())
report={'algorithm':'AI extraction prior + original-image graph-cut coverage analysis','source_size':[3840,2400], 'analysis_size':[w,h], 'generated_rgb_used_for_figure':False,'covered_pixels':int((full>127).sum()),'left_half_coverage':int((full[:,:1843]>0).sum())}
(work/'ascension-matte-analysis.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report))
