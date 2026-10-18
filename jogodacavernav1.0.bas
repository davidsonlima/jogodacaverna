' ==========================================
'  JOGO DA CAVERNA v1.0  -  FastBasic
'  Atari 800 (8bitworkshop)
'  Davidson de Oliveira Lima (2026)
' ==========================================
'  Linhas 0-1: texto (ANTIC 2)
'  Linhas 2-23: modo colorido (ANTIC 4)
'  Posicoes dos objetos guardadas como
'  enderecos da memoria de tela.
' ==========================================

DIM CHB(2047) BYTE
DIM SV(39) BYTE
DIM K(255) BYTE
DIM RW(23)
' inimigos: endereco, tipo, vida, contador
DIM EA(7), ET(7), EH(7), EC(7)
' projeteis: 0-7 do jogador, 8-15 inimigos
DIM SP(15), SD(15), SA(15)
' moedas e ninhos
DIM CA(15), QA(2), QH(2)

DATA TILA() BYTE = 252,252,0,207,207,0,252,252,60,251,239,255,255,255,255,60,
DATA BYTE = 0,20,89,101,101,85,20,0,0,20,36,36,20,20,20,0,
DATA BYTE = 0,195,239,255,255,60,60,0,64,96,104,106,104,96,64,0,
DATA BYTE = 170,150,150,150,150,40,40,0,1,4,40,170,154,170,40,0,
DATA BYTE = 0,20,73,73,105,65,20,0,40,40,0,169,40,40,34,34,
DATA BYTE = 40,40,0,106,40,40,136,136,4,36,36,170,40,40,34,34,
DATA BYTE = 40,40,0,170,40,36,36,134,0,0,0,170,85,0,0,0,
DATA BYTE = 32,36,36,36,36,36,4,0,0,65,40,150,150,40,65,0,
DATA BYTE = 65,0,65,4,16,65,0,65,169,149,85,85,85,85,87,95,
DATA BYTE = 60,215,195,203,195,215,60,0,60,195,215,227,215,195,60,0,
DATA BYTE = 20,105,65,105,105,65,105,20,20,20,0,85,20,20,17,17,
DATA BYTE = 8,44,44,191,254,56,56,12
DATA TILB() BYTE = 0,195,235,255,60,0,0,0,0,0,60,235,255,195,195,0,
DATA BYTE = 195,60,235,255,255,60,195,195,0,195,235,255,255,195,60,195,
DATA BYTE = 20,85,125,121,125,85,20,0,0,20,85,85,125,85,20,0,
DATA BYTE = 0,0,60,235,235,60,0,0,80,80,20,7,63,255,250,248,
DATA BYTE = 0,0,255,255,255,255,190,60,5,5,20,208,252,255,175,47,
DATA BYTE = 250,255,255,255,63,57,63,15,190,255,215,255,255,153,255,255,
DATA BYTE = 175,255,255,255,252,156,252,240,195,243,252,63,15,15,15,63,
DATA BYTE = 255,255,255,255,255,0,0,0,195,207,63,252,240,240,240,252


' obstaculos: x,y,larg,alt,tile (255 = fim da fase)
DATA LVL() BYTE = 8,6,3,2,65, 28,6,3,2,65, 17,11,6,2,65, 8,17,3,2,65, 28,17,3,2,65, 255,
DATA BYTE = 5,7,12,1,64, 22,7,12,1,64, 5,12,8,1,64, 17,12,6,1,64, 27,12,8,1,64,
DATA BYTE = 5,17,12,1,64, 22,17,12,1,64, 19,3,1,2,64, 19,21,1,2,64, 255,
DATA BYTE = 6,5,2,4,86, 32,5,2,4,86, 12,10,2,5,65, 26,10,2,5,65, 18,6,4,1,86,
DATA BYTE = 18,18,4,1,86, 6,16,2,4,86, 32,16,2,4,86, 255,
DATA BYTE = 7,3,1,7,64, 7,13,1,7,64, 15,7,1,12,64, 23,3,1,8,64, 23,15,1,8,64,
DATA BYTE = 31,7,1,12,64, 11,11,2,1,65, 27,11,2,1,65, 255,
DATA BYTE = 8,6,2,2,65, 8,18,2,2,65, 13,11,2,2,65, 255

