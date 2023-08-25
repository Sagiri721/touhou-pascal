program game;

{$mode objfpc}{$H+}

uses 
cmem,
Character,
raylib, input;

const
  screenWidth: Integer = 800;
  screenHeight: Integer = 600;

  playerSize: Byte = 64;
var

  showCollision: Boolean;
  player: GameCharacter;

  procedure getGraphics();
  begin

    player := GameCharacter.Create('Reimu', playerSize);

    player.setPosition(
      round(playingField.x + (playingField.width / 2) - (playerSize / 2)), 
      screenHeight - 100
    );

  end;

  procedure drawPlayer();
  var
    source: TRectangle; 
    dest: TRectangle;
  begin
    
    source := RectangleCreate(0,0, 32, 32);
    dest := RectangleCreate(player.Position.x, player.Position.y, playerSize, playerSize);

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

  showCollision := true;

  // Main game loop
  while not WindowShouldClose() do
    begin

      BeginDrawing();
        ClearBackground(BLACK);
        DrawRectangleRec(playingField, WHITE);

        (*Input update*)
        Update(player);
        drawPlayer();

        if showCollision then
        begin
          
          (* Draw the collision *)
          DrawRectangleRec(player.getCollisionMask(), RED);
        end;

      EndDrawing();
    end;

  CloseWindow();
end.
