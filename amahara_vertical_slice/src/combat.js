window.AMAHARA = window.AMAHARA || {};
AMAHARA.Combat = {
  attackRect(owner,a){const f=owner.facing;const cx=owner.x,cy=owner.y-4;let w=a.w,h=a.h,x=cx-w/2,y=cy-h/2;if(f==='right')x=cx+a.reach-w*.15;if(f==='left')x=cx-a.reach-w*.85;if(f==='down')y=cy+a.reach-h*.15;if(f==='up')y=cy-a.reach-h*.85;return{x,y,w,h}},
  pushVector(owner,target,mag){const n=AMAHARA.U.norm(target.x-owner.x,target.y-owner.y);return{x:n.x*mag,y:n.y*mag}},
  damage(game,target,amount,source,knock=0,id=''){if(!target||target.dead)return false;if(target.invuln&&target.invuln>0)return false;const ok=target.takeDamage(amount,source,knock,id);if(ok){game.hitstop=Math.max(game.hitstop,source?.currentAttack?.hitstop||.025);game.shake=Math.max(game.shake,amount>20?5:3);game.spawnHit(target.x,target.y-8,amount>18?'#f4d07c':'#ded4bb');game.audio.sfx('hit')}return ok}
};
