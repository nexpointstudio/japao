window.AMAHARA = window.AMAHARA || {};
AMAHARA.BALANCE = {
  internal: { width: 480, height: 270, tile: 24 },
  player: { hp: 100, energy: 100, speed: 82, dashSpeed: 270, dashDuration: .18, dashCooldown: .58, hitIFrames: .62, energyRegen: 2.2, energyOnHit: 6 },
  combos: {
    light: [
      {name:'Corte Horizontal',startup:.07,active:.08,recovery:.12,damage:11,w:28,h:18,reach:20,knockback:42,step:2,hitstop:.025},
      {name:'Corte Reverso',startup:.06,active:.09,recovery:.13,damage:12,w:30,h:18,reach:21,knockback:48,step:3,hitstop:.03},
      {name:'Corte Descendente',startup:.10,active:.11,recovery:.23,damage:19,w:34,h:22,reach:23,knockback:95,step:1,hitstop:.055}
    ],
    heavy: [
      {name:'Passo de Ferro',startup:.12,active:.11,recovery:.18,damage:15,w:31,h:20,reach:22,knockback:60,step:6,hitstop:.04},
      {name:'Ombro da Guerra',startup:.14,active:.12,recovery:.18,damage:18,w:34,h:22,reach:24,knockback:80,step:8,hitstop:.05},
      {name:'Lâmina do Estandarte',startup:.20,active:.14,recovery:.34,damage:29,w:40,h:25,reach:27,knockback:145,step:10,hitstop:.075}
    ]
  },
  magic: {
    slash: { name:'Corte Celeste', cost:25, damage:24, speed:220, life:1.45, cooldown:.9 },
    seal: { name:'Selo de Ruptura', cost:35, damage:18, radius:52, stun:.8, cooldown:5.0 }
  },
  enemies: {
    swordsman:{hp:38,speed:34,damage:10,range:24,detection:175,disengage:320,windup:.34,recovery:.55,color:'#66715c'},
    runner:{hp:25,speed:56,damage:8,range:21,detection:195,disengage:340,windup:.22,recovery:.42,color:'#7c6257'},
    heavy:{hp:86,speed:23,damage:19,range:29,detection:160,disengage:300,windup:.62,recovery:.88,color:'#4e5662'},
    archer:{hp:31,speed:29,damage:9,range:150,detection:220,disengage:360,windup:.48,recovery:1.05,color:'#64536e'}
  },
  boss:{hp:480,speed:30,damage:18,phase2:0.5}
};
