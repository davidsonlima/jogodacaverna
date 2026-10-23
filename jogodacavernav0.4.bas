' =====================================================
'  JOGO DA CAVERNA v0.4 - versao com 20 fases
'  Atari 800 - FastBasic
'  Davidson de Oliveira Lima (2026)
' =====================================================

' ---- tabelas por fase (1..20) ----
data nEnTab() byte = 1,1,2,2,1, 2,3,3,3,2, 3,4,4,4,2, 4,5,5,5,3
data spdTab() byte = 4,4,4,3,4, 3,3,3,2,3, 2,2,2,2,2, 1,1,1,1,1
' ---- chefoes (fases 5, 10, 15, 20) ----
data bHPTab() byte = 10,16,24,40
data bSpdTab() byte = 3,3,2,1
data bShTab() byte = 0,4,6,10
' ---- musica, arma, itens e chefao (codigos da fonte colorida) ----
' ---- efeitos sonoros: tom, distorcao, volume, quadros (0 = fim) ----
data sfx() byte = 200,8,12,10,240,8,12,10,200,8,12,10,240,8,12,10,200,8,12,10,240,8,12,10,
data byte = 0,0,0,20,0,0,0,0,120,10,12,10,90,10,12,10,60,10,12,10,45,10,12,30,
data byte = 0,0,0,20,0,0,0,0,90,10,12,15,70,10,12,15,50,10,12,15,30,10,12,15,
data byte = 0,0,0,0,30,8,12,15,60,8,12,15,120,8,12,15,0,0,0,0,220,10,12,4,
data byte = 180,10,12,4,0,0,0,0,120,10,12,4,200,10,12,4,0,0,0,0,100,10,12,3,
data byte = 0,0,0,0,220,8,12,4,180,8,12,4,120,8,12,4,0,0,0,0,60,10,10,2,
data byte = 80,10,10,2,0,0,0,0,150,8,8,2,0,0,0,0,200,8,15,8,240,8,12,8,
data byte = 255,8,8,16,0,0,0,0,50,8,12,2,0,0,0,0,80,10,12,6,40,10,12,6,
data byte = 0,0,0,0,0,0,0,0,60,10,12,4,45,10,12,4,30,10,12,8,0,0,0,0,
data byte = 20,10,12,30,0,0,0,0
data stDir() byte = 9,9,9,9,9,9,9,0,9,9,9,1,9,3,2,9
data mus() byte = 180,160,140,120,140,160,180,220,180
data gunCh() byte = 65,66,67,68
data itemCh() byte = 78,79,80,81
data itemPick() byte = 1,1,1,2,3,3,4,4
data bossA() byte = 82,83,84,85,86,87,88,89
data bossB() byte = 90,91,92,93,94,95,96,123
data bossCor() byte = $56,$66,$86,$36

