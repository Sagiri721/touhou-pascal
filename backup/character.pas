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
              cMovingSpeed, cAttackRange, cAttackPower: Integer;

              cPosition: Point;
              cSprite: TTexture;

              collisionMask: TRectangle;
              size: Byte;

              procedure updateCollisionMask();

          public

            property Name: String read cName write cName;          
            property Sprite: TTexture read cSprite write cSprite;
            property Position: Point read cPosition write cPosition;

            constructor Create(n: String; s: Byte); overload;
            
            procedure moveInDirection(x, y: Integer);
            procedure setPosition(x, y: Integer);

            function getCollisionMask(): TRectangle;
  end;

const
  collisionSize: Integer = 10;
  collisionOffset: Point = (x: 0; y:10);

  playingField: TRectangle = (x: 35; y: 15; width: 400; height: 570);

implementation

constructor GameCharacter.Create(n: String; s: Byte);
begin
  
  cName := n;
  cPosition.x := 0;
  cPosition.y := 0;

  collisionMask := RectangleCreate(cPosition.x, cPosition.y, collisionSize, collisionSize);

  cMovingSpeed := 3;
  size := s;

  (* Get the sprite image *)
  cSprite := LoadTexture('res/reimu.png');

end;

procedure GameCharacter.updateCollisionMask();
begin
  
  collisionMask.x := cPosition.x + (size / 2) - collisionSize / 2 + collisionOffset.x;
  collisionMask.y := cPosition.y + (size / 2) - collisionSize / 2 + collisionOffset.y;
end;

procedure GameCharacter.moveInDirection(x, y: Integer);
var
  nextPosition: TRectangle;
begin

  nextPosition := RectangleCreate(cPosition.x + x * cMovingSpeed, cPosition.y + y * cMovingSpeed, size, size);
  DrawRectangleRec(nextPosition, BLUE);

  (* Check for outside collision *)

  if RectangleConatains(nextPosition, playingField) then
  begin
    
    cPosition.x := cPosition.x + x * cMovingSpeed;
    cPosition.y := cPosition.y + y * cMovingSpeed;

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

function RectangleConatains(r1, r2: TRectangle): Boolean;
begin
  
  if (
    ((r2.x + r2.width) < (r1.x + r1.width)) 
    and (r2.x > r1.x) 
    and (r2.y > r1.y) 
    and ((r2.y + r2.height) < (r1.y + r1.height))
  ) then
    RectangleConatains := true;
  else RectangleConatains := false;
end;

end.