' ninhos por fase (x,y) x3
DATA PORT() BYTE = 35,4,35,20,0,0, 36,4,2,4,36,21, 19,12,36,3,2,3, 35,4,35,21,19,4, 16,4,16,21,0,0
' moedas, max inimigos, intervalo, tipos, aceleracao
DATA FCFG() BYTE = 8,4,90,1,0, 10,5,80,2,1, 12,6,70,3,1, 14,7,60,3,2, 0,5,120,2,2
' cores 708-711 por fase
DATA FCOL() BYTE = $1C,$0E,$F4,$46, $1C,$0E,$84,$36, $1C,$0E,$C4,$56, $EC,$0E,$54,$26, $1C,$0E,$32,$46
' classes de tile: inicio,fim,classe
DATA KD() BYTE = 64,65,1, 86,86,1, 66,67,2, 196,196,3, 69,72,3, 73,76,4, 84,85,4,
DATA BYTE = 224,229,5, 230,230,6, 231,239,7, 210,211,8, 77,78,9, 255
' efeitos: tom, variacao+128, duracao, distorcao, volume
DATA SFXD() BYTE = 30,136,6,10,8, 20,138,14,8,10, 60,121,8,10,10, 120,116,10,10,10,
DATA BYTE = 60,140,24,8,14, 180,118,5,12,10, 250,122,30,12,12, 200,118,12,12,10, 150,122,10,12,5
DATA ITW() BYTE = 1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5
DATA ITT() BYTE = 0,196,69,70,71,72
DATA EDL() BYTE = 0,7,10,15
DATA DXT() BYTE = 2,0,1,1
DATA DYT() BYTE = 1,1,2,0
DATA JNG() BYTE = 121,96,81,60
DATA KO() BYTE = 0,0,9,6
DATA MEL() BYTE = 72,0,60,0,47,0,60,72, 81,0,64,0,53,0,64,81,
DATA BYTE = 91,0,72,0,60,0,72,91, 96,0,81,0,64,0,81,96
DATA BMEL() BYTE = 72,72,68,72, 64,72,60,72, 76,76,72,76, 68,76,64,76
DATA LOGO() BYTE = 7,7,5,7,6,5,7, 4,5,5,4,5,7,5, 4,7,5,6,6,7,7, 4,5,5,4,5,7,5, 7,5,2,7,5,5,5
' textos: linha, coluna (255 = centro), texto
DATA TTL() BYTE = 1,255,"J O G O   D A",
DATA BYTE = 10,255,"V1.0 - ATUALIZADO EM 17-OUT-2026",
DATA BYTE = 11,255,"PEGUE AS MOEDAS E VENCA O CHEFE!",
DATA BYTE = 13,255,"SETAS=MOVER SHIFT=ATIRAR P=PAUSA",
DATA BYTE = 15,14,"RECORDE:",
DATA BYTE = 17,255,"DESENVOLVIDO POR",
DATA BYTE = 18,255,"DAVIDSON DE OLIVEIRA LIMA (2026)",
DATA BYTE = 19,255,"DAVIDSONEQ@GMAIL.COM",
DATA BYTE = 20,255,"@DAVI.MPB",
DATA BYTE = 21,255,"GITHUB.COM/DAVIDSONLIMA",
DATA BYTE = 23,255,"APERTE FIRE PARA COMECAR", 255
DATA HTX() BYTE = 0,1,"VIDAS:  PONTOS:       RECORDE:", 1,1,"FASE:  MOEDAS:  /", 255
DATA HTB() BYTE = 1,8,"CHEFE  ", 1,15,"   ", 255
DATA NMS() BYTE = "ENTRADA DA CAVERNA","TUNEIS ESCUROS","GRUTA DE CRISTAL","MINAS PROFUNDAS","COVIL DO CHEFE!"

