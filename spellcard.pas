unit SpellCard;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Character, raylib;

type 

  GameSpellCard = class(TOBject)

    private
      id: Byte;
      origin: Point;
      delay: Integer;
      counter: Integer;

    public

      constructor Create(sId: Byte; sOrigin: Point); overload;
      procedure Start();

  end;

implementation

uses Bullet, Enemy;

constructor GameSpellCard.Create(sId: Byte; sOrigin: Point);
begin

  id := sId;
  origin := sOrigin;

  origin.x := origin.x + 13;
  origin.y := origin.y + 13;

  delay := 8;
  counter := 0;
  
end;

procedure GameSpellCard.Start();
var
  player: Point;
  angle, c: Real;
begin

  case id of
    0:
    begin

      player := GetPlayerPosition();

      if counter > delay then
      begin
        
        resetRandomSeed();
        c := ((player.x - origin.x) / abs(player.y - origin.y)) * 7;
        CreateBullet(origin, 7, c + GetRandomValue(-3, 3));

        counter := 0;
      end;
    end;
  end;

 counter += 1;
end;

end.