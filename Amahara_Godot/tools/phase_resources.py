from pathlib import Path
root=Path(__file__).resolve().parents[1]/'data'
def resource(name, cls, script, **fields):
    text=f'[gd_resource type="Resource" script_class="{cls}" load_steps=2 format=3]\n\n[ext_resource type="Script" path="res://scripts/{script}.gd" id="1"]\n\n[resource]\nscript = ExtResource("1")\n'
    for k,v in fields.items():
        text+=f'{k} = '+('"'+v+'"' if isinstance(v,str) else str(float(v)))+'\n'
    (root/(name+'.tres')).write_text(text,encoding='utf-8')
for id,title,hp,speed,damage,posture,windup,recovery,dist in [
 ('swordsman','Espadachim sem nome',48,42,10,32,.58,.85,34),
 ('runner','Batedor da encosta',38,68,9,25,.65,.9,80),
 ('heavy','Guarda de ferro',90,30,18,66,.9,1.15,44),
 ('archer','Arqueiro do chamado',38,40,10,24,.85,1.3,155),
 ('seal','Portador de selo',62,32,13,44,1.05,1.5,140)]:
 resource('enemy_'+id,'EnemyData','enemy_data',id=id,title=title,hp=hp,speed=speed,damage=damage,posture=posture,windup=windup,recovery=recovery,preferred_distance=dist,detection=225)
resource('celestial','MagicData','magic_data',id='celestial',title='Corte Celeste',cost=25,damage=24,cooldown=.9,radius=18,speed=240,stagger=20)
resource('rupture','MagicData','magic_data',id='rupture',title='Selo de Ruptura',cost=35,damage=18,cooldown=5,radius=62,speed=0,stagger=38)
resource('altar','UpgradeData','upgrade_data',id='altar',title='Voto do Estandarte',energy_bonus=25)
resource('memorial','UpgradeData','upgrade_data',id='memorial',title='Faixa dos ausentes',recovery_bonus=35)
for id,title,w,a,r,d,rad,s,p in [('combo','Três juramentos',.65,.65,1.1,13,48,0,1),('charge','Marcha do general',.9,.55,1.2,18,38,230,3),('wide','Círculo de ferro',1.0,.22,1.35,20,84,0,4),('spirit','Sepultura desperta',.8,.3,1.15,15,42,0,6),('radial','Estandarte partido',1.1,.3,1.4,12,48,0,6),('summon','Chamado dos juramentados',1.2,.3,1.5,0,50,0,5)]:
 resource('boss_'+id,'BossAttackData','boss_attack_data',id=id,title=title,windup=w,active=a,recovery=r,damage=d,radius=rad,speed=s,pose=p)
print('15 phase Resources authored')
