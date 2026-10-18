graphics 0

poke 710,0
poke 712,$C4

position 10,2
? "JOGO DA CAVERNA v0.2"

position 7,3
? "Atualizado em 16-Out-2026"

position 2,5
? "Objetivos:"

position 2,7
? "- Colete as moedas *"

position 2,8
? "- Destrua o inimigo X"

position 2,9
? "- Sobreviva e faca 5000 pontos"

position 2,12
? "Controles:"

position 2,14
? "Setas = mover"

position 2,15
? "Shift = atirar"

position 2,16
? "P = pause"

position 2,18
? " >Desenvolvido por"

position 2,19
? " Davidson de Oliveira Lima (2026)"

position 13,20
? " . davidsoneq@gmail.com"

position 13,21
? " . @davi.mpb"

position 13,22
? " . github.com/davidsonlima"

hiscore=0
music=0

repeat
until strig(0)=0

mset dpeek(88),960,0

poke 710,0
poke 712,$C4

paused=0

repeat

  score=0
  vidas=3
  ticks=0

  px=3
  py=20

  ex=34
  ey=10

  cx=20
  cy=10

  shot=0

  shotDX=1
  shotDY=0
  gun$=">"
  
  shotX=0
  shotY=0

  dir=1
  shotDX=1
  shotDY=0
  enemyDelay=0
  gun$=">"

  mset dpeek(88),960,0

  for i=1 to 23

    position 0,i
    ? "#"

    position 39,i
    ? "#"

  next i

  for i=2 to 21

    position 0,i
    ? "#"

    position 39,i
    ? "#"

  next i

  position px,py
  ? "@"

  position ex,ey
  ? "X"

  position cx,cy
  ? "*"

  repeat

    poke 77,0
    
    if peek(764)=10

      poke 764,255

      sound 1,0,0,0

      sound 0,220,10,12
      pause 4
      sound 0,180,10,12
      pause 4
      sound

      position 15,12
      ? " PAUSE "

      repeat
        
        pause 1

      until peek(764)=10

      poke 764,255

      sound 0,120,10,12
      pause 4
      sound 0,200,10,12
      pause 4
      sound

      position 15,12
      ? "       "

    endif
    
    music=music+1

    if music=1
      sound 1,180,8,6
    endif

    if music=10
      sound 1,160,8,6
    endif

    if music=20
      sound 1,140,8,6
    endif

    if music=30
      sound 1,120,8,6
    endif

    if music=40
      sound 1,140,8,6
    endif

    if music=50
      sound 1,160,8,6
    endif

    if music=60
      sound 1,180,8,6
    endif

    if music=70
      sound 1,220,8,6
    endif

    if music=80
      sound 1,180,8,6
    endif

    if music>90
      music=0
    endif

    ox=px
    oy=py
    
    gunx=px+shotDX
    guny=py+shotDY

    s=stick(0)

    if s=11
      if px>2
        px=px-1
        shotDX=-1
        shotDY=0
        gun$="<"
      endif
    endif

    if s=7
      if px<37
        px=px+1
        shotDX=1
        shotDY=0
        gun$=">"
      endif
    endif

    if s=14
      if py>2
        py=py-1
        shotDX=0
        shotDY=-1
        gun$="^"
      endif
    endif

    if s=13
      if py<20
        py=py+1
        shotDX=0
        shotDY=1
        gun$="v"
      endif
    endif

    position ox,oy
    ? " "

    position gunx,guny
    ? " "

    position px,py
    ? "@"
    
    gunx=px+shotDX
    guny=py+shotDY

    position gunx,guny

    if shotDX=1  then ? ">"
    if shotDX=-1 then ? "<"
    if shotDY=1  then ? "v"
    if shotDY=-1 then ? "^"

    if strig(0)=0

      if shot=0

        shot=1

        shotX=px
        shotY=py

        tdx=shotDX
        tdy=shotDY

        sound 0,100,10,12
        pause 12
        sound

      endif

    endif

    enemyDelay=enemyDelay+1

    enemySpeed=4

    if score>=100
      enemySpeed=3
    endif

    if score>=200
      enemySpeed=2
    endif

    if score>=300
      enemySpeed=1
    endif

    if enemyDelay>enemySpeed

      enemyDelay=0

      position ex,ey
      ? " "

      if rand(2)=0

        if px>ex
          ex=ex+1
        endif

        if px<ex
          ex=ex-1
        endif

      else

        if py>ey
          ey=ey+1
        endif

        if py<ey
          ey=ey-1
        endif

      endif

      position ex,ey
      ? "X"

    endif

    if shot=1

      position shotX,shotY
      ? " "

      shotX=shotX+tdx
      shotY=shotY+tdy

      if shotX>38
        shot=0
      endif

      if shotX<1
        shot=0
      endif

      if shotY>21
        shot=0
      endif

      if shotY<1
        shot=0
      endif

      if shot=1

        position shotX,shotY
        ? "-"

        if shotX=ex

          if shotY=ey

            score=score+25

            sound 0,220,8,12
            pause 10

            sound 0,180,8,12
            pause 10

            sound 0,120,8,12
            pause 10

            sound

            position shotX,shotY
            ? " "

            position ex,ey
            ? " "

            ex=3+rand(33)
            ey=2+rand(18)

            position ex,ey
            ? "X"

            shot=0

          endif

        endif

      endif

    endif

    if px=cx

      if py=cy

        score=score+10

        sound 0,80,10,12
        pause 10
        sound

        sound 0,40,10,12
        pause 10
        sound

        position cx,cy
        ? " "

        cx=3+rand(33)
        cy=2+rand(18)

        position cx,cy
        ? "*"

      endif

    endif

    if px=ex

      if py=ey

        vidas=vidas-1

        sound 0,20,10,12
        pause 30
        sound

        position px,py
        ? " "

        position gunx,guny
        ? " "

        px=3
        py=20

        shotDX=1
        shotDY=0
        gun$=">"

        gunx=px+1
        guny=py

        position px,py
        ? "@"

        position gunx,guny
        ? ">"

      endif

    endif
    
    if score>hiscore
      hiscore=score
    endif
            
    totalseg=ticks/10

    hor=totalseg/3600
    min=(totalseg mod 3600)/60
    seg=totalseg mod 60

    position 0,0
    ? "Vidas:";vidas;" Pontos:";score;" Recorde:";hiscore
            
    position 27,1

    if hor<10 then ? "0";
    ? hor;":";

    if min<10 then ? "0";
    ? min;":";

    if seg<10 then ? "0";
    ? seg;

    if score>=5000

      sound 1,0,0,0
      position 12,12
      ? "VOCE VENCEU!"

      sound 0,90,10,12
      pause 15

      sound 0,70,10,12
      pause 15

      sound 0,50,10,12
      pause 15

      sound 0,30,10,12
      pause 15

      sound

      pause 50

      end

    endif

    pause 1
    ticks=ticks+1

  until vidas=0

  sound 1,0,0,0

  position 12,12
  ? "GAME OVER"

  position 10,14
? "Recorde:";hiscore

  sound 0,30,8,12
  pause 15

  sound 0,60,8,12
  pause 15

  sound 0,120,8,12
  pause 15

  sound

  position 8,15
? "Shift = novo jogo"

  repeat
  until strig(0)=0

  mset dpeek(88),960,0

until 0
