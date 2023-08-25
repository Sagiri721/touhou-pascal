program game;

{$mode objfpc}{$H+}

uses 
cmem,
Character,
raylib, input;

const
  screenWidth: Integer = 800;
  screenHeight: Integer = 600;

  playingField: TRectangle = (x: 35; y: 15; width: 400; height: 570);
var

  player: GameCharacter;

  procedure getGraphics();
  begin

    player := GameCharacter.Create('Reimu');

  end;

  procedure drawPlayer();
  var
    source: TRectangle; 
    dest: TRectangle;
  begin
    
    source := RectangleCreate(0,0, 32, 32);
    dest := RectangleCreate(player.Position.x, player.Position.y, 64, 64);

    (* Draw the player sprite *)
    DrawTexturePro(
      player.Sprite,
      source,
      dest,
      Vector2Create(0,0),
      0,
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
        DrawRectangle(playingField, WHITE);

        (*Input update*)
        Update(player);

        drawPlayer();
      EndDrawing();
    end;

  CloseWindow();
end.
