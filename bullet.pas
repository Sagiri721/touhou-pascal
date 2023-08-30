unit Bullet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, raylib, fgl, SpellCard;

type 

  Trail = class(TOBject)
    
    private
      position: Point;
      op: Real;
      tImage: TTexture;

    public 

      t: Integer;
      constructor Create(pos: Point); overload;
      
      property Pos: Point read position write position;
      property opacity: Real read op write op;
      property Image: TTexture read tImage write tImage;

      procedure fade(); virtual;
  end;

  DeathTrail = class(Trail)

    public
      size: Real;
      color: TColorB;
      varRotation: Real;
      
      constructor Create(elPosicion: Point; overlay: TColorB); overload;
      procedure fade; override;

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

      bDamage: Real;
      
    public

      constructor Create(var origin: GameCharacter); overload;
      constructor Create(origin: Point; speed, angle: Real); overload;

      function moveBullet() : Boolean;
      procedure retreat();
      procedure twitch();

      property Position: Point read bPosition write bPosition;
      property Color: TColorB read bColor write bColor;
      property Side: Integer read bSide write bSide;
      property Damage: Real read bDamage write bDamage;

  end;

  TBList = specialize TFPGObjectList<GameBullet>;
  TBulletPointerList = specialize TFPGList<Integer>;
  TTrailList = specialize TFPGObjectList<Trail>;

var 

  deathEffectColorsVariation: array[0..3] of TColor;
  bulletSprite, shotTrail, deathCircle: TTexture;
  bulletManager: TBList;
  trailList: TTrailList;

  hours, mins, secs, milliSecs : Word;

  procedure drawBullets();
  procedure loadBullet();
  
  procedure CreateBullet(var player: GameCharacter);
  procedure CreateBullet(var origin: Point; speed, angle: Real);

  procedure StartDeathEffect(position: Point);
  procedure resetRandomSeed();

implementation

uses Enemy;

constructor Trail.Create(pos: Point);
begin
  
  position := pos;
  position.x += GetRandomValue(-16, 16);
  position.y -= 32;

  tImage := shotTrail;

  op := 1;
  t := 0;
end;

constructor DeathTrail.Create(elPosicion: Point; overlay: TColorB);
begin
  
  position := elPosicion;
  tImage := deathCircle;

  op := 1;
  color := overlay;
  size := 0.1;

  t := 1;

  resetRandomSeed();
  varRotation := GetRandomValue(0, 360);
  
end;

procedure Trail.fade();
begin
  
  op -= 0.03;
  position.y -= 0.8;

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

  bDamage := 1;
  bSide := 0;

end;

constructor GameBullet.Create(origin: Point; speed, angle: Real);
begin
  
  bOrigin := nil;
  bPosition := origin;
  
  bSpeed := speed;
  bAngle := angle;
  bDirection := 1;

  bColor := RED;
  bDamage := 1;

  bSide := 1;

end;

procedure loadBullet();
begin
  
  bulletSprite := LoadTexture('res/bullets/bullet.png');
  shotTrail := LoadTexture('res/bullets/shot-trail.png');
  deathCircle := LoadTexture('res/enemies/death-circle.png');

  bulletManager := TBList.Create;
  trailList := TTrailList.Create;

  deathEffectColorsVariation[0] := RED;
  deathEffectColorsVariation[1] := GREEN;
  deathEffectColorsVariation[2] := BLUE;
  deathEffectColorsVariation[3] := YELLOW;

end;

procedure CreateBullet(var player: GameCharacter);
var
  newBullet: GameBullet;
begin
  
  newBullet := GameBullet.Create(player);
  bulletManager.Add(newBullet);

end;

procedure CreateBullet(var origin: Point; speed, angle: Real);
var
  newBullet: GameBullet;
begin
  
  newBullet := GameBullet.Create(origin, speed, angle);
  bulletManager.Add(newBullet);

end;

procedure drawBullets();
var 
  i: Integer;
  scheduleDeletion: Boolean;
  convert: DeathTrail;

begin
  
  i := 0;

  while i < trailList.Count do
  begin

    if trailList[i].t = 0 then
    begin
      
      DrawTextureEx(trailList[i].image, Vector2Create(trailList[i].pos.x, trailList[i].pos.y), 0, 2, ColorCreate(255, 255, 255, round(255 * trailList[i].opacity)));
    end
    else
    begin
      
      convert := DeathTrail(trailList[i]);
      DrawTexturePro(
        convert.image, 
        RectangleCreate(0,0,64,64),
        RectangleCreate(convert.pos.x, convert.pos.y, 64 * convert.size, 64 * convert.size),
        Vector2Create(32 * convert.size, 32 * convert.size),
        0, 
        ColorCreate(convert.color.r, convert.color.g, convert.color.b, round(255 * convert.opacity))
      );

      (* Draw variation circle *)

      DrawTexturePro(
        convert.image, 
        RectangleCreate(0,0,64,64),
        RectangleCreate(convert.pos.x, convert.pos.y, 64 * convert.size, 64),
        Vector2Create(32 * convert.size, 32),
        convert.varRotation, 
        ColorCreate(convert.color.r, convert.color.g, convert.color.b, round(255 * convert.opacity))
      );

    end;
    
    trailList[i].fade();

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
begin
  
  bPosition.x := bPosition.x + bAngle;
  bPosition.y := bPosition.y + bSpeed * bDirection;

  if (bPosition.y < 10) or (bPosition.y > (playingField.height + 16)) or (bPosition.x < playingField.x) or (bPosition.x > (playingField.x + playingField.width + 16)) then
  begin
    moveBullet := true;
  end
  else moveBullet := false;

end;

procedure GameBullet.twitch();
begin
  
  if bColor.a = 255 then 
  begin
    bColor := ColorCreate(bColor.r, bColor.g, bColor.b, 100);
  end
  else bColor := ColorCreate(bColor.r, bColor.g, bColor.b, 255);
end;

procedure DeathTrail.fade();
begin
  
  size += 0.2;
  op -= 0.04;
end;

procedure StartDeathEffect(position: Point);
var
  deathEffect: DeathTrail;
begin
  
  resetRandomSeed();
  deathEffect := DeathTrail.Create(position, deathEffectColorsVariation[GetRandomValue(0, length(deathEffectColorsVariation))]);
  deathEffect.pos := PointCreate(
    deathEffect.pos.x + 21,
    deathEffect.pos.y + 21
  );

  trailList.Add(deathEffect);

end;

procedure resetRandomSeed();
begin
  DecodeTime(now, hours, mins, secs, milliSecs);
  SetRandomSeed(milliSecs);
end;

end.

