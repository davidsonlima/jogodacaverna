graphics 0

poke 710,0
poke 712,$C4

position 10,2
? "JOGO DA CAVERNA"

position 2,5
? "OBJETIVO:"

position 2,7
? "COLETE AS MOEDAS *"

position 2,8
? "DESTRUA O INIMIGO X"

position 2,9
? "SOBREVIVA E FACA"

position 2,10
? "5000 PONTOS"

position 2,13
? "CONTROLES"

position 2,15
? "SETAS = MOVER"

position 2,16
? "SHIFT = ATIRAR"

position 2,19
? "DESENVOLVIDO POR"

position 2,20
? "DAVIDSON DE OLIVEIRA"

position 2,21
? "LIMA (2026)"

music=0
hiscore=0

position 22,23
? "RECORDE:";hiscore

repeat
until strig(0)=0

mset dpeek(88),960,0

poke 710,0
poke 712,$C4

paused=0

repeat

  score=0
  vidas=3

  px=2
  py=20

  ex=35
  ey=10

  cx=20
  cy=5

  shot=0
  shotX=0
  shotY=0

  dir=1
  shotDX=1
  shotDY=0
  enemyDelay=0

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

    s=stick(0)

    if s=11
      if px>1
        px=px-1
        shotDX=-1
        shotDY=0
      endif
    endif

    if s=7
      if px<38
        px=px+1
        shotDX=1
        shotDY=0
      endif
    endif

    if s=14
      if py>1
        py=py-1
        shotDX=0
        shotDY=-1
      endif
    endif

    if s=13
      if py<21
        py=py+1
        shotDX=0
        shotDY=1
      endif
    endif

    position ox,oy
    ? " "

    position px,py
    ? "@"

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

            ex=2+rand(35)
            ey=1+rand(21)

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

        cx=1+rand(37)
        cy=1+rand(21)

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

        px=2
        py=20

        position px,py
        ? "@"

      endif

    endif
    
    if score>hiscore
      hiscore=score
    endif

    position 0,0
    ? "VIDAS:";vidas;" PONTOS:";score;" RECORDE:";hiscore;"   "

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

  until vidas=0

  sound 1,0,0,0

  position 12,12
  ? "GAME OVER"

  position 10,14
  ? "RECORDE:";hiscore

  sound 0,30,8,12
  pause 15

  sound 0,60,8,12
  pause 15

  sound 0,120,8,12
  pause 15

  sound

  position 8,15
  ? "SHIFT=NOVO JOGO"

  repeat
  until strig(0)=0

  mset dpeek(88),960,0

until 0