unit Bullet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, raylib, fgl;

type 

  GameBullet = class(TOBject)

    private

      bPosition: Point;
      bSpeed: Real;
      bAngle: Real;
      bDirection: Integer;

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

  end;

  TBList = specialize TFPGObjectList<GameBullet>;
  TBulletPointerList = specialize TFPGList<Integer>;

var 

  bulletSprite: TTexture;
  bulletManager: TBList;

  procedure drawBullets();
  procedure loadBullet();
  procedure CreateBullet(var player: GameCharacter);

implementation

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
  
  bulletSprite := LoadTexture('res/bullet.png');
  bulletManager := TBList.Create;

end;

procedure CreateBullet(var player: GameCharacter);
var
  newBullet: GameBullet;
begin
  
  newBullet := GameBullet.Create(player);
  bulletManager.Add(newBullet);

end;

procedure drawBullets();
var 
  i: Integer;
  scheduleDeletion: Boolean;
begin
  
  i := 0;

  while i < bulletManager.Count do
  begin
    
    DrawTexture(bulletSprite, round(GameBullet(bulletManager[i]).Position.x), round(GameBullet(bulletManager[i]).Position.y), GameBullet(bulletManager[i]).Color);
    scheduleDeletion := GameBullet(bulletManager[i]).moveBullet();

    GameBullet(bulletManager[i]).twitch();
    if scheduleDeletion then 
    begin
    
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