' variaveis usadas antes de receber valor
CS=0 : HISCORE=0 : F=0 : RY=0 : RX=0 : SN=0 : KI=0 : NLO=0
NS=0 : HD=0 : BDMG=0 : FR=0 : HT=0
M$=""


' ============ TITULO E FASES ============

PROC TITLE
  EXEC MUTE
  GRAPHICS 0
  POKE 752,1
  POKE 756, CS/256
  SC = DPEEK(88) : DL = DPEEK(560)
  FOR TY=0 TO 23
    RW(TY) = SC+TY*40
    LROW=TY : LMOD=2
    IF TY>=2 AND TY<=8 THEN LMOD=4
    EXEC RMODE
  NEXT TY
  POKE 709,$0E : POKE 710,$92 : POKE 712,$92
  MSET SC, 960, 0
  TP = ADR(TTL) : EXEC TABTEXT
  FOR TY=0 TO 4
    FOR TX=0 TO 6
      TV = LOGO(TY*7+TX)
      TA = RW(3+TY) + 6 + TX*4
      IF TV&4 THEN POKE TA, 81
      IF TV&2 THEN POKE TA+1, 81
      IF TV&1 THEN POKE TA+2, 81
    NEXT TX
  NEXT TY
  NV=HISCORE : ND=5 : TA=RW(15)+23 : EXEC PNUM
  REPEAT : UNTIL STRIG(0)
  TK=0
  REPEAT
    POKE 77,0
    TK=TK+1
    POKE 708, (TK*2) & $F0 ! $0C
    PAUSE 1
  UNTIL STRIG(0)=0
  ' tela do jogo
  FOR TY=2 TO 23
    LROW=TY : LMOD=4 : EXEC RMODE
  NEXT TY
ENDPROC

PROC LOADFASE
  EXEC MUTE
  TV = F*4-4
  MOVE ADR(FCOL)+TV, 708, 4
  C711 = FCOL(TV+3)
  POKE 712, 0
  MSET SC, 960, 0
  MSET SC+80, 40, 64
  MSET SC+920, 40, 64
  FOR TY=3 TO 22
    POKE RW(TY), 64 : POKE RW(TY)+39, 64
  NEXT TY
  TP=0 : TF=1
  WHILE TF<F
    IF LVL(TP)=255 THEN TF=TF+1
    TP=TP+1
  WEND
  WHILE LVL(TP)<255
    TA = RW(LVL(TP+1))+LVL(TP)
    FOR TY=1 TO LVL(TP+3)
      MSET TA, LVL(TP+2), LVL(TP+4)
      TA=TA+40
    NEXT TY
    TP=TP+5
  WEND
  TV = F*5-5
  NC = FCFG(TV) : MAXE = FCFG(TV+1) : SPINT = FCFG(TV+2)
  ETYPES = FCFG(TV+3) : ESUB = FCFG(TV+4)
  FOR TJ=0 TO 15
    ET(TJ&7)=0 : SA(TJ)=0 : SP(TJ)=SC : CA(TJ)=0
  NEXT TJ
  NENE=0 : IT=0 : SPT=60 : BOSS=0 : RAGE=0
  TRI=0 : SHD=0 : FRZ=0 : INV=0 : FCD=0
  PX=2 : PY=21 : PDX=1 : PDY=0 : PMV=0
  TV = F*6-6
  FOR TJ=0 TO 2
    QA(TJ)=0 : QH(TJ)=8
    IF PORT(TV)
      QA(TJ)=RW(PORT(TV+1))+PORT(TV) : POKE QA(TJ), 210
    ENDIF
    TV=TV+2
  NEXT TJ
  CL=NC : TK=0
  WHILE TK<NC
    EXEC RNDCELL
    CA(TK)=RW(RY)+RX : POKE CA(TK), 66
    TK=TK+1
  WEND
  IF F=5
    BOSS=1 : BHP=40 : BXX=30 : BYY=11 : BHD=-1 : BMC=20 : BAT=90 : BPN=0
    EXEC BDRAW
  ENDIF
  MTEMPO = 10-F-BOSS*3
  MS=0 : MC=1
  TP = ADR(HTX) : EXEC TABTEXT
  IF BOSS
    TP = ADR(HTB) : EXEC TABTEXT
  ENDIF
  EXEC HUD
  ' apresentacao
  TP = ADR(NMS)
  FOR TJ=2 TO F
    TP = TP+PEEK(TP)+1
  NEXT TJ
  M$="FASE " : M$ =+ STR$(F) : M$ =+ " - " : M$ =+ $(TP)
  EXEC BANNER
  EXEC JINGLE
  PAUSE 60
  EXEC UNBANNER