' ---- fonte colorida (ANTIC 4): sprites prontos + letras 3x5 expandidas no inicio ----
' sprites: caracteres 64..96 e 123 (8 bytes cada)
data spr() byte = 0,40,40,170,40,40,130,130,0,32,8,170,8,32,0,0,0,8,32,170,32,8,0,0,
data byte = 0,0,0,40,170,40,40,40,40,40,40,170,40,0,0,0,0,65,20,105,105,20,65,0,
data byte = 0,0,60,255,255,60,0,0,0,0,0,170,0,0,0,0,0,32,32,32,32,32,32,0,
data byte = 2,8,60,255,255,255,60,0,0,0,40,150,150,40,0,0,255,255,255,0,255,255,255,0,
data byte = 119,221,119,221,119,221,119,221,221,119,221,119,221,119,221,119,0,32,32,252,48,48,48,0,
data byte = 0,65,85,101,85,20,20,0,0,32,168,32,136,0,0,0,0,48,48,239,60,204,0,0,
data byte = 0,0,15,15,255,255,255,255,255,255,255,255,95,95,255,255,255,255,255,255,245,245,255,255,
data byte = 0,0,240,240,255,255,255,255,15,15,0,0,15,15,240,240,255,255,240,240,15,15,0,0,
data byte = 255,255,15,15,240,240,0,0,240,240,0,0,240,240,15,15,240,240,255,255,15,15,255,255,
data byte = 0,0,95,95,255,255,95,95,0,0,245,245,255,255,245,245,15,15,255,255,240,240,255,255,
data byte = 255,255,15,15,15,15,255,255,255,255,255,255,15,15,0,0,255,255,255,255,240,240,0,0,
data byte = 255,255,240,240,240,240,255,255
' letras e numeros 3x5: codigo, 15 bits (linhas de 3 pixels)
data txt() byte = 1,36,130,8,41,34,9,34,74,12,0,20,13,1,192,14,0,2,15,18,164,16,123,111,
data byte = 17,44,151,18,98,167,19,98,142,20,91,201,21,121,142,22,57,239,23,114,146,24,123,239,
data byte = 25,123,206,26,4,16,29,14,56,30,68,84,32,43,227,33,43,237,34,107,174,35,57,35,
data byte = 36,107,110,37,121,167,38,121,164,39,57,107,40,91,237,41,116,151,42,18,106,43,91,173,
data byte = 44,73,39,45,95,237,46,107,109,47,43,106,48,107,164,49,43,115,50,107,173,51,56,142,
data byte = 52,116,146,53,91,111,54,91,106,56,90,173,57,90,146,58,114,167

dim ex(4), ey(4), ddx(3), ddy(3)
dim fbuf(2047) byte, ra(23)
iy=0: passou=0: q=0: dentro=0: pausa=0: pts=0: quiet=0: b2ok=0
ddx(0)=1
ddx(1)=-1
ddy(2)=-1
ddy(3)=1

graphics 0
poke 752,1
scr=dpeek(88)
for i=0 to 23
  ra(i)=scr+i*40
next i

' ---- liga o modo de texto de 4 cores (ANTIC 4) com a fonte do jogo ----
fbase=(adr(fbuf)+1023) & $FC00
mset fbase,1024,0
move adr(spr),fbase+512,264
move adr(spr)+264,fbase+984,8
for i=0 to 45
  ia=fbase+txt(i*3)*8
  ix=txt(i*3+1)*256+txt(i*3+2)
  d=4096
  for j=0 to 4
    k=(ix/d)&7
    d=d/8
    c=0
    if (k&4)=4 then c=$C0
    if (k&2)=2 then c=c+$30
    if (k&1)=1 then c=c+$0C
    poke ia,c
    ia=ia+1
    if j=1 or j=3
      poke ia,c
      ia=ia+1
    endif
  next j
next i
move fbase+264,fbase+776,208
poke 756,(fbase/256) & 255
dl=dpeek(560)
poke dl+3,$44
for i=6 to 28
  poke dl+i,4
next i

poke 708,$46
poke 709,$0E
poke 710,$2A
poke 711,$C8
poke 712,0

position 10,1
? "JOGO DA CAVERNA v0.4"

position 7,2
? "Atualizado em 22-Out-2026"

position 2,4
? "Objetivos:"

position 2,5
? "- 20 fases: mate 20   em cada"
poke ra(5)+22,69

position 2,6
? "- Chefao nas fases 5,10,15,20"

position 2,7
? "- Pegue as moedas   e os itens:"
poke ra(7)+20,70

position 4,8
? "  arma        vida extra"
poke ra(8)+4,78
poke ra(8)+16,79

position 4,9
? "  congela     invencivel"
poke ra(9)+4,80
poke ra(9)+16,81

position 2,11
? "Controles:"

' ---- titulos em verde (caracteres inversos usam a cor 711) ----
iy1=1: ix1=10: ix2=29: exec Inverte
iy1=4: ix1=2: ix2=11: exec Inverte
iy1=11: ix1=2: ix2=11: exec Inverte

