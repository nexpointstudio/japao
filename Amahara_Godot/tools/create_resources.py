"""Author gameplay Resources from explicit balance definitions; no original files changed."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
attacks = [
    ('light_1', 'Corte Horizontal', 11, .07, .12, .15, 24, (34, 28), 45, 10, 35, 'slash', 'light_2', ''),
    ('light_2', 'Corte Reverso', 12, .08, .12, .17, 26, (37, 30), 50, 12, 40, 'reverse', 'light_3', 'heavy_3'),
    ('light_3', 'Corte Descendente', 19, .13, .14, .27, 28, (40, 30), 110, 22, 45, 'finish', '', ''),
    ('heavy_1', 'Passo de Ferro', 15, .17, .15, .25, 27, (38, 30), 65, 24, 80, 'slash', '', 'heavy_2'),
    ('heavy_2', 'Ombro da Guerra', 18, .18, .16, .25, 28, (40, 32), 85, 30, 95, 'reverse', '', 'heavy_3'),
    ('heavy_3', 'Lamina do Estandarte', 29, .25, .18, .38, 32, (46, 36), 150, 42, 100, 'finish', '', ''),
    ('enemy_slash', 'Corte do morto', 10, .58, .16, .85, 26, (36, 28), 65, 10, 20, 'slash', '', ''),
]
for row in attacks:
    id, title, damage, startup, active, recovery, reach, size, knockback, stagger, step, anim, light, heavy = row
    text = '[gd_resource type="Resource" script_class="AttackData" load_steps=2 format=3]\n\n[ext_resource type="Script" path="res://scripts/attack_data.gd" id="1"]\n\n[resource]\nscript = ExtResource("1")\n'
    fields = dict(id=f'"{id}"', title=f'"{title}"', damage=float(damage), startup=startup, active=active, recovery=recovery, reach=float(reach), size=f'Vector2({size[0]}, {size[1]})', knockback=float(knockback), stagger=float(stagger), step_speed=float(step), animation=f'"{anim}"', next_light=f'"{light}"', next_heavy=f'"{heavy}"', cancel_time=startup+active+.05, hitstop=.065 if id.startswith('heavy') else .025)
    text += ''.join(f'{key} = {value}\n' for key, value in fields.items())
    (root / 'data' / f'{id}.tres').write_text(text, encoding='utf-8')
print('Created 7 editable attack Resources')
