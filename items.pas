unit Items;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Character, SysUtils, raylib, fgl;

type

  GameItem = class(TOBject)

    private
      id: Byte;
      sprite: TRectangle;
      iPosition: Point;
      iFollowing: Boolean;
      speed: Real;
      collision: TRectangle;
    
    public
      push, rotation, add: Real;
      deleteMe: Boolean;

      constructor Create(itemId: Byte; origin: Point); overload;

      procedure followPlayer();
      procedure Collect();

      property Position: Point read iPosition write iPosition;
      property Identifier: Byte read id write id;
      property Following: Boolean read iFollowing write iFollowing;
  end;

  TItemList = specialize TFPGObjectList<GameItem>;

const

  spriteImageSize: Integer = 16;
  MAX_POINT_VALUE: Integer = 10000;

var 
  ItemSprites: array[0..4] of TRectangle;
  itemImage: TTexture;

  itemManager: TItemList;

  procedure loadItemSprites();
  procedure drawItems();
  procedure CreateItems(i, amount: Integer; origin: Point);

implementation

constructor GameItem.Create(itemId: Byte; origin: Point);
begin
  
  id := itemId;
  iPosition := origin;
  iFollowing := false;
  {writeln(FloatToStr(iPosition.x) + ' ' + FloatToStr(iPosition.y));}
  
  push := 0;
  add := -2;
  speed := 1.5;

  rotation := 0;
end;


procedure loadItemSprites();
var
  i: Integer;
begin

  itemManager := TItemList.Create;

  itemImage := LoadTexture('res/items.png');  
  for i := 0 to length(ItemSprites) - 1 do
  begin

    ItemSprites[i] := RectangleCreate(i * spriteImageSize, 0, spriteImageSize, spriteImageSize);
  end;

end;

procedure drawItems();
var
  i: Integer;
  playerPos: Point;
  magnitude: Real;
begin
  
  i := 0;
  while i < itemManager.Count do
  begin

    DrawTexturePro(
      itemImage,
      ItemSprites[itemManager[i].Identifier],
      RectangleCreate(itemManager[i].position.x, itemManager[i].position.y + itemManager[i].push, 18, 18),
      Vector2Create(8, 8),
      itemManager[i].rotation,
      WHITE
    );

    if not itemManager[i].Following then
    begin

      (* tick el animaciones *)
      itemManager[i].push += itemManager[i].add;

      itemManager[i].rotation += 10;
      if itemManager[i].add > 0 then itemManager[i].rotation := 0;
      if itemManager[i].push <= -70 then 
      begin
        itemManager[i].add := - itemManager[i].add;
      end;

      playerPos := GetPlayerPosition();
      magnitude := GetVectorMagnitude(playerPos, PointCreate(itemManager[i].position.x, itemManager[i].position.y + itemManager[i].push));

      //writeln(round(magnitude));

      if magnitude < playerGrabDistance then itemManager[i].Following := true;
    end
    else
      itemManager[i].followPlayer();

    (* Delete uncatched items *)

    if (itemManager[i].position.y > (playingField.y + playingField.height)) or itemManager[i].deleteMe then
    begin
      itemManager.Delete(i);
      i -= 1;
    end;

    i += 1;
  end;

end;

procedure CreateItems(i, amount: Integer; origin: Point);
var
  j: Integer;
  elitem: GameItem;
begin

  origin.x += 21;
  origin.y += 21;
  
  for j:= 0 to amount - 1 do
  begin
    elitem := GameItem.Create(i, origin);
    itemManager.add(elitem);
  end;
end;

procedure GameItem.followPlayer();
var
  player, dir: Point;
  normal: Real;
  playerCollision: TRectangle;
begin
  player := GetPlayerPosition();  
  normal := GetVectorMagnitude(PointCreate(player.x + playerSize / 2, player.y + playerSize / 2), PointCreate(iPosition.x, iPosition.y + push));

  dir := PointCreate((player.x + playerSize / 2 - iPosition.x) / normal, (player.y + playerSize / 2 - (iPosition.y + push)) / normal);

  iPosition.x += dir.x * speed;
  iPosition.y += dir.y * speed;

  playerCollision := GetPlayerCollision();
  collision := RectangleCreate(iPosition.x, iPosition.y + push, 18, 18);

  if CheckCollisionRecs(playerCollision, collision) then
  begin
    
    Collect();
    deleteMe := true;
  end;

end;

procedure GameItem.Collect();
var
  positionPercentage: Real;
begin
  
  case id of
    1:
    begin
      
      positionPercentage := 1 - (((GetPlayerPosition().y + playerSize / 2) - playingField.y) / playingField.height);
      GiveScore(round(MAX_POINT_VALUE * positionPercentage));

    end;
  end;
end;

end.