ENDPROC


' ============ TELA ============

PROC RMODE
  IF LROW
    POKE DL+5+LROW, LMOD
  ELSE
    POKE DL+3, $40+LMOD
  ENDIF
ENDPROC

' texto em TP (com tamanho) no endereco TA
PROC PTEXT
  FOR TI=1 TO PEEK(TP)
    POKE TA+TI-1, PEEK(TP+TI)-32
  NEXT TI
ENDPROC

PROC TABTEXT
  WHILE PEEK(TP)<255
    TA = RW(PEEK(TP)) : TV = PEEK(TP+1) : TP = TP+2
    IF TV=255 THEN TV = (40-PEEK(TP))/2
    TA = TA+TV : EXEC PTEXT
    TP = TP+PEEK(TP)+1
  WEND
ENDPROC

PROC PNUM
  TV = NV
  FOR TI=ND-1 TO 0 STEP -1
    POKE TA+TI, 16 + TV MOD 10
    TV = TV/10
  NEXT TI
ENDPROC

' faixa com M$ na linha 12
PROC BANNER
  MOVE RW(12), ADR(SV), 40
  LROW=12 : LMOD=2 : EXEC RMODE
  MSET RW(12), 40, 0
  TP = ADR(M$) : TA = RW(12) + (40-LEN(M$))/2
  EXEC PTEXT
ENDPROC

PROC UNBANNER
  MOVE ADR(SV), RW(12), 40
  LROW=12 : LMOD=4 : EXEC RMODE
ENDPROC

PROC MUTE
  SOUND
  SFT=0
ENDPROC

PROC JINGLE
  FOR TK=0 TO 3
    SOUND 0, JNG(TK), 10, 10 : PAUSE 8
  NEXT TK
  PAUSE 12
  SOUND
ENDPROC

' ============ SOM ============

PROC SFX
  TV = SN*5
  SFP = SFXD(TV) : SFD = SFXD(TV+1)-128 : SFT = SFXD(TV+2)
  SFC = SFXD(TV+3) : SFV = SFXD(TV+4)
ENDPROC

PROC SOUNDS
  IF SFT
    SOUND 0, SFP, SFC, SFV
    SFP = SFP+SFD
    SFT = SFT-1
    IF SFT=0 THEN SOUND 0,0,0,0
  ENDIF
  MC = MC-1
  IF MC<=0
    MC = MTEMPO
    MN = MEL(MS & 31)
    IF BOSS THEN MN = BMEL(MS & 15)
    TV=3
    IF MN=0 THEN TV=0
    SOUND 1, MN, 10, TV
    MS = MS+1
  ENDIF
ENDPROC

' ============ OBJETOS ============

' celula vazia aleatoria -> RX,RY (RX=0 se falhar)
PROC RNDCELL
  FOR TJ=1 TO 60
    RX = 1+RAND(38) : RY = 3+RAND(20)
    IF PEEK(RW(RY)+RX)=0 AND ABS(RX-PX)+ABS(RY-PY)>4 THEN EXIT
  NEXT TJ
ENDPROC

PROC HURT
  VIDAS = VIDAS-1
  INV = 60
  SN=4 : EXEC SFX
  HUDF=1
ENDPROC

