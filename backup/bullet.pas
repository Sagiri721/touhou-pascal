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

      constructor Create(origin: GameCharacter); overload;
      procedure moveBullet();
      procedure retreat();
      procedure twitch();

      property Position: Point read bPosition write bPosition;
      property Color: TColorB read bColor write bColor;

  end;

  TBList = specialize TFPGObjectList<GameBullet>;

var 

  bulletSprite: TTexture;
  bulletManager: TBList;

  bulletCounter: Integer;

  procedure drawBullets();
  procedure loadBullet();
  procedure CreateBullet(player: GameCharacter);

implementation

constructor GameBullet.Create(origin: GameCharacter);
begin
  
  bOrigin := origin;
  bPosition := origin.Position;

  bPosition.x += playerSize / 3;

  bSpeed := 30;
  bAngle := 0;

  bDirection := -1;

  bPointer := bulletCounter;
  bColor := WHITE;

end;

procedure loadBullet();
begin
  
  bulletSprite := LoadTexture('res/bullet.png');
  bulletManager := TBList.Create;

  bulletCounter := 0;

end;

procedure CreateBullet(player: GameCharacter);
var
  newBullet: GameBullet;
begin
  
  newBullet := GameBullet.Create(player);
  bulletManager.Add(newBullet);

  bulletCounter += 1;

end;

procedure drawBullets();
var 
  i: Integer;
begin
  
  for i := 0 to bulletManager.Count - 1 do
  begin
    
    DrawTexture(bulletSprite, round(GameBullet(bulletManager[i]).Position.x), round(GameBullet(bulletManager[i]).Position.y), GameBullet(bulletManager[i]).Color);
    GameBullet(bulletManager[i]).moveBullet();

    if i>0 then 
    begin
      
      GameBullet(bulletManager[i-1]).twitch();
    end;

  end;

end;

procedure GameBullet.retreat();
begin
  bPointer -= 1;
end;

procedure GameBullet.moveBullet();
var
  i: Integer;
begin
  
  bPosition.x := bPosition.x + bAngle;
  bPosition.y := bPosition.y + bSpeed * bDirection;

  if(bPosition.y < 0) then
  begin
    
    for i := bPointer - 1 to bulletManager.Count - 1 do
    begin
      GameBullet(bulletManager[i]).retreat();
    end;
    bulletManager.Delete(bPointer);

  end;

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

