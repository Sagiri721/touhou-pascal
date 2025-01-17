program game;

{$mode objfpc}{$H+}

uses 
cmem,
Character,
raylib,
input,
SysUtils;

const
  screenWidth: Integer = 800;
  screenHeight: Integer = 600;

  playerSize: Byte = 64;
var

  showCollision: Boolean;
  player: GameCharacter;
  text: String;

  heart: TTexture;
  i: Integer;

  procedure getGraphics();
  begin

    heart := LoadTexture('res/heart.png');
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

        DrawText('HiScore  ', round(playingField.width + playingField.x + 20),  40, 20, WHITE);

        text := concat('Score  ', IntToStr(player.Score));
        DrawText(PChar(text), round(playingField.width + playingField.x + 20),  70, 20, WHITE);

        DrawText('Player  ', round(playingField.width + playingField.x + 20), 120, 20, WHITE);
        for i := 0 to player.HP-1 do DrawTexture(heart, round(playingField.width + playingField.x + 20) + (37 * i), 120, WHITE);
          

        DrawText('Bombs  ', round(playingField.width + playingField.x + 20), 150, 20, WHITE);
        DrawText(PChar('Power  ' + PChar(player.Power)), round(playingField.width + playingField.x + 20), 180, 20, WHITE);

        if showCollision then
        begin
          
          (* Draw the collision *)
          DrawRectangleRec(player.getCollisionMask(), RED);
        end;

      EndDrawing();
    end;

  CloseWindow();
end.
