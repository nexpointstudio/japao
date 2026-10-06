window.AMAHARA = window.AMAHARA || {};
AMAHARA.Input = class {
  constructor(){this.keys=new Set();this.pressed=new Set();this.padPrev=[];this.padPressed=new Set();this.axis={x:0,y:0};this.anyGamepad=false;this.bind()}
  bind(){addEventListener('keydown',e=>{if(!this.keys.has(e.code))this.pressed.add(e.code);this.keys.add(e.code);if(['ArrowUp','ArrowDown','ArrowLeft','ArrowRight','Space'].includes(e.code))e.preventDefault()},{passive:false});addEventListener('keyup',e=>this.keys.delete(e.code));addEventListener('blur',()=>{this.keys.clear();this.pressed.clear()})}
  update(){this.padPressed.clear();this.axis.x=0;this.axis.y=0;const pads=navigator.getGamepads?navigator.getGamepads():[];const p=[...pads].find(Boolean);this.anyGamepad=!!p;if(!p)return;let x=Math.abs(p.axes[0]||0)>.18?(p.axes[0]||0):0,y=Math.abs(p.axes[1]||0)>.18?(p.axes[1]||0):0;const b=p.buttons.map(v=>v.pressed);if(b[14])x=-1;if(b[15])x=1;if(b[12])y=-1;if(b[13])y=1;this.axis={x,y};for(let i=0;i<b.length;i++)if(b[i]&&!this.padPrev[i])this.padPressed.add(i);this.padPrev=b}
  move(){let x=0,y=0;if(this.keys.has('KeyA')||this.keys.has('ArrowLeft'))x--;if(this.keys.has('KeyD')||this.keys.has('ArrowRight'))x++;if(this.keys.has('KeyW')||this.keys.has('ArrowUp'))y--;if(this.keys.has('KeyS')||this.keys.has('ArrowDown'))y++;if(Math.abs(this.axis.x)>.05||Math.abs(this.axis.y)>.05){x=this.axis.x;y=this.axis.y}const l=Math.hypot(x,y);return l>1?{x:x/l,y:y/l}:{x,y}}
  take(action){const key={light:'KeyJ',heavy:'KeyK',dash:'Space',magic1:'KeyQ',magic2:'KeyE',interact:'KeyF',pause:'Escape'}[action];const pad={light:2,heavy:3,dash:1,magic1:4,magic2:5,interact:0,pause:9}[action];const yes=this.pressed.has(key)||this.padPressed.has(pad);if(yes)this.pressed.delete(key);return yes}
  held(code){return this.keys.has(code)}
  endFrame(){this.pressed.clear()}
};
