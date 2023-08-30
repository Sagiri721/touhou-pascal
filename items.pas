unit Items;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib;

type

  GameItem = class(TOBject)

    private
      id: Byte;
      sprite: TRectangle;
    
    public
      constructor Create(itemId: Byte); overload;
  end;

const

  spriteImageSize: Integer = 16;
var 
  ItemSprites: array[0..4] of TRectangle;
  itemImage: TTexture;

  procedure loadItemSprites();

implementation

constructor GameItem.Create(itemId: Byte);
begin
  
  id := itemId;
end;


procedure loadItemSprites();
var
  i: Integer;
begin

  itemImage := LoadTexture('res/items.png');  
  for i := 0 to length(ItemSprites) - 1 do
  begin

    ItemSprites[i] := RectangleCreate(i * spriteImageSize, 0, spriteImageSize, spriteImageSize);
  end;

end;
end.

