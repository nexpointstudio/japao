const http=require('http');
const cp=require('child_process');
const fs=require('fs');
const path=require('path');
const root=path.resolve(__dirname,'..');
const wait=ms=>new Promise(r=>setTimeout(r,ms));
async function json(url){return new Promise((resolve,reject)=>http.get(url,r=>{let d='';r.on('data',c=>d+=c);r.on('end',()=>{try{resolve(JSON.parse(d))}catch(e){reject(e)}})}).on('error',reject))}
const scripts=['src/data/balance.js','src/utils.js','src/audio.js','src/input.js','src/combat.js','src/world.js','src/entities/player.js','src/entities/enemies.js','src/entities/boss.js','src/game.js'];
async function main(){let chrome=null;try{
 chrome=cp.spawn('chromium',['--headless=new','--disable-gpu','--no-sandbox','--remote-debugging-port=9333','--user-data-dir=/tmp/amahara-chrome-test','about:blank'],{stdio:'ignore'});await wait(1000);
 const tabs=await json('http://127.0.0.1:9333/json');const page=tabs.find(t=>t.type==='page');if(!page)throw Error('No page target');
 const ws=new WebSocket(page.webSocketDebuggerUrl);let seq=0,pending=new Map();ws.onmessage=e=>{const m=JSON.parse(e.data);if(m.id&&pending.has(m.id)){pending.get(m.id)(m);pending.delete(m.id)}else if(m.method==='Runtime.exceptionThrown'){console.error('PAGEEX',JSON.stringify(m.params.exceptionDetails))}};await new Promise(r=>ws.onopen=r);
 const call=(method,params={})=>new Promise(res=>{const id=++seq;pending.set(id,res);ws.send(JSON.stringify({id,method,params}))});
 const evaljs=async exp=>{const r=await call('Runtime.evaluate',{expression:exp,returnByValue:true,awaitPromise:true});if(r.result.exceptionDetails)throw Error(JSON.stringify(r.result.exceptionDetails));return r.result.result.value};
 await call('Runtime.enable');
 const body=`<main id="frame"><canvas id="game" width="480" height="270"></canvas><section id="menu"><button id="playBtn">JOGAR</button><button id="controlsBtn">CONTROLES</button></section><section id="controls" class="hidden"><button data-close="controls">VOLTAR</button></section><section id="pause" class="hidden"><button id="resumeBtn">CONTINUAR</button><button id="pauseControlsBtn">CONTROLES</button><button id="restartBtn">REINICIAR</button><button id="menuBtn">MENU</button></section><section id="dialogue" class="hidden"><div id="speaker"></div><div id="dialogueText"></div></section><section id="victory" class="hidden"><button id="victoryRestartBtn">NOVAMENTE</button><button id="victoryMenuBtn">MENU</button></section><div id="toast" class="hidden"></div></main>`;
 await evaljs(`document.body.innerHTML=${JSON.stringify(body)};`);
 for(const s of scripts){const code=fs.readFileSync(path.join(root,s),'utf8');await evaljs(`eval(${JSON.stringify(code)})`)}
 await evaljs(`window.__GAME__=new AMAHARA.Game(document.getElementById('game')); window.__GAME__.last=performance.now(); requestAnimationFrame(t=>window.__GAME__.frame(t));`);
 const out=[];const test=async(name,fn)=>{try{const v=await fn();out.push([name,v?'PASS':'FAIL']);}catch(e){out.push([name,'FAIL',e.message])}};
 await test('boot',async()=>await evaljs('!!window.__GAME_TEST__'));
 await evaljs('window.__GAME_TEST__.start()');await wait(160);for(let i=0;i<4;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 await test('village wave',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===1&&s.enemies.length===5});
 await evaljs('window.__GAME_TEST__.killEnemies()');await wait(250);await test('village clear',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===2});
 await evaljs('window.__GAME_TEST__.teleport(700,1660); window.__GAME_TEST__.interact()');await wait(100);for(let i=0;i<3;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(80)}
 await test('forest unlocked',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===3});
 await evaljs('window.__GAME_TEST__.teleport(2085,1912); window.__GAME_TEST__.interact()');await wait(100);await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(80);await test('secret upgrade',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.player.maxEnergy===125});
 await evaljs('window.__GAME_TEST__.teleport(2575,760); window.__GAME_TEST__.interact()');await wait(100);for(let i=0;i<2;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(80)}
 await test('checkpoint',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.story===4});
 await evaljs('window.__GAME_TEST__.teleport(3050,670)');await wait(250);for(let i=0;i<4;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 await test('boss spawn',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return !!s.boss&&s.boss.phase===1});
 await wait(1900); await evaljs('window.__GAME_TEST__.damageBoss(260)');await wait(250);await test('boss phase2',async()=>{const s=await evaljs('window.__GAME_TEST__.state()');return s.boss.phase===2});
 await wait(1900); await evaljs('window.__GAME_TEST__.damageBoss(999)');await wait(1200);for(let i=0;i<4;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 await test('victory flow',async()=>await evaljs("window.__GAME_TEST__.state().victory===true&&!document.getElementById('victory').classList.contains('hidden')"));
 await evaljs('window.__GAME__.returnMenu(); window.__GAME_TEST__.start()');await wait(120);for(let i=0;i<6;i++){await evaljs("window.__GAME_TEST__.press('KeyF')");await wait(90)}
 const p0=await evaljs('window.__GAME_TEST__.state().player.x');await evaljs("dispatchEvent(new KeyboardEvent('keydown',{code:'KeyD'}))");await wait(250);await evaljs("dispatchEvent(new KeyboardEvent('keyup',{code:'KeyD'}))");await wait(80);const p1=await evaljs('window.__GAME_TEST__.state().player.x');out.push(['movement',p1>p0?'PASS':'FAIL']);
 await evaljs("window.__GAME_TEST__.press('KeyJ')");await wait(90);const st=await evaljs('window.__GAME_TEST__.state().player.state');out.push(['light attack state',st==='attack'?'PASS':'FAIL']);
 await wait(500);await evaljs("window.__GAME_TEST__.press('Space')");await wait(60);const ds=await evaljs('window.__GAME_TEST__.state().player.state');out.push(['dash state',ds==='dash'?'PASS':'FAIL']);
 console.log(JSON.stringify(out));ws.close();
}finally{if(chrome)chrome.kill('SIGKILL')}}
main().catch(e=>{console.error(e);process.exitCode=1});
