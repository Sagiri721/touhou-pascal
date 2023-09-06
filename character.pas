unit Character;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib;

type

  Point = record
    x, y: Real;
  end;

  GameCharacter = class(TOBject)
          private

              cName: String;
              cAttackRange, cAttackPower: Integer;

              cPosition: Point;
              cSprite: TTexture;

              collisionMask: TRectangle;
              size: Byte;

              cOriginSpeed, cMovingSpeed, cPower: Real;
              cHP: Integer;
              cBombs: Integer;
              cScore: LongInt;
              cGraze: Integer;

              procedure updateCollisionMask();

          public

            reapear, movable, iFraming: Boolean;
            counter: Integer;

            property Name: String read cName write cName;          
            property Sprite: TTexture read cSprite write cSprite;
            property Position: Point read cPosition write cPosition;
            property Collision: TRectangle read collisionMask write collisionMask;

            property HP: Integer read cHP write cHP;
            property Bombs: Integer read cBombs write cBombs;
            property Score: LongInt read cScore write cScore;
            property Power: Real read cPower write cPower;
            property Graze: Integer read cGraze write cGraze;

            constructor Create(n: String; s: Byte); overload;
            
            procedure moveInDirection(x, y: Real; coll: Boolean);
            procedure setPosition(x, y: Integer);

            procedure focus();
            procedure stopFocus();

            function getCollisionMask(): TRectangle;
  end;

const
  collisionSize: Integer = 10;
  collisionOffset: Point = (x: 0; y:10);

  playingField: TRectangle = (x: 35; y: 15; width: 400; height: 570);

  playerSize: Byte = 48;
  playerGrabDistance: Integer = 80;

  function PointCreate(x, y: Real): Point;
  function RectangleContains(r1, r2: TRectangle): Boolean;
  function GetVectorMagnitude(p1, p2: Point) : Real;
  
  function GetPlayerPosition() : Point;
  function GetPlayerCollision() : TRectangle;
  function IsIFraming() : Boolean;
  
  procedure GiveScore(amount: Integer);
  procedure HurtPlayer();

var
  player: GameCharacter;

implementation
uses Bullet;

function PointCreate(x, y: Real) : Point;
var
  newPoint: Point;
begin
  
  newPoint.x := x;
  newPoint.y := y;

  PointCreate := newPoint;
end;

constructor GameCharacter.Create(n: String; s: Byte);
begin
  
  cName := n;
  cPosition.x := 0;
  cPosition.y := 0;

  collisionMask := RectangleCreate(cPosition.x, cPosition.y, collisionSize, collisionSize);

  cOriginSpeed := 4.2;
  cMovingSpeed := cOriginSpeed;

  size := s;

  (* Get the sprite image *)
  cSprite := LoadTexture('res/reimu.png');

  cHP := 3;
  cBombs := 3;
  cPower := 0;
  cScore := 0;
  cGraze := 0;

  player := self;

  movable := true;
  reapear := false;
  iFraming := false;
  counter := 0;

end;

function RectangleContains(r1, r2: TRectangle): Boolean;
begin
  
  if (
    ((r2.x + r2.width) < (r1.x + r1.width)) 
    and (r2.x > r1.x) 
    and (r2.y > r1.y) 
    and ((r2.y + r2.height) < (r1.y + r1.height))
  ) then
    RectangleContains := true
  else RectangleContains := false;
end;

procedure GameCharacter.updateCollisionMask();
begin
  
  collisionMask.x := cPosition.x + (size / 2) - collisionSize / 2 + collisionOffset.x;
  collisionMask.y := cPosition.y + (size / 2) - collisionSize / 2 + collisionOffset.y;
end;

procedure GameCharacter.moveInDirection(x, y: Real; coll: Boolean);
var
  nextPosition: TRectangle;
begin

  nextPosition := RectangleCreate(cPosition.x + x * cMovingSpeed, cPosition.y, size, size);

  (* Check for outside collision *)

  if coll then
  begin
    if RectangleContains(playingField, nextPosition) then
    begin
      cPosition.x := cPosition.x + x * cMovingSpeed;
      updateCollisionMask();  
    end;

    nextPosition := RectangleCreate(cPosition.x, cPosition.y + y * cMovingSpeed, size, size);
    if RectangleContains(playingField, nextPosition) then
    begin
      cPosition.y := cPosition.y + y * cMovingSpeed;
      updateCollisionMask();  
    end;    
  end
  else
  begin
    
    cPosition := PointCreate(
      cPosition.x + x,
      cPosition.y + y
    );
    updateCollisionMask();

  end;

end;

procedure GameCharacter.setPosition(x, y: Integer);
begin
  
  cPosition.x := x;
  cPosition.y := y;

  updateCollisionMask();

end;

function GameCharacter.getCollisionMask() : TRectangle;
begin
  
  getCollisionMask := collisionMask;
end;

procedure GameCharacter.focus();
begin
  cMovingSpeed := cOriginSpeed / 2.6;
end;

procedure GameCharacter.stopFocus();
begin
  cMovingSpeed := cOriginSpeed;
end;

function GetPlayerPosition() : Point;
begin
  GetPlayerPosition := player.Position;
end;

function GetPlayerCollision() : TRectangle;
begin
  GetPlayerCollision := player.Collision;
end;

function GetVectorMagnitude(p1, p2: Point) : Real;
var
  dx, dy: Real;
begin
  dx := p2.x - p1.x;
  dy := p2.y - p1.y;

  GetVectorMagnitude := sqrt((dx * dx) + (dy * dy));
end;

procedure GiveScore(amount: Integer);
begin
  player.Score := player.Score + amount;
end;

procedure HurtPlayer();
begin

  if player.movable then
  begin
        
    player.HP := player.HP - 1;
    player.movable := false;

    StartDeathEffect(GetPlayerPosition(), -1);
    player.Position := PointCreate(playingField.x + playingField.width / 2 - playerSize / 2, playingField.y + playingField.height + playerSize);

    player.reapear := true;
  end;

end;

function IsIFraming() : Boolean;
begin
  IsIFraming := player.iFraming;
end;

end.
