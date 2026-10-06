window.AMAHARA = window.AMAHARA || {};
AMAHARA.U = {
  clamp:(v,a,b)=>Math.max(a,Math.min(b,v)),
  lerp:(a,b,t)=>a+(b-a)*t,
  len:(x,y)=>Math.hypot(x,y),
  norm(x,y){const l=Math.hypot(x,y)||1;return{x:x/l,y:y/l}},
  rects(a,b){return a.x < b.x+b.w && a.x+a.w > b.x && a.y < b.y+b.h && a.y+a.h > b.y},
  dist(a,b){return Math.hypot(a.x-b.x,a.y-b.y)},
  seeded(seed){let s=seed>>>0;return()=>((s=(s*1664525+1013904223)>>>0)/4294967296)},
  approach(v,t,a){return v<t?Math.min(t,v+a):Math.max(t,v-a)},
  now:()=>performance.now()/1000,
  pointInRect(x,y,r){return x>=r.x&&x<=r.x+r.w&&y>=r.y&&y<=r.y+r.h}
};