position 2,12
? "Botao = tiro   Espaco/botao 2 = bomba"

position 2,13
? "START ou P = pausa"

position 2,18
? " >Desenvolvido por"

position 2,19
? " Davidson de Oliveira Lima (2026)"
iy1=19: ix1=3: ix2=34: exec Inverte

position 13,20
? " . davidsoneq@gmail.com"

position 13,21
? " . @davi.mpb"

position 13,22
? " . github.com/davidsonlima"

hiH=0
hiL=0
music=0
prevSt=1
prevB2=0

repeat
until strig(0)=0

repeat

  scoreH=0
  scoreL=0
  vidas=3
  bombas=3
  arma=0
  fase=1
  segs=0
  frac=0
  venceu=0

  exec IniciaFase

  ' ======== laco principal ========
  repeat

    exec Entrada
    exec Musica
    exec Tempo
    exec MoveJogador
    exec Atira
    exec LancaBomba
    exec PassoTiro
    if arma>0 then exec PassoTiro
    exec PassoBomba
    exec MoveInimigos
    exec MoveChefe
    exec PassoBala
    if fase=20 then exec PassoBala
    exec Coleta
    exec Colisoes
    exec Desenha
    exec MostraHud

    if passou=1
      if fase=20
        venceu=1
      else
        fase=fase+1
        if bombas<9 then bombas=bombas+1
        exec IniciaFase
      endif
    endif

    pause 1

  until vidas=0 or venceu=1

  sound 1,0,0,0
  frzT=0
  exec Cores
  exec MostraHud

  if venceu=1

    position 14,12
    ? "VOCE VENCEU!";

    q=56
    exec Som

  else

    position 15,12
    ? "GAME OVER";

    q=76
    exec Som

  endif

  position 13,14
  ? "Recorde:";
  nh=hiH
  nl=hiL
  exec PrintNum

  position 11,15
  ? "Botao = novo jogo";

  repeat
  until strig(0)=1

  repeat
  until strig(0)=0

until 0

' =====================================================
'  Subrotinas
' =====================================================

proc IniciaFase
  kills=0
  shot=0
  bombDir=0
  bombReq=0
  bbDir=0
  item=0
  frzT=0
  invT=0
  passou=0
  eDelay=0
  bDelay=0
  music=0
  px=3
  py=20
  dir=0
  nEn=nEnTab(fase-1)
  boss=0
  if fase mod 5 = 0
    bIdx=fase/5-1
    boss=bHPTab(bIdx)
    bMax=boss
    bx=26
    by=4
  endif
  exec Cores
  for k=0 to 4
    exec Spawn
  next k
  cx=3+rand(33)
  cy=2+rand(18)

  sound
  mset scr,960,0
  for i=1 to 23
    poke ra(i),75
    poke ra(i)+39,75
  next i

  position 16,10
  ? "FASE ";fase;
  if boss>0
    if fase=20
      position 13,12
      ? "CHEFAO FINAL!";
      iy1=12: ix1=13: ix2=25: exec Inverte
    else
      position 16,12
      ? "CHEFAO!";
      iy1=12: ix1=16: ix2=22: exec Inverte
    endif
    q=0
  else
    q=32
  endif
  exec Som
  position 13,10
  ? "             ";
  position 13,12
  ? "             ";

  hud=1
  exec MostraHud
  exec Desenha
  lastT=TIME
endproc

' ---- inimigo k nasce longe do jogador ----
proc Spawn
  repeat
    ex(k)=3+rand(33)
    ey(k)=2+rand(18)
  until abs(ex(k)-px)>5 or abs(ey(k)-py)>4
endproc

' ---- soma pts ao placar (placar = scoreH*1000 + scoreL) ----
proc Pontua
  scoreL=scoreL+pts
  while scoreL>=1000
    scoreL=scoreL-1000
    scoreH=scoreH+1
  wend
  if scoreH>hiH or (scoreH=hiH and scoreL>hiL)
    hiH=scoreH
    hiL=scoreL
  endif
