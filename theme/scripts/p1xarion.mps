
type
  tEvent = record
    title : string[60];
    desc : string[60];
    outcome: array[1..4] of Integer;
  end;

type
  tCard = record
    title : string[60];
    aTitle : string[60];
    aDesc : string[60];
    aOutcome: array[1..4] of Integer;
    bTitle : string[60];
    bDesc : string[60];
    bOutcome: array[1..4] of Integer;
  end;
const
  EP=1;
  RH=2;
  DL=3;
  HS=4;
  A=1;
  B=2;
var
  ElectricPower, ResidentsHappiness, DiplomacyLevel, HealthSupport: Integer;
  deck: array[1..100] of tCard;
  isGameOver: Boolean;
  activeCardId: Byte;
  activeChoice: Byte;
  cardsLeft: Byte;
  cardCount: Byte;

procedure InitializeGame;
var
  eventA, eventB: tEvent;
  card: tCard;
begin
  isGameOver := false;
  activeCardId := 1;
  cardCount := 1;
  ElectricPower := 100;
  ResidentsHappiness := 60;
  DiplomacyLevel := 50;
  HealthSupport := 100;

  // READ THE DECK CARDS FROM DAT FILE
  // ...

  card.title := 'This is a test card';

  card.aTitle := 'Description Event';
  card.aDesc := 'This is a detailed description no longer than 60';
  card.aOutcome[EP] := -1;
  card.aOutcome[RH] := 0;
  card.aOutcome[DL] := 3;
  card.aOutcome[HS] := 2;

  card.bTitle := 'Do not choose this!';
  card.bDesc := 'Choosing this option will decrease your stats a lot!';
  card.bOutcome[EP] := -3;
  card.bOutcome[RH] := -3;
  card.bOutcome[DL] := 0;
  card.bOutcome[HS] := 0;

  deck[1] := card;
  deck[2] := card;
  deck[3] := card;
  
  cardsLeft := 3;
end;

procedure ProcessChoice();
begin
  if activeChoice > 0 then
  begin
    DispFile('g1_outcome.asc');

    GotoXY(30,14);
    Write('|17|15Outcome of the choice ');
    case activeChoice of
      1: WriteLn('A')
      2: WriteLn('B');
    end;
    Writeln('|16|15');

    GotoXY(25,16);
    Writeln('  -  PRESS [ENTER] TO CONTINUE  -  ');

    cardsLeft := cardsLeft -1;
    cardCount := cardCount + 1;
    activeChoice := 0;
    HealthSupport := HealthSupport - 1;
    ReadKey;
  end;
end;

procedure DisplayEvent();
var
  outcome: Integer;
begin
  case activeChoice of
    0: DispFile('g1_card0.asc');
    1: DispFile('g1_card1.asc');
    2: DispFile('g1_card2.asc');
  end;

  // FILL CARDS WITH DATA
  GotoXY(16,6);
  Write('|15'+deck[activeCardId].Title);

  GotoXY(4,9);
  Write('|07'+deck[activeCardId].aTitle);
  GotoXY(4,10);
  Write('|15'+deck[activeCardId].aDesc);

  outcome := deck[activeCardId].aOutcome[EP];
  GotoXY(6,12);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|07 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' Electric Power');

  outcome := deck[activeCardId].aOutcome[RH];
  GotoXY(6,13);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|07 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' Residents Happiness');

  
  outcome := deck[activeCardId].aOutcome[HS];
  GotoXY(30,12);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|07 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' Health Support');

  outcome := deck[activeCardId].aOutcome[DL];
  GotoXY(30,13);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|07 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' Diplomacy Level');
  

  GotoXY(22,16);
  Write('|07Card B title');

  GotoXY(22,17);
  Write('|15Card B description');

  GotoXY(24,19);
  Write('|12-1 bad outcome');

  GotoXY(24,20);
  Write('|10+1 good outcome');

end;


procedure DisplayHeader();
begin
  DispFile('g1_header');
  GotoXY(16,3);
  Write('|19|00'+Int2Str(ElectricPower)+'%');
  GotoXY(35,3);
  Write('|19|00'+Int2Str(ResidentsHappiness)+'%');
  GotoXY(50,3);
  Write('|19|00'+Int2Str(DiplomacyLevel)+'%');
  GotoXY(70,3);
  Write('|19|00'+Int2Str(HealthSupport)+'%');
  //TODO: fill progress bars
end;

procedure DisplayFooter();
begin
  DispFile('g1_footer');
  GotoXY(16,23);
  Write(Int2Str(cardCount));
  GotoXY(73,23);
  Write(Int2Str(cardsLeft));
  // TODO: fill progress bar
end;

procedure DisplayStats();
begin
  ClrScr;
  DispFile('g1_stats.asc');
  GotoXY(36,6);
  Write('|14'+Int2Str(ElectricPower)+'%');
  GotoXY(36,16);
  Write('|13'+Int2Str(ResidentsHappiness)+'%');
  GotoXY(74,16);
  Write('|11'+Int2Str(DiplomacyLevel)+'%');
  GotoXY(74,6);
  Write('|07'+Int2Str(HealthSupport)+'%');
  ReadKey;
end;

procedure DisplayGameOver();
begin
  ClrScr;

  if ElectricPower < 1 then
    DispFile('g1_end1.asc');
  else
  if ResidentsHappiness < 1 then
    DispFile('g1_end2.asc');
  else
  if DiplomacyLevel < 1 then
    DispFile('g1_end3.asc');
  if HealthSupport < 1 then
    DispFile('g1_end4.asc');
  else
  if cardsLeft < 1 then
    DispFile('g1_win.asc');
  else
    DispFile('g1_abort.asc');

  ReadKey;
end;

procedure MainGameLoop;
begin
  while (ElectricPower > 0) and (ResidentsHappiness > 0) and (DiplomacyLevel > 0) and (HealthSupport > 0) and (cardsLeft > 0) do
  begin
    ClrScr;

    DisplayHeader();
    DisplayEvent();
    DisplayFooter();

    Case OneKey(#65 + #66 + #13 + #27 + #32, False) of
      #65 : activeChoice:=1;
      #66 : activeChoice:=2;
      #32: DisplayStats;
      #13: ProcessChoice;
      #27 : Break;
    End;

    //isGameOver := True;
 end;
end;

begin
  PurgeInput;
  ClrScr;
  InitializeGame;

  while True do
  begin
    ClrScr;
    DispFile('g1_menu.asc');

    Case OneKey(#13+#27, False) of
      #27: Break;
    End;
  
    ClrScr;
    DispFile('g1_brief.asc');
    ReadKey;

    MainGameLoop;

    DisplayGameOver();

    InitializeGame;
  end;

  ClrScr;
  DispFile('g1_bye.asc');
  ReadKey;
end.
