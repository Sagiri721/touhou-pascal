unit input;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, Bullet, raylib;

var
  LEFT: Integer = KEY_LEFT;
  RIGHT: Integer = KEY_RIGHT;
  UP: Integer = KEY_UP;
  DOWN: Integer = KEY_DOWN;

  SHOOT: Integer = KEY_Z;

procedure Update(var player: GameCharacter; var showCollision: Boolean);

implementation

procedure Update(var player: GameCharacter; var showCollision: Boolean);
var
  moveX: Integer = 0;
  moveY: Integer = 0;
begin
  
  (* Movement check *)

  if IsKeyDown(LEFT) then moveX := moveX - 1;
  if IsKeyDown(RIGHT) then moveX := moveX + 1;

  if IsKeyDown(UP) then moveY := moveY - 1;
  if IsKeyDown(DOWN) then moveY := moveY + 1;

  (* Update player position *)
  player.moveInDirection(moveX, moveY);

  showCollision := IsKeyDown(KEY_LEFT_SHIFT);

  if IsKeyDown(SHOOT) then CreateBullet(player);

end;

end.