endproc

proc PrintNum
  if nh>0
    ? nh;
    if nl<100 then ? "0";
    if nl<10 then ? "0";
  endif
  ? nl;
endproc

' ---- teclado e botoes ----
proc Entrada
  exec LePausa
  ' botao 2 (controles de 2 botoes, linha de paddle): sem controle ligado
  ' a linha pode ler 0, entao so vale depois de ter sido vista em nivel alto
  b2=0
  if paddle(0)>200 then b2ok=1
  if paddle(0)<100 and b2ok=1 then b2=1
  if b2=1 and prevB2=0 then bombReq=1
  prevB2=b2
  if pausa=1 then exec Pausar
endproc

proc Pausar
  q=92
  exec Som

  position 15,12
  ? " PAUSE ";

  repeat
    pause 1
    exec LePausa
  until pausa=1
  bombReq=0

  q=104
  exec Som

  position 15,12
  ? "       ";
  exec Desenha
  lastT=TIME
endproc

proc Musica
  music=music+1
  if music>90 then music=0
  if music mod 10 = 0 and music<=80 then sound 1,mus(music/10),8,6
endproc

' ---- relogio e duracao dos efeitos (em 1/60 s) ----
proc Tempo
  tt=TIME
  dt=tt-lastT
  lastT=tt
  if dt<0 or dt>60 then dt=1
  frac=frac+dt
  if frac>=60
    frac=frac-60
    segs=segs+1
  endif
  if invT>0
    invT=invT-dt
    if invT<0 then invT=0
  endif
  if frzT>0
    frzT=frzT-dt
    if frzT<=0
      frzT=0
      exec Cores
      hud=1
    endif
  endif
  if item>0
    itT=itT-dt
    if itT<=0
      item=0
      poke ra(iy)+ix,0
    endif
  endif
endproc

proc MoveJogador
  ox=px
  oy=py
  od=dir

  ' stick: 7 direita, 11 esquerda, 14 cima, 13 baixo
  s=stDir(stick(0))
  if s<4
    nx=px+ddx(s)
    ny=py+ddy(s)
    if nx>=2 and nx<=37 and ny>=2 and ny<=20
      px=nx
      py=ny
      dir=s
    endif
  endif

  ' desenha a nova posicao primeiro e so depois apaga o que sobrou (sem piscar)
  if px<>ox or py<>oy or dir<>od
    gx=px+ddx(dir)
    gy=py+ddy(dir)
    ogx=ox+ddx(od)
    ogy=oy+ddy(od)
    poke ra(py)+px,64
    poke ra(gy)+gx,gunCh(dir)
    if (ox<>px or oy<>py) and (ox<>gx or oy<>gy) then poke ra(oy)+ox,0
    if (ogx<>px or ogy<>py) and (ogx<>gx or ogy<>gy) then poke ra(ogy)+ogx,0
  endif
endproc

proc Atira
  if strig(0)=0 and shot=0
    shot=1
    shotX=px
    shotY=py
    tdir=dir
    tiroCh=71
    if tdir>1 then tiroCh=72
    q=116
    exec Som
  endif
endproc

proc PassoTiro
  if shot=1
    if shotX<>px or shotY<>py then poke ra(shotY)+shotX,0
    shotX=shotX+ddx(tdir)
    shotY=shotY+ddy(tdir)
    if shotX>38 or shotX<1 or shotY>21 or shotY<2
      shot=0
    else
      exec AcertoTiro
      if shot=1 then poke ra(shotY)+shotX,tiroCh
    endif
  endif
endproc

' ---- o tiro acertou alguem? ----
proc AcertoTiro
  if shot=1
    for i=0 to nEn-1
      if shot=1 and shotX=ex(i) and shotY=ey(i)
        k=i
        exec Mata
        if arma<2 then shot=0
      endif
    next i
    if shot=1 and boss>0
      qx=shotX
      qy=shotY
      exec NoChefe
      if dentro=1
        shot=0
        dano=1
        exec DanoChefe
      endif
    endif
  endif
