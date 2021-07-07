unit SimplePascalSystem;

interface

type Text = PABCSystem.Text;

procedure Print(o: object);
procedure Println(o: object);
procedure Println(o1,o2: integer);
procedure Println;

implementation

uses System; 

procedure Print(o: object);
begin
  Console.Write(o);
end;

/// Вывести значение
procedure Println(o: object);
begin
  Console.WriteLine(o);
end;

procedure Println(o1,o2: integer);
begin
  Print(o1);
  Println(o2);
end;

procedure Println;
begin
  Console.WriteLine;
end;
 
end.