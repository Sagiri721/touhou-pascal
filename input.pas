unit Input;

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
  if player.movable then 
  begin

    if IsKeyDown(LEFT) then moveX := moveX - 1;
    if IsKeyDown(RIGHT) then moveX := moveX + 1;

    if IsKeyDown(UP) then moveY := moveY - 1;
    if IsKeyDown(DOWN) then moveY := moveY + 1;

    (* Update player position *)
    player.moveInDirection(moveX, moveY, true);
    
    if IsKeyDown(SHOOT) then CreateBullet(player);
  end;

  showCollision := IsKeyDown(KEY_LEFT_SHIFT);
  if showCollision then
  begin
    player.focus();
  end else player.stopFocus();

  if player.reapear then
  begin
    
    writeln(round(player.Position.y));
    player.moveInDirection(0, -1, false);
    if player.Position.y < (playingField.y + playingField.height - playerSize * 2) then
    begin
      player.reapear := false;
      player.movable := true;

      player.iFraming := true;
    end;
  end;

end;

end.

