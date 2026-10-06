window.AMAHARA = window.AMAHARA || {};
AMAHARA.World = class {
  constructor(game){this.game=game;this.T=24;this.cols=144;this.rows=92;this.w=this.cols*this.T;this.h=this.rows*this.T;this.tiles=new Uint8Array(this.cols*this.rows);this.props=[];this.colliders=[];this.interactables=[];this.rng=AMAHARA.U.seeded(9042026);this.build()}
  idx(x,y){return y*this.cols+x} setTile(x,y,v){if(x>=0&&y>=0&&x<this.cols&&y<this.rows)this.tiles[this.idx(x,y)]=v}
  fill(x0,y0,x1,y1,v){for(let y=y0;y<=y1;y++)for(let x=x0;x<=x1;x++)this.setTile(x,y,v)}
  road(points,r=2){for(const [cx,cy] of points)for(let y=-r;y<=r;y++)for(let x=-r;x<=r;x++)if(x*x+y*y<=r*r+1)this.setTile(cx+x,cy+y,1)}
  addProp(type,x,y,opt={}){const p={type,x,y,...opt};this.props.push(p);if(opt.collider)this.colliders.push({x:x+opt.collider.x,y:y+opt.collider.y,w:opt.collider.w,h:opt.collider.h,type});return p}
  build(){
    this.fill(0,0,this.cols-1,this.rows-1,0);
    this.fill(95,12,130,44,3); this.fill(118,14,143,38,4);
    // Village roads.
    for(let x=12;x<58;x++)this.road([[x,68]],2);for(let y=50;y<77;y++)this.road([[30,y]],2);
    // Forest trail east then north to shrine.
    for(let x=50;x<100;x++)this.road([[x,58]],2);for(let y=30;y<59;y++)this.road([[96,y]],2);for(let x=96;x<119;x++)this.road([[x,30]],2);
    // River.
    for(let x=62;x<=65;x++)for(let y=18;y<82;y++)this.setTile(x,y,2);for(let y=55;y<=61;y++)for(let x=62;x<=65;x++)this.setTile(x,y,1);
    // Village houses.
    const houses=[[300,1570],[590,1555],[865,1635],[345,1765],[700,1780],[1010,1740]];
    houses.forEach((p,i)=>this.addProp('house',p[0],p[1],{variant:i%3,collider:{x:-34,y:-40,w:68,h:46}}));
    for(let i=0;i<9;i++)this.addProp('tree',140+i*118,1460+(i%2)*38,{collider:{x:-11,y:-8,w:22,h:18}});
    for(let i=0;i<8;i++)this.addProp('tree',170+i*132,1880-(i%2)*35,{collider:{x:-11,y:-8,w:22,h:18}});
    for(let i=0;i<7;i++){this.addProp('fence',170+i*48,1702,{});this.addProp('fence',820+i*48,1702,{})}
    for(let i=0;i<5;i++)this.addProp('lantern',430+i*96,1602,{});
    for(let i=0;i<7;i++)this.addProp('crop',230+i*32,1730,{variant:i%2});
    this.addProp('well',610,1698,{collider:{x:-14,y:-10,w:28,h:20}});
    this.addProp('lantern',1020,1638,{collider:{x:-5,y:-5,w:10,h:8}});
    // Forest density, leaving path clearance.
    for(let i=0;i<110;i++){const x=1120+this.rng()*1200,y=790+this.rng()*1120;if(Math.abs(y-1392)<92||Math.abs(x-2304)<85||Math.abs(x-1512)<95)continue;this.addProp(i%5===0?'bamboo':'tree',x,y,{collider:{x:-10,y:-8,w:20,h:18}})}
    for(let i=0;i<18;i++)this.addProp('rock',1120+this.rng()*1150,820+this.rng()*1050,{variant:i%3,collider:{x:-8,y:-6,w:16,h:12}});
    // Bridge and river banks.
    this.addProp('bridge',1518,1395,{});
    // Secret southern altar and bamboo corridor.
    for(let i=0;i<18;i++){this.addProp('bamboo',1800+i*26,1830+(i%2)*34,{collider:{x:-7,y:-6,w:14,h:14}})}
    this.addProp('altar',2085,1930,{collider:{x:-17,y:-10,w:34,h:18}});
    this.interactables.push({id:'secretAltar',x:2085,y:1912,r:36,label:'Examinar altar oculto'});
    // Shrine approach.
    this.addProp('torii',2355,744,{collider:{x:-36,y:-8,w:72,h:12}});
    this.addProp('shrine',2700,620,{collider:{x:-56,y:-38,w:112,h:50}});
    this.addProp('shrine',2880,620,{small:true,collider:{x:-38,y:-27,w:76,h:36}});
    for(let i=0;i<12;i++)this.addProp('lantern',2420+(i%6)*88,760+Math.floor(i/6)*210,{collider:{x:-5,y:-5,w:10,h:8}});
    for(let i=0;i<20;i++)this.addProp('deadArmor',2400+this.rng()*520,440+this.rng()*500,{variant:i%3});
    this.addProp('checkpoint',2575,780,{collider:{x:-12,y:-7,w:24,h:14}});
    this.interactables.push({id:'checkpoint',x:2575,y:760,r:38,label:'Purificar santuário'});
    this.interactables.push({id:'inscription',x:2740,y:695,r:30,label:'Ler inscrição'});
    // Boss arena.
    this.addProp('torii',2990,680,{collider:{x:-36,y:-8,w:72,h:12}});
    for(let i=0;i<8;i++)this.addProp('lantern',3050+(i%4)*92,420+Math.floor(i/4)*350,{});
    this.addProp('banner',3100,520,{});this.addProp('banner',3370,520,{});this.addProp('banner',3120,785,{});this.addProp('banner',3350,785,{});
    for(let i=0;i<7;i++)this.addProp('oldTree',3020+i*64,320+(i%2)*500,{collider:{x:-14,y:-10,w:28,h:20}});
    this.addProp('bossShrine',3270,350,{collider:{x:-62,y:-35,w:124,h:45}});
    // World borders.
    this.colliders.push({x:-20,y:0,w:20,h:this.h},{x:this.w,y:0,w:20,h:this.h},{x:0,y:-20,w:this.w,h:20},{x:0,y:this.h,w:this.w,h:20});
  }
  groundType(tx,ty){return this.tiles[this.idx(tx,ty)]}
  isWaterAt(x,y){const tx=(x/this.T)|0,ty=(y/this.T)|0;return this.groundType(tx,ty)===2}
  bodyRect(e,x=e.x,y=e.y){return{x:x-e.w/2,y:y-e.h/2,w:e.w,h:e.h}}
  collides(e,x,y){const r=this.bodyRect(e,x,y);if(this.isWaterAt(x,y+e.h*.25))return true;for(const c of this.colliders)if(AMAHARA.U.rects(r,c))return true;if(this.game.arenaBarrier&&AMAHARA.U.rects(r,this.game.arenaBarrier))return true;return false}
  move(e,dx,dy){let nx=e.x+dx,ny=e.y;if(!this.collides(e,nx,ny))e.x=nx;nx=e.x;ny=e.y+dy;if(!this.collides(e,nx,ny))e.y=ny;e.x=AMAHARA.U.clamp(e.x,8,this.w-8);e.y=AMAHARA.U.clamp(e.y,8,this.h-8)}
  nearestInteractable(p){let best=null,bd=999;for(const it of this.interactables){const d=Math.hypot(p.x-it.x,p.y-it.y);if(d<it.r&&d<bd){best=it;bd=d}}const y=this.game.npc;if(y){const d=Math.hypot(p.x-y.x,p.y-y.y);if(d<42&&d<bd)best={id:'npcYuna',label:'Falar com Yuna'};}return best}
  drawGround(ctx,cam){const T=this.T,sx=Math.max(0,Math.floor(cam.x/T)-1),sy=Math.max(0,Math.floor(cam.y/T)-1),ex=Math.min(this.cols,Math.ceil((cam.x+480)/T)+1),ey=Math.min(this.rows,Math.ceil((cam.y+270)/T)+1);for(let y=sy;y<ey;y++)for(let x=sx;x<ex;x++){const t=this.groundType(x,y),px=x*T,py=y*T;ctx.fillStyle=t===0?'#536a3d':t===1?'#8a6a49':t===2?'#385d69':t===3?'#6a685d':'#3f3345';ctx.fillRect(px,py,T,T);const h=((x*17+y*31)%11);if(t===0){ctx.fillStyle=h<5?'#5f7845':'#485f37';ctx.fillRect(px+(h*3)%20,py+(h*7)%20,2,3)}else if(t===1){ctx.fillStyle='#74563d';ctx.fillRect(px+(h*5)%20,py+(h*2)%20,3,2)}else if(t===2){ctx.fillStyle=((x+y+(performance.now()/350|0))%3===0)?'#5d8790':'#476f79';ctx.fillRect(px+2,py+8,T-4,2)}else if(t===4){ctx.fillStyle='#68415b';ctx.fillRect(px+(h*3)%18,py+(h*4)%18,3,3)}}}
  drawProp(ctx,p){const x=Math.round(p.x),y=Math.round(p.y);ctx.save();ctx.translate(x,y);
    if(p.type==='tree'||p.type==='oldTree'){ctx.fillStyle=p.type==='oldTree'?'#3b2b25':'#4d3826';ctx.fillRect(-4,-28,8,28);ctx.fillStyle=p.type==='oldTree'?'#354534':'#2f5a34';ctx.fillRect(-18,-46,36,24);ctx.fillStyle=p.type==='oldTree'?'#42523b':'#3e7040';ctx.fillRect(-13,-53,26,18);ctx.fillStyle='#6f8a50';ctx.fillRect(-8,-49,7,4)}
    if(p.type==='bamboo'){ctx.fillStyle='#506c39';ctx.fillRect(-7,-38,3,38);ctx.fillRect(3,-44,3,44);ctx.fillStyle='#75914a';ctx.fillRect(-11,-28,8,3);ctx.fillRect(4,-18,9,3)}
    if(p.type==='house'||p.type==='shrine'||p.type==='bossShrine'){const small=p.small;const w=p.type==='bossShrine'?124:small?76:p.type==='shrine'?112:72;const h=p.type==='bossShrine'?68:small?48:p.type==='shrine'?64:58;ctx.fillStyle=p.type==='house'?'#b9a77a':'#9a8e68';ctx.fillRect(-w/2,-h,w,h-16);ctx.fillStyle=p.type==='house'?'#443a33':'#582e2e';ctx.fillRect(-w/2-6,-h-8,w+12,14);ctx.fillStyle='#302a26';ctx.fillRect(-8,-28,16,28);ctx.fillStyle='#d1c39c';ctx.fillRect(-w/2+8,-h+10,10,12);ctx.fillRect(w/2-18,-h+10,10,12)}
    if(p.type==='torii'){ctx.fillStyle='#9c3d32';ctx.fillRect(-30,-54,7,54);ctx.fillRect(23,-54,7,54);ctx.fillRect(-38,-58,76,7);ctx.fillRect(-32,-47,64,5);ctx.fillStyle='#42221f';ctx.fillRect(-40,-60,80,3)}
    if(p.type==='fence'){ctx.fillStyle='#6d5438';ctx.fillRect(-20,-8,40,4);ctx.fillRect(-16,-14,4,14);ctx.fillRect(12,-14,4,14)}
    if(p.type==='lantern'){ctx.fillStyle='#50483d';ctx.fillRect(-2,-18,4,18);ctx.fillStyle='#d29a45';ctx.fillRect(-6,-26,12,10);ctx.fillStyle='#f0d97a';ctx.fillRect(-4,-24,8,6)}
    if(p.type==='rock'){ctx.fillStyle=['#697068','#5b625c','#77776d'][p.variant||0];ctx.fillRect(-9,-8,18,8);ctx.fillRect(-6,-12,12,5)}
    if(p.type==='crop'){ctx.fillStyle='#6b8b43';for(let i=-8;i<=8;i+=4){ctx.fillRect(i,-13,2,13);ctx.fillRect(i-2,-10,6,2)}}
    if(p.type==='well'){ctx.fillStyle='#66665c';ctx.fillRect(-14,-12,28,12);ctx.fillStyle='#282f30';ctx.fillRect(-10,-10,20,7);ctx.fillStyle='#7f7769';ctx.fillRect(-16,-15,32,4)}
    if(p.type==='bridge'){ctx.fillStyle='#7a5639';ctx.fillRect(-50,-38,100,76);ctx.fillStyle='#a2774b';for(let x=-48;x<50;x+=8)ctx.fillRect(x,-35,6,70);ctx.fillStyle='#4e362a';ctx.fillRect(-50,-39,100,4);ctx.fillRect(-50,35,100,4)}
    if(p.type==='altar'||p.type==='checkpoint'){ctx.fillStyle=p.type==='altar'?'#4b4540':'#6b6152';ctx.fillRect(-17,-9,34,9);ctx.fillRect(-12,-16,24,7);ctx.fillStyle=p.type==='altar'?'#c55c4d':'#65b6a0';ctx.fillRect(-3,-24,6,8)}
    if(p.type==='banner'){ctx.fillStyle='#514537';ctx.fillRect(-2,-42,4,42);ctx.fillStyle='#6f2f52';ctx.fillRect(2,-39,18,22);ctx.fillStyle='#a85176';ctx.fillRect(5,-35,3,13)}
    if(p.type==='deadArmor'){ctx.fillStyle='#4b4747';ctx.fillRect(-8,-4,16,4);ctx.fillStyle='#59444b';ctx.fillRect(-5,-12,10,8);ctx.fillStyle='#7b604d';ctx.fillRect(5,-13,2,10)}
    ctx.restore()}
  visibleProps(cam){return this.props.filter(p=>p.x>cam.x-100&&p.x<cam.x+580&&p.y>cam.y-100&&p.y<cam.y+370)}
};
