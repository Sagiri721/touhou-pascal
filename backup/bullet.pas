unit Bullet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, raylib, fgl;

type 

  PTrail = ^Trail;
  Trail = record
    
    pos: Point;
    opacity: Real;
  end;

  GameBullet = class(TOBject)

    private

      bPosition: Point;
      bSpeed: Real;
      bAngle: Real;
      bDirection, bSide: Integer;

      bPointer: Integer;

      bOrigin: GameCharacter;
      bColor: TColorB;
      
    public

      constructor Create(var origin: GameCharacter); overload;
      function moveBullet() : Boolean;
      procedure retreat();
      procedure twitch();

      property Position: Point read bPosition write bPosition;
      property Color: TColorB read bColor write bColor;
      property Side: Integer read bSide write bSide;

  end;

  TBList = specialize TFPGObjectList<GameBullet>;
  TBulletPointerList = specialize TFPGList<Integer>;
  TTrailList = specialize TFPGList<PTrail>;

var 

  bulletSprite, shotTrail: TTexture;
  bulletManager: TBList;
  trailList: TTrailList;

  procedure drawBullets();
  procedure loadBullet();
  procedure CreateBullet(var player: GameCharacter; side: Integer);

implementation

uses Enemy;

constructor GameBullet.Create(var origin: GameCharacter);
begin
  
  bOrigin := origin;
  bPosition := origin.Position;

  bPosition.x += playerSize / 3;

  bSpeed := 30;
  bAngle := 0;

  bDirection := -1;

  bPointer := bulletManager.Count;
  bColor := WHITE;

end;

procedure loadBullet();
begin
  
  bulletSprite := LoadTexture('res/bullets/bullet.png');
  shotTrail := LoadTexture('res/bullets/shot-trail.png');

  bulletManager := TBList.Create;
  trailList := TTrailList.Create;

end;

procedure CreateBullet(var player: GameCharacter; side : Integer);
var
  newBullet: GameBullet;
begin
  
  newBullet := GameBullet.Create(player);
  newBullet.Side := side;

  bulletManager.Add(newBullet);

end;

procedure drawBullets();
var 
  i: Integer;
  scheduleDeletion: Boolean;
  leftTrail: Trail;
begin
  
  i := 0;

  for i := 0 to trailList.Count do
  begin
    
    DrawTexture(shotTrail, round(trailList[i]^.pos.x), round(trailList[i]^.pos.y), ColorCreate(255, 255, 255, round(255 * trailList[i]^.opacity)));
    trailList[i]^.opacity -= 0.1;
  end;

  while i < bulletManager.Count do
  begin
    
    DrawTexture(bulletSprite, round(bulletManager[i].Position.x), round(bulletManager[i].Position.y), bulletManager[i].Color);
    scheduleDeletion := bulletManager[i].moveBullet();

    bulletManager[i].twitch();
    (* Check for enemy collision *)
    if AssertEnemyCollision(bulletManager[i]) then scheduleDeletion := true;
    if scheduleDeletion then 
    begin
    
      leftTrail.pos := bulletManager[i].Position;
      leftTrail.opacity := 1;

      trailList.Add(^leftTrail);
      bulletManager.Delete(i);

      i -= 1;
    end;

    i += 1;    
  end;
end;

procedure GameBullet.retreat();
begin
  bPointer := bPointer - 1;
end;

function GameBullet.moveBullet() : Boolean;
var
  i: Integer;
begin
  
  bPosition.x := bPosition.x + bAngle;
  bPosition.y := bPosition.y + bSpeed * bDirection;

  if(bPosition.y < 10) then
  begin
    moveBullet := true;
  end
  else  moveBullet := false;

end;

procedure GameBullet.twitch();
begin
  
  if bColor.a = 255 then 
  begin
    bColor := ColorCreate(255, 255, 255, 100);
  end
  else bColor := WHITE;
end;

end.

