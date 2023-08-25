program game;

{$mode objfpc}{$H+}

uses 
cmem,
Character,
raylib;

const
  screenWidth: Integer = 800;
  screenHeight: Integer = 600;
var

  player: GameCharacter;

  procedure getGraphics();
  begin

    player := GameCharacter.Create('Reimu');

  end;

  procedure drawPlayer();
  begin
    
    (* Draw the player sprite *)
    DrawTexture(
      player.Sprite,
      round(player.Position.x),
      round(player.Position.y),
      WHITE
    );
    
  end;

begin

  // Initialization
  InitWindow(screenWidth, screenHeight, 'Touhou pascal');
  SetTargetFPS(60);

  getGraphics();

  // Main game loop
  while not WindowShouldClose() do
    begin

      BeginDrawing();
        ClearBackground(BLACK);
        drawPlayer();
      EndDrawing();
    end;

  CloseWindow();
end.