' mata inimigo KI (pode soltar item)
PROC KILLE
  HA=EA(KI) : SCORE=SCORE+ET(KI)*20 : ET(KI)=0 : NENE=NENE-1
  TV=0
  IF IT=0 AND RAND(5)=0
    IT=ITW(RAND(20)) : TV=ITT(IT) : IA=HA : ITM=300
  ENDIF
  POKE HA, TV
  SN=1 : EXEC SFX
  HUDF=1
ENDPROC

' inimigo no endereco HA -> KI
PROC FINDE
  KI=-1
  FOR TJ=0 TO 7
    IF ET(TJ) AND EA(TJ)=HA THEN KI=TJ
  NEXT TJ
ENDPROC

' remove bala no endereco HA
PROC KILLB
  FOR TJ=8 TO 15
    IF SP(TJ)=HA THEN SA(TJ)=0
  NEXT TJ
  POKE HA, 0
  SCORE=SCORE+5
ENDPROC

' novo projetil: HA posicao, HD passo, NLO primeiro slot, NS estado
PROC NEWP
  NF=0
  FOR TJ=NLO TO NLO+7
    IF NF=0 AND SA(TJ)=0
      SA(TJ)=NS : SP(TJ)=HA : SD(TJ)=HD : NF=1
    ENDIF
  NEXT TJ
ENDPROC

' bala inimiga em HA com passo HD
PROC ADDB
  TV = PEEK(HA)
  IF K(TV)=4 AND SHD=0 AND INV=0 THEN EXEC HURT
  IF TV=0
    NLO=8 : NS=3 : EXEC NEWP
    IF NF THEN POKE HA, 230
  ENDIF
ENDPROC

' ============ CHEFE ============

PROC BDRAW
  TV = 231
  TA = RW(BYY)+BXX
  FOR TJ=0 TO 2
    POKE TA, TV : POKE TA+1, TV+1 : POKE TA+2, TV+2
    TA=TA+40 : TV=TV+3
  NEXT TJ
ENDPROC

PROC BERASE
  TA = RW(BYY)+BXX
  FOR TJ=0 TO 2
    MSET TA, 3, 0
    TA=TA+40
  NEXT TJ
ENDPROC

PROC BHIT
  BHP = BHP-BDMG
  BFL = 4 : SCORE = SCORE+5 : SN=5
  IF BHP<=20 AND RAGE=0
    RAGE=1 : SN=6
  ENDIF
  EXEC SFX
  IF BHP<=0
    BHP=0 : STATE=2
  ENDIF
  HUDF=1
ENDPROC

PROC BOSSRUN
  BMC = BMC-1
  IF BMC<=0
    BMC = 12 - RAGE*5
    NBX = BXX + BHD
    IF NBX<19 OR NBX>35
      BHD = -BHD : NBX = BXX
    ENDIF
    NBY = BYY + SGN(PY-BYY-1)
    IF NBY<3 OR NBY>20 OR RAND(3)=0 THEN NBY=BYY
    ' testa se cabe
    BOK=1
    FOR TJ=0 TO 2
      TA = RW(NBY+TJ)+NBX
      FOR TK=0 TO 2
        HB = K(PEEK(TA+TK))
        IF HB=4 AND SHD=0 AND INV=0 THEN EXEC HURT
        IF HB AND HB<>7 THEN BOK=0
      NEXT TK
    NEXT TJ
    IF BOK
      EXEC BERASE
      BXX=NBX : BYY=NBY
      EXEC BDRAW
    ENDIF
  ENDIF
  BAT = BAT-1
  IF BAT<=0
    BAT = 80 - RAGE*35
    BPN = (BPN+1) MOD 3
    CBX = BXX+1 : CBY = BYY+1
    IF BPN=2
      ' invoca lacaios
      HA=RW(BYY)+BXX-1 : EXEC SPAWNAT
      HA=HA+80 : EXEC SPAWNAT
    ELSE
      ' 0 = 8 direcoes, 1 = leque para o lado do jogador
      FOR HDY=-1 TO 1
        FOR HDX=-1 TO 1
          IF (HDX OR HDY) AND (BPN=0 OR HDX=SGN(PX-CBX))
            HA=RW(CBY+HDY*2)+CBX+HDX*2 : HD=HDX+HDY*40 : EXEC ADDB
          ENDIF
        NEXT HDX
      NEXT HDY
    ENDIF
    SN=7 : EXEC SFX
  ENDIF
