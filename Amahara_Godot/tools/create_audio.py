"""Original synthesized sounds, deterministic source retained. No external recordings."""
from pathlib import Path
import wave, math, random, array

root = Path(__file__).resolve().parents[1] / 'assets' / 'audio'
root.mkdir(exist_ok=True)
rate = 22050
rng = random.Random(9042026)
def write(name, samples):
    data = array.array('h',(int(max(-1,min(1,s))*32700) for s in samples))
    with wave.open(str(root / (name+'.wav')), 'wb') as file:
        file.setnchannels(1); file.setsampwidth(2); file.setframerate(rate); file.writeframes(data.tobytes())
for name, dur, freq, noise in [('slash',.16,520,.45),('heavy',.25,170,.4),('hit',.13,95,.5),('hurt',.23,90,.3),('dash',.2,650,.22),('magic1',.4,780,.05),('magic2',.6,145,.12),('perfect',.55,880,0),('warn',.28,140,.08),('ui',.08,420,0),('shrine',1.2,660,0)]:
    values=[]
    for i in range(int(rate*dur)):
        t=i/rate; k=t/dur
        env=(1-k)**2*min(1,t/.012)
        f=freq*(1-.4*k)
        values.append((math.sin(math.tau*f*t)*(1-noise)+rng.uniform(-1,1)*noise)*env*.3)
    write(name,values)
notes=[164.81,196,220,246.94,220,196,164.81,146.83]
values=[]
for i in range(rate*24):
    t=i/rate
    chord=int(t/3)%8
    phase=t%3
    env=math.sin(math.pi*phase/3)**2
    note=notes[chord]
    pulse=math.exp(-5*(t%1.5))
    value=(math.sin(math.tau*note*t)*.06+math.sin(math.tau*note*.5*t)*.07)*env
    value+=math.sin(math.tau*note*2*t)*pulse*.028
    value+=rng.uniform(-1,1)*.004
    value*=min(1,t/1.5,(24-t)/1.5)
    values.append(value)
write('village',values)
print('12 original WAV assets generated')
values=[]
for i in range(rate*24):
    t=i/rate
    note=[110,130.81,146.83,123.47][int(t/3)%4]
    beat=t%.5
    drum=math.sin(math.tau*(65*beat-45*beat*beat))*math.exp(-beat*19)*.19
    bow=(math.sin(math.tau*note*t)+.3*math.sin(math.tau*note*1.5*t))*.045
    bell=math.sin(math.tau*440*t)*math.exp(-(t%3)*5)*.055
    values.append((drum+bow+bell)*min(1,t/.15,(24-t)/.2))
write('boss',values)
print('Original boss score generated')