endproc

' ---- mata o inimigo k ----
proc Mata
  poke ra(ey(k))+ex(k),0
  pts=25
  exec Pontua
  if quiet=0
    q=124
    exec Som
  endif
  if boss=0
    kills=kills+1
    if kills>=20 then passou=1
  endif
  if item=0 and rand(8)=0
    item=itemPick(rand(8))
    itT=600
    ix=3+rand(33)
    iy=2+rand(18)
  endif
  exec Spawn
  hud=1
endproc

proc LancaBomba
  if bombReq=1
    bombReq=0
    if bombas>0 and bombDir=0
      bombas=bombas-1
      bombX=px
      bombY=py
      bombDir=dir+1
      bombDist=0
      q=140
      exec Som
      hud=1
    endif
  endif
endproc

proc PassoBomba
  if bombDir>0
    d=bombDir-1
    nx=bombX+ddx(d)
    ny=bombY+ddy(d)
    if nx<1 or nx>38 or ny<2 or ny>21
      exec Explode
    else
      if bombX<>px or bombY<>py then poke ra(bombY)+bombX,0
      bombX=nx
      bombY=ny
      bombDist=bombDist+1
      poke ra(bombY)+bombX,73
      boom=0
      if bombDist>=6 then boom=1
      for i=0 to nEn-1
        if bombX=ex(i) and bombY=ey(i) then boom=1
      next i
      qx=bombX
      qy=bombY
      exec NoChefe
      if dentro=1 then boom=1
      if boom=1 then exec Explode
    endif
  endif
endproc

' ---- explosao: area de 5x5 ----
proc Explode
  bombDir=0
  x1=bombX-2
  if x1<1 then x1=1
  x2=bombX+2
  if x2>38 then x2=38
  y1=bombY-2
  if y1<2 then y1=2
  y2=bombY+2
  if y2>21 then y2=21
  for f=1 to 5
    c=76
    if (f&1)=1 then c=77
    if f=5 then c=0
    for yy=y1 to y2
      mset ra(yy)+x1,x2-x1+1,c
    next yy
    sound 0,180+f*15,8,16-f*3
    pause 4
  next f
  sound
  quiet=1
  for i=0 to nEn-1
    if ex(i)>=x1 and ex(i)<=x2 and ey(i)>=y1 and ey(i)<=y2
      k=i
      exec Mata
    endif
  next i
  quiet=0
  if boss>0 and bx+3>=x1 and bx<=x2 and by+1>=y1 and by<=y2
    dano=5
    exec DanoChefe
  endif
  exec Desenha
endproc

proc MoveInimigos
  if frzT=0
    eDelay=eDelay+1
    if eDelay>spdTab(fase-1)
      eDelay=0
      for i=0 to nEn-1
        ox=ex(i)
        oy=ey(i)
        if rand(2)=0
          if px>ex(i) then ex(i)=ex(i)+1
          if px<ex(i) then ex(i)=ex(i)-1
        else
          if py>ey(i) then ey(i)=ey(i)+1
          if py<ey(i) then ey(i)=ey(i)-1
        endif
        if ex(i)<>ox or ey(i)<>oy
          poke ra(ey(i))+ex(i),69
          poke ra(oy)+ox,0
        endif
      next i
      exec AcertoTiro
    endif
  endif
endproc

proc DesenhaChefe
  ' moldura vazia em volta: ao andar 1 casa o rastro some sozinho (sem piscar)
  mset ra(by-1)+bx-1,6,0
  mset ra(by+2)+bx-1,6,0
  poke ra(by)+bx-1,0
  poke ra(by)+bx+4,0
  poke ra(by+1)+bx-1,0
  poke ra(by+1)+bx+4,0
  ' inverso (+128): o corpo usa a cor 711, que muda a cada chefao
  for j=0 to 3
    if fase=20
      poke ra(by)+bx+j,bossB(j)+128
      poke ra(by+1)+bx+j,bossB(j+4)+128
    else
      poke ra(by)+bx+j,bossA(j)+128
      poke ra(by+1)+bx+j,bossA(j+4)+128
    endif
  next j
