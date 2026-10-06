addEventListener('DOMContentLoaded',()=>{const game=new AMAHARA.Game(document.getElementById('game'));window.__GAME__=game;requestAnimationFrame(t=>{game.last=t;game.frame(t)})});
