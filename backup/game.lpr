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

  characterImage: TTexture;
  gameCharacter: GameCharacter;

  procedure getGraphics();
  begin

    characterImage := LoadTexture('resources/reimu.png');    
  end;

begin

  // Initialization
  InitWindow(screenWidth, screenHeight, 'Touhou pascal');
  SetTargetFPS(60);

  // Main game loop
  while not WindowShouldClose() do
    begin

      BeginDrawing();
        ClearBackground(BLACK);
      EndDrawing();
    end;

  CloseWindow();
end.
