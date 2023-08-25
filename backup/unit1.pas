unit Unit1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

implementation
type
  Character = class
          private

              cName: String;
              cMovingSpeed, cAttackRange, cAttackPower: Integer;
          public

            property Name: String read cName write cName;
  end;

  begin

    end.
