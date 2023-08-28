unit Enemy;

{$mode ObjFPC}{$H+}

interface

{
  ENEMY ID LIST
  1 -> Fairy enemy
}

uses
  Classes, SysUtils, raylib, fgl, Character, Bullet;

type

  GameEnemy = class(TOBject)

    private

      enemySprite: TTexture;
      id: Integer;
      hp, speed, waveIndex, eSize: Real;

      ePosition: Point;
      eTargetPosition, step: Point;

      eReached: Boolean;
      eCollisionMask: TRectangle;

      drawColor: TColorB;

    public

      constructor Create(i: Integer; target: Point); overload;

      procedure moveToTarget();
      procedure setTargetPosition(pos: Point);

      procedure wave();

      property Position: Point read ePosition write ePosition;
      property TargetPosition: Point read eTargetPosition write setTargetPosition;
      property Reached: Boolean read eReached write eReached;
      property Size: Real read eSize write eSize;
      property CollisionMask: TRectangle read eCollisionMask write eCollisionMask;
      property Color: TColorB read drawColor write drawColor;
    
  end;

  TEList = specialize TFPGObjectList<GameEnemy>;

var
  enemyManager: TEList;

  procedure CreateEnemy(id: Integer; targetPosition: Point);
  procedure DrawEnemies();

  function AssertEnemyCollision(bullet: GameBullet) : Boolean;

implementation

procedure CreateEnemy(id: Integer; targetPosition: Point);
var
  newEnemy: GameEnemy;
begin
  
  newEnemy := GameEnemy.Create(id, targetPosition);
  newEnemy.Color := WHITE;
  enemyManager.Add(newEnemy);

end;

constructor GameEnemy.Create(i: Integer; target: Point);
begin
  
  case i of
    1: begin

      enemySprite := LoadTexture('res/enemies/fairy.png');
      hp := 120;
      size := 1.3;
      
    end;
  end;

  setTargetPosition(target);

  if eTargetPosition.x < (playingField.x + playingField.width / 2) then 
  begin
    ePosition.x := 0;
    ePosition.y := 0;
  end
  else
  begin
    ePosition.x := playingField.x + playingField.width + 10;
    ePosition.y := 0;
  end;

  speed := 3;

  eCollisionMask := RectangleCreate(ePosition.x, ePosition.y, 32 * eSize, 32 * eSize);
end;

procedure DrawEnemies();
var
  i: Integer;
begin
  
  for i := 0 to enemyManager.Count - 1 do
  begin

    DrawTextureEx(enemyManager[i].enemySprite, Vector2Create(enemyManager[i].position.x, enemyManager[i].position.y), 0, enemyManager[i].Size
    , enemyManager[i].Color);

    if enemyManager[i].Color.a = 100 then 
    begin
      
      enemyManager[i].Color := ColorCreate(enemyManager[i].Color.r, enemyManager[i].Color.g, enemyManager[i].Color.b, 255);
    end;

    enemyManager[i].wave();
    if not enemyManager[i].reached then enemyManager[i].moveToTarget();

  end;

end;

procedure GameEnemy.setTargetPosition(pos: Point);
var 
  magnitude: Real;
begin
  
  eTargetPosition := pos;
  
  magnitude := sqrt((pos.x - ePosition.x)*(pos.x - ePosition.x) + (pos.y - ePosition.y)*(pos.y - ePosition.y));
  
  step.x := (pos.x - ePosition.x) / magnitude;
  step.y := (pos.y - ePosition.y) / magnitude;

  if magnitude < 2 then eReached := true;

end;

procedure GameEnemy.moveToTarget();
begin
  
  ePosition.x += step.x * speed;
  ePosition.y += step.y * speed;
  
  eCollisionMask.x := ePosition.x;
  eCollisionMask.y := ePosition.y;

  setTargetPosition(eTargetPosition);

end;

procedure GameEnemy.wave();
begin
  
  ePosition.y += sin(waveIndex);
  waveIndex += 0.07;

  if waveIndex >= 2 * Pi then waveIndex := 0;

end;

function AssertEnemyCollision(bullet: GameBullet) : Boolean;
var 
  i: Integer;
  bulletMask: TRectangle;
  res: Boolean;
begin
  
  res := false;
  bulletMask := RectangleCreate(bullet.Position.x, bullet.Position.y, 16, 16);

  for i:= 0 to enemyManager.Count - 1 do
  begin
    
    if CheckCollisionRecs(bulletMask, enemyManager[i].collisionMask) then
    begin
      
      res := true;
      if enemyManager[i].Color.a = 255 then enemyManager[i].Color := ColorCreate(enemyManager[i].Color.r, enemyManager[i].Color.g, enemyManager[i].Color.b, 100);
      break;
    end;
  end;

  AssertEnemyCollision := res;
end;

end.