ENDPROC

' ============ INIMIGOS ============

' novo inimigo no endereco HA
PROC SPAWNAT
  SI=-1
  IF NENE<MAXE AND PEEK(HA)=0
    FOR TJ=0 TO 7
      IF ET(TJ)=0 THEN SI=TJ
    NEXT TJ
    IF SI>=0
      TT = 1+RAND(ETYPES)
      IF TT=3 AND RAND(2) THEN TT=1
      IF RAGE THEN TT=2
      ET(SI)=TT : EH(SI)=TT : EA(SI)=HA : EC(SI)=40
      POKE HA, 222+TT*2
      NENE=NENE+1
      SN=8 : EXEC SFX
    ENDIF
  ENDIF
ENDPROC

PROC ENEMIES
  SPT = SPT-1
  IF SPT<=0
    SPT = SPINT
    TK = RAND(3) : TV = RAND(4)
    IF QA(TK)
      HA = QA(TK)+DXT(TV)-1+DYT(TV)*40-40
      EXEC SPAWNAT
    ENDIF
  ENDIF
  FOR I=0 TO 7
    T0 = ET(I)
    IF T0
      EC(I)=EC(I)-1
      IF EC(I)<=0
        EC(I) = EDL(T0)-ESUB
        IF RAGE THEN EC(I)=5
        OA = EA(I) : TV = OA-SC
        DX = PX - TV MOD 40 : DY = PY - TV/40
        IF (T0=2 AND RAND(4)) OR RAND(3)=0
          MX=0 : MY=SGN(DY)
          IF ABS(DX)>ABS(DY)
            MX=SGN(DX) : MY=0
          ENDIF
        ELSE
          TV=RAND(4) : MX=DXT(TV)-1 : MY=DYT(TV)-1
        ENDIF
        IF T0=3
          ' olho atirador
          IF RAND(3)=0 AND (DX=0 OR DY=0)
            HD=SGN(DX)+SGN(DY)*40 : HA=OA+HD : EXEC ADDB
          ENDIF
        ENDIF
        NA = OA+MX+MY*40
        TV = PEEK(NA)
        IF TV=0
          POKE OA, 0
          EA(I)=NA
          POKE NA, 222+T0*2+((FR/8)&1)
        ELSE
          IF K(TV)=4
            IF SHD
              KI=I : EXEC KILLE
            ELSE
              IF INV=0 THEN EXEC HURT
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  NEXT I
ENDPROC

' ============ TIROS ============

' tiro atingiu HT no endereco HA
PROC SHOTHIT
  HB = K(HT)
  IF HB=5
    EXEC FINDE
    IF KI>=0
      EH(KI)=EH(KI)-1
      IF EH(KI)
        SN=5 : EXEC SFX
      ELSE
        EXEC KILLE
      ENDIF
    ENDIF
  ENDIF
  IF HB=6 THEN EXEC KILLB
  IF HB=7
    BDMG=1 : EXEC BHIT
  ENDIF
  IF HB=8
    FOR TJ=0 TO 2
      IF QA(TJ)=HA
        QH(TJ)=QH(TJ)-1 : SN=5
        IF QH(TJ)=0
          QA(TJ)=0 : POKE HA, 0
          SCORE=SCORE+150 : SN=1 : HUDF=1
        ENDIF
        EXEC SFX
      ENDIF
    NEXT TJ
  ENDIF
ENDPROC

