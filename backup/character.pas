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

              position: TVector2;
              sprite: TTexture;
          public

            property Name: String read cName write cName;          
            constructor Create(n: String); override;
  end;

implementation

constructor GameCharacter.Create(n: String);
begin
  
  cName = n;
  position = 
end;

end.