endproc

proc ApagaChefe
  mset ra(by)+bx,4,0
  mset ra(by+1)+bx,4,0
endproc

proc MoveChefe
  if boss>0 and frzT=0
    bDelay=bDelay+1
    if bDelay>bSpdTab(bIdx)
      bDelay=0
      obx=bx
      oby=by
      if rand(2)=0
        if px-1>bx and bx<34 then bx=bx+1
        if px-1<bx and bx>2 then bx=bx-1
      else
        if py>by and by<19 then by=by+1
        if py<by and by>2 then by=by-1
      endif
      if bx<>obx or by<>oby then exec DesenhaChefe
      exec AcertoTiro
    endif
    if bbDir=0 and bShTab(bIdx)>0
      if rand(64)<bShTab(bIdx) then exec ChefeAtira
    endif
  endif
endproc

' ---- o chefao atira na direcao do jogador ----
proc ChefeAtira
  if py>=by and py<=by+1
    bbY=py
    if px<bx
      bbX=bx-1
      bbDir=2
    else
      bbX=bx+4
      bbDir=1
    endif
  else
    bbX=px
    if bbX<bx then bbX=bx
    if bbX>bx+3 then bbX=bx+3
    if py<by
      bbY=by-1
      bbDir=3
    else
      bbY=by+2
      bbDir=4
    endif
  endif
  if bbX<1 or bbX>38 or bbY<2 or bbY>21
    bbDir=0
  else
    poke ra(bbY)+bbX,74
    q=152
    exec Som
  endif
endproc

proc PassoBala
  if bbDir>0 and frzT=0
    poke ra(bbY)+bbX,0
    d=bbDir-1
    bbX=bbX+ddx(d)
    bbY=bbY+ddy(d)
    if bbX<1 or bbX>38 or bbY<2 or bbY>21
      bbDir=0
    else
      poke ra(bbY)+bbX,74
    endif
  endif
endproc

proc DanoChefe
  boss=boss-dano
  if boss<=0
    boss=0
    exec ApagaChefe
    if bbDir>0
      poke ra(bbY)+bbX,0
      bbDir=0
    endif
    pts=1000
    exec Pontua
    passou=1
    q=160
    exec Som
  else
    q=176
    exec Som
  endif
  hud=1
endproc

proc Coleta
  if px=cx and py=cy

    pts=10
    exec Pontua

    q=184
    exec Som

    cx=3+rand(33)
    cy=2+rand(18)

  endif
  if item>0
    if px=ix and py=iy then exec PegaItem
  endif
endproc

proc PegaItem
  pts=50
  exec Pontua
  q=200
  exec Som
  if item=1
    if arma<2 then arma=arma+1
  elif item=2
    if vidas<9 then vidas=vidas+1
  elif item=3
    frzT=300
    exec Cores
  else
    invT=600
  endif
  item=0
  hud=1
endproc

proc Colisoes
  morreu=0
  for i=0 to nEn-1
    if px=ex(i) and py=ey(i)
      if invT>0
        k=i
        exec Mata
      else
        morreu=1
      endif
    endif
  next i
  if boss>0 and invT=0
    qx=px
    qy=py
    exec NoChefe
    if dentro=1 then morreu=1
  endif
  if bbDir>0 and px=bbX and py=bbY
    bbDir=0
    if invT=0 then morreu=1
  endif
  if morreu=1 then exec Morre
endproc

proc Morre
  vidas=vidas-1

  q=216
  exec Som

  poke ra(py)+px,0
  poke ra(py+ddy(dir))+px+ddx(dir),0

  px=3
  py=20
  dir=0
  arma=0
  invT=120
  hud=1
