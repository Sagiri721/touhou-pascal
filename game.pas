program game;

{$mode objfpc}{$H+}

uses 
cmem,
Character,
raylib,
input,
SysUtils,
Bullet;

const
  screenWidth: Integer = 800;
  screenHeight: Integer = 600;
var

  showCollision: Boolean;
  player: GameCharacter;
  text: String;

  heart, star, logo: TTexture;
  i: Integer;

  procedure getGraphics();
  begin

    heart := LoadTexture('res/heart.png');
    star := LoadTexture('res/star.png');
    logo := LoadTexture('res/logo.png');

    player := GameCharacter.Create('Reimu', playerSize);

    player.setPosition(
      round(playingField.x + (playingField.width / 2) - (playerSize / 2)), 
      screenHeight - 100
    );

    loadBullet();

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

    DrawEllipse(round(dest.x + (dest.width / 2) - 30), round(dest.y + 10), 10, 10, RED);
    DrawEllipse(round(dest.x + (dest.width / 2) + 30), round(dest.y + 10), 10, 10, RED);
    
    DrawEllipse(round(dest.x + (dest.width / 2) - 30), round(dest.y + 40), 10, 10, RED);
    DrawEllipse(round(dest.x + (dest.width / 2) + 30), round(dest.y + 40), 10, 10, RED);
  end;

begin

  // Initialization
  InitWindow(screenWidth, screenHeight, 'Touhou pascal');
  SetTargetFPS(60);

  getGraphics();

  showCollision := false;

  // Main game loop
  while not WindowShouldClose() do
    begin

      BeginDrawing();
        ClearBackground(BLACK);
        DrawRectangleRec(playingField, BLUE);

        (*Input update*)
        Update(player, showCollision);
        drawBullets();
        drawPlayer();

        DrawText('HiScore  ', round(playingField.width + playingField.x + 20),  40, 20, WHITE);

        text := concat('Score  ', IntToStr(player.Score));
        DrawText(PChar(text), round(playingField.width + playingField.x + 20),  70, 20, WHITE);

        DrawText('Player  ', round(playingField.width + playingField.x + 20), 120, 20, WHITE);
        for i := 0 to player.HP-1 do DrawTexture(heart, 80 + round(playingField.width + playingField.x + 20) + (25 * i), 120, RED);
          
        DrawText('Bombs  ', round(playingField.width + playingField.x + 20), 150, 20, WHITE);
        for i := 0 to player.Bombs-1 do DrawTexture(star, 80 + round(playingField.width + playingField.x + 20) + (25 * i), 150, BLUE);

        DrawText(PChar('Power  ' + PChar(player.Power)), round(playingField.width + playingField.x + 20), 180, 20, WHITE);
        DrawTexture(logo, round(playingField.width + playingField.x + 20), 270, WHITE);

        if showCollision then
        begin
          
          (* Draw the collision *)
          DrawRectangleRec(player.getCollisionMask(), RED);
        end;

      EndDrawing();
    end;

  CloseWindow();
end.
