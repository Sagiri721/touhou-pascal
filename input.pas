unit input;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, raylib;

var
  LEFT: Integer = KEY_LEFT;
  RIGHT: Integer = KEY_RIGHT;
  UP: Integer = KEY_UP;
  DOWN: Integer = KEY_DOWN;

procedure Update(player: GameCharacter);

implementation

procedure Update(player: GameCharacter);
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

end;

end.

