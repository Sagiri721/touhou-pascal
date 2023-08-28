unit Bullet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, raylib, fgl;

type 

  Trail = class(TOBject)
    
    private
      position: Point;
      op: Real;

    public 

      constructor Create(pos: Point); overload;
      property Pos: Point read position write position;
      property opacity: Real read op write op;

      procedure fade();
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
  TTrailList = specialize TFPGObjectList<Trail>;

var 

  bulletSprite, shotTrail: TTexture;
  bulletManager: TBList;
  trailList: TTrailList;

  procedure drawBullets();
  procedure loadBullet();
  procedure CreateBullet(var player: GameCharacter; side: Integer);

implementation

uses Enemy;

constructor Trail.Create(pos: Point);
begin
  
  position := pos;
  position.x += GetRandomValue(-16, 16);
  position.y -= 32;

  op := 1;
end;

procedure Trail.fade();
begin
  
  op -= 0.03;
end;

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
begin
  
  i := 0;

  while i < trailList.Count do
  begin
    
    DrawTextureEx(shotTrail, Vector2Create(trailList[i].pos.x, trailList[i].pos.y), 0, 2, ColorCreate(255, 255, 255, round(255 * trailList[i].opacity)));

    trailList[i].fade();
    trailList[i].pos.y -= 0.8;

    if(trailList[i].opacity <= 0) then
    begin
      trailList.Delete(i);
      i -= 1;
    end;

    i += 1;

  end;

  i := 0;

  while i < bulletManager.Count do
  begin
    
    DrawTexture(bulletSprite, round(bulletManager[i].Position.x), round(bulletManager[i].Position.y), bulletManager[i].Color);
    scheduleDeletion := bulletManager[i].moveBullet();

    bulletManager[i].twitch();
    (* Check for enemy collision *)
    if AssertEnemyCollision(bulletManager[i]) then 
    begin

      trailList.Add(Trail.Create(bulletManager[i].Position));
      scheduleDeletion := true;

    end;
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