PROC SHOTS
  IF FCD
    FCD=FCD-1
  ELSE
    IF STRIG(0)=0
      HA=RW(PY)+PX : NLO=0 : NS=1 : FCD=12
      HD=PDX+PDY*40 : EXEC NEWP
      IF TRI
        FCD=8 : TV=HD
        IF PDX
          HD=TV-40 : EXEC NEWP : HD=TV+40 : EXEC NEWP
        ELSE
          HD=TV-1 : EXEC NEWP : HD=TV+1 : EXEC NEWP
        ENDIF
      ENDIF
      SN=0 : EXEC SFX
    ENDIF
  ENDIF
  ' move todos os projeteis
  BFR = 1-BFR
  FOR I=0 TO 15
    TT = SA(I)
    IF TT AND (I<8 OR (BFR AND FRZ=0))
      OA = SP(I)
      IF K(PEEK(OA))=KO(TT) THEN POKE OA, 0
      HA = OA+SD(I) : SP(I) = HA
      HT = PEEK(HA)
      IF HT
        SA(I)=0
        IF I<8
          EXEC SHOTHIT
        ELSE
          IF K(HT)=4 AND INV=0 AND SHD=0 THEN EXEC HURT
        ENDIF
      ELSE
        TV=230
        IF I<8
          SA(I)=2 : TV=77
          IF ABS(SD(I))=40 THEN TV=78
        ENDIF
        POKE HA, TV
      ENDIF
    ENDIF
  NEXT I
ENDPROC

' ============ JOGADOR ============

PROC GETITEM
  IF IT=1 AND VIDAS<9 THEN VIDAS=VIDAS+1
  IF IT=2 THEN TRI=300
  IF IT=3 THEN SHD=240
  IF IT=4
    ' bomba
    FOR KI=0 TO 7
      IF ET(KI) THEN EXEC KILLE
    NEXT KI
    FOR TJ=8 TO 15
      IF K(PEEK(SP(TJ)))=6 THEN POKE SP(TJ), 0
      SA(TJ)=0
    NEXT TJ
    IF BOSS
      BDMG=5 : EXEC BHIT
    ENDIF
  ENDIF
  IF IT=5 THEN FRZ=180
  IT=0 : SCORE=SCORE+50 : SN=3 : EXEC SFX : HUDF=1
ENDPROC

PROC PLAYER
  IF PMV
    PMV=PMV-1
  ELSE
    S = STICK(0) : MX=0 : MY=0
    IF (S&4)=0 THEN MX=-1
    IF (S&8)=0 THEN MX=1
    IF MX=0
      IF (S&1)=0 THEN MY=-1
      IF (S&2)=0 THEN MY=1
    ENDIF
    IF MX OR MY
      PDX=MX : PDY=MY : PMV=3
      HA = RW(PY+MY)+PX+MX
      TV = PEEK(HA) : HB = K(TV)
      IF HB=2
        FOR TJ=0 TO 15
          IF CA(TJ)=HA THEN CA(TJ)=0
        NEXT TJ
        CL=CL-1 : SCORE=SCORE+10 : SN=2 : EXEC SFX : HUDF=1
        TV=0
      ENDIF
      IF HB=3
        EXEC GETITEM : TV=0
      ENDIF
      IF HB>=5 AND HB<=7
        IF SHD=0 AND INV=0 THEN EXEC HURT
      ENDIF
      IF TV=0
        POKE RW(PY)+PX, 0
        PX=PX+MX : PY=PY+MY
      ENDIF
    ENDIF
  ENDIF
  TV=73
  IF PDX<0 THEN TV=74
  IF PDY<0 THEN TV=75
  IF PDY>0 THEN TV=76
  IF SHD AND (FR&8) THEN TV=84
  IF INV AND (FR&4) THEN TV=85
  POKE RW(PY)+PX, TV
ENDPROC

' ============ HUD ============

PROC HUD
  IF SCORE>HISCORE THEN HISCORE=SCORE
  POKE SC+7, 16+VIDAS : POKE SC+46, 16+F
  NV=SCORE : ND=5 : TA=SC+16 : EXEC PNUM
  NV=HISCORE : TA=SC+31 : EXEC PNUM
  ND=2
  IF BOSS
    MSET SC+54, 8, 14
    IF BHP THEN MSET SC+54, (BHP+4)/5, 128
  ELSE
    NV=NC-CL : TA=SC+55 : EXEC PNUM
    NV=NC : TA=SC+58 : EXEC PNUM
  ENDIF
  HUDF=0
