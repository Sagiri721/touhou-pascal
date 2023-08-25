unit Character;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib;

type
  GameCharacter = class(TOBject)
          private

              cName: String;
              cMovingSpeed, cAttackRange, cAttackPower: Integer;

              cPosition: TVector2;
              cSprite: TTexture;
          public

            property Name: String read cName write cName;          
            property Sprite: TTexture read cSprite write cSprite;
            property Position: TVector2 read cPosition write cPosition;

            constructor Create(n: String); overload;
  end;

implementation

constructor GameCharacter.Create(n: String);
begin
  
  cName := n;
  cPosition := Vector2Create(50, 50);

  (* Get the sprite image *)
  cSprite := LoadTexture('res/reimu.png');

end;

end.