endproc

' ---- redesenha tudo (conserta sobreposicoes) ----
proc Desenha
  if boss>0 then exec DesenhaChefe
  poke ra(cy)+cx,70
  if item>0
    if itT>120 or (itT&8)=0
      poke ra(iy)+ix,itemCh(item-1)
    else
      poke ra(iy)+ix,0
    endif
  endif
  for i=0 to nEn-1
    poke ra(ey(i))+ex(i),69
  next i
  if bbDir>0 then poke ra(bbY)+bbX,74
  if bombDir>0 then poke ra(bombY)+bombX,73
  if shot=1 then poke ra(shotY)+shotX,tiroCh
  gx=px+ddx(dir)
  gy=py+ddy(dir)
  if invT>0 and (TIME&8)=8
    poke ra(py)+px,0
    poke ra(gy)+gx,0
  else
    poke ra(py)+px,64
    poke ra(gy)+gx,gunCh(dir)
  endif
endproc

proc MostraHud
  position 0,0
  ? "Vidas:";vidas;" Pontos:";
  nh=scoreH
  nl=scoreL
  exec PrintNum
  ? " Recorde:";
  nh=hiH
  nl=hiL
  exec PrintNum
  ? "  ";

  hor=segs/3600
  min=(segs mod 3600)/60
  seg=segs mod 60

  position 27,1
  nl=hor
  exec Dois
  ? ":";
  nl=min
  exec Dois
  ? ":";
  nl=seg
  exec Dois

  if hud=1
    hud=0

    position 2,22
    ? "Fase:";
    nl=fase
    exec Dois
    if fase mod 5 = 0
      ? "  Chefao:";
      nl=boss
      exec Dois
      ? "/";bMax;"    ";
    else
      ? "  Inimigos:";
      nl=kills
      exec Dois
      ? "/20  ";
    endif
    ? "Bombas:";bombas;

    position 2,23
    ? "Arma:";
    if arma=0 then ? "TIRO  ";
    if arma=1 then ? "RAPIDO";
    if arma=2 then ? "LASER ";
    iy1=22: ix1=2: ix2=37: exec Inverte
    iy1=23: exec Inverte
  endif
endproc

' ---- cores: 708 inimigos, 709 jogador, 710 paredes/moedas/placar,
' ----        711 chefao e placar de baixo, 712 fundo
proc Cores
  poke 708,$46
  poke 709,$0E
  poke 710,$2A
  poke 712,0
  if boss>0
    poke 711,bossCor(bIdx)
  else
    poke 711,$C8
  endif
  if frzT>0
    poke 708,$9C
    if boss>0 then poke 711,$9C
  endif
endproc

' ---- passa a linha iy1 (colunas ix1..ix2) para a cor 711 ----
proc Inverte
  for xx=ix1 to ix2
    ia=ra(iy1)+xx
    if peek(ia)<128 then poke ia,peek(ia)+128
  next xx
endproc

' ---- toca o efeito que comeca em sfx(q) ----
proc Som
  while sfx(q+3)>0
    sound 0,sfx(q),sfx(q+1),sfx(q+2)
    pause sfx(q+3)
    q=q+4
  wend
  sound
endproc

proc Dois
  if nl<10 then ? "0";
  ? nl;
endproc

' ---- (qx,qy) esta dentro do chefao? ----
proc NoChefe
  dentro=0
  if boss>0 and qx>=bx and qx<=bx+3 and qy>=by and qy<=by+1 then dentro=1
endproc

' ---- teclas de pausa (P / START) e bomba (espaco) ----
proc LePausa
  pausa=0
  k=peek(764)
  if k<>255 then poke 764,255
  if k=10 then pausa=1
  if k=33 then bombReq=1
  st=peek(53279)&1
  if st=0 and prevSt=1 then pausa=1
  prevSt=st
endproc