ENDPROC

' ============ FASES ============

' ============ TITULO ============

' ============ PRINCIPAL ============

CS = (ADR(CHB)+1023) & $FC00
MOVE $E000, CS, 1024
MOVE ADR(TILA), CS+512, 184
MOVE ADR(TILB), CS+768, 128
TP=0
WHILE KD(TP)<255
  FOR TV=KD(TP) TO KD(TP+1)
    K(TV)=KD(TP+2)
  NEXT TV
  TP=TP+3
WEND

DO
  EXEC TITLE
  SCORE=0 : VIDAS=3 : F=1
  REPEAT
    EXEC LOADFASE
    STATE=0 : LT=PEEK(20)
    REPEAT
      ' 30 quadros por segundo
      REPEAT
        DF = (PEEK(20)-LT) & 255
      UNTIL DF>=2
      LT = PEEK(20)
      POKE 77,0
      FR=FR+1
      ' pausa
      IF PEEK(764)=10
        POKE 764,255
        EXEC MUTE
        M$="PAUSA - APERTE P" : EXEC BANNER
        REPEAT : POKE 77,0 : UNTIL PEEK(764)=10
        POKE 764,255
        EXEC UNBANNER
      ENDIF
      EXEC SOUNDS
      EXEC PLAYER
      EXEC SHOTS
      IF FRZ
        FRZ=FRZ-1
      ELSE
        EXEC ENEMIES
        IF BOSS THEN EXEC BOSSRUN
      ENDIF
      ' animacao de moedas e ninhos
      IF (FR&15)=0
        TV = 66+((FR/16)&1)
        FOR TJ=0 TO 15
          IF CA(TJ) THEN POKE CA(TJ), TV
        NEXT TJ
        FOR TJ=0 TO 2
          IF QA(TJ) THEN POKE QA(TJ), TV+144
        NEXT TJ
      ENDIF
      ' itens
      IF IT
        ITM=ITM-1
        IF ITM=0
          IF K(PEEK(IA))=3 THEN POKE IA,0
          IT=0
        ENDIF
      ENDIF
      IF TRI THEN TRI=TRI-1
      IF SHD THEN SHD=SHD-1
      IF INV THEN INV=INV-1
      ' cores
      TV = C711
      IF RAGE THEN TV = $36 - (FR&8)
      IF FRZ THEN TV=$9A
      IF BFL
        BFL=BFL-1 : TV=$0E
      ENDIF
      POKE 711, TV
      IF HUDF THEN EXEC HUD
      IF BOSS=0 AND CL=0 THEN STATE=1
    UNTIL VIDAS=0 OR STATE
    EXEC MUTE
    POKE 712,0
    IF STATE=2
      ' chefe derrotado
      FOR TK=1 TO 40
        POKE RW(BYY+RAND(3))+BXX+RAND(3), 79+RAND(2)
        POKE 712, RAND(16)*16+4
        SOUND 0, 20+RAND(60), 8, 12
        PAUSE 3
      NEXT TK
      EXEC BERASE
      POKE 712,0
      SCORE = SCORE+2000
    ENDIF
    IF STATE=1
      BON = F*250 + VIDAS*50
      SCORE = SCORE+BON
      EXEC HUD
      M$="FASE COMPLETA! BONUS " : M$ =+ STR$(BON) : EXEC BANNER
      EXEC JINGLE
      PAUSE 80
      EXEC UNBANNER
      F=F+1
    ENDIF
  UNTIL VIDAS=0 OR STATE=2
  EXEC HUD
  M$="GAME OVER"
  IF STATE=2 THEN M$="VOCE VENCEU! A CAVERNA E SUA!"
  EXEC BANNER
  EXEC JINGLE
  EXEC JINGLE
  PAUSE 60
  REPEAT : POKE 77,0 : UNTIL STRIG(0)
  REPEAT : POKE 77,0 : UNTIL STRIG(0)=0
LOOP