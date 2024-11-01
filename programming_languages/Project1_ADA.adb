-- A skeleton of an ADA program for an assignment in programming languages

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;





procedure Simulation is

-------------------------------------------------------GLOBAL VARIABLES---

   Number_Of_Chefs: constant Integer := 5;
   Number_Of_Assemblies: constant Integer := 3;
   Number_Of_McKlients: constant Integer := 2;
   Length_Of_Products_Name: constant Integer := 9;

   subtype Chef_Type is Integer range 1 .. Number_Of_Chefs;
   subtype McMeal_Type is Integer range 0 .. Number_Of_Assemblies;
   subtype McKlient_Type is Integer range 1 .. Number_Of_McKlients;

   Zamowienie0: Integer := 0;


   --each Chef is assigned a Product that it produces
   Product_Name: constant array (Chef_Type) of String(1 .. Length_Of_Products_Name)
     := ("BigMac   ", "McBurger ", "McCrispy ", "Shake    ", "McNuggets");

   --McMeal is a collection of products
   McMeal_Name: constant array (McMeal_Type) of String(1 .. 9)
     := ("Delivery ", "drivethru", "Mc_Meal  ", "happymeal");


-----------------------------------------------------TASK DECLARATIONS----

   -- Chef produces determined product
   task type Chef is
      entry Start(Product: in Chef_Type; Production_Time: in Integer);
   end Chef;

   -- McKlient gets an arbitrary McMeal of several products from the buffer
   -- but he/she orders it randomly
   task type McKlient is
      entry Start(McKlient_Number: in McKlient_Type;
                  Consumption_Time: in Integer);
   end McKlient;

   -- Buffer receives products from Chefs and delivers Assemblies to McKlients
   task type Buffer is
      -- Accept a product to the Kitchen (provided there is a room for it)
      entry Take(Product: in Chef_Type; Number: in Integer);
      -- Deliver an McMeal (provided there are enough products for it)
      entry Deliver(McMeal: in McMeal_Type; Number: out Integer);
      entry Impose_Embargo(Product: in Chef_Type; start: Boolean);
   end Buffer;

   P: array ( 1 .. Number_Of_Chefs ) of Chef;
   K: array ( 1 .. Number_Of_McKlients ) of McKlient;
   B: Buffer;


-----------------------------------------------------------TASK DEFINITIONS----

   --Chef--

   task body Chef is
      subtype Production_Time_Range is Integer range 1 .. 3;
      subtype embargo_risk_range is Integer range 1 .. 10;
      package Random_Production is new Ada.Numerics.Discrete_Random(Production_Time_Range);
      package Random_Embargo is new Ada.Numerics.Discrete_Random(embargo_risk_range);--do 6a
      --  random number generator
      G: Random_Production.Generator;
      E: Random_Embargo.Generator; --do 6a
      Chef_Type_Number: Integer;
      Product_Number: Integer;
      Production: Integer;
      Random_Time: Duration;
      Embargo_risk: Integer; ---6a
   begin
      accept Start(Product: in Chef_Type; Production_Time: in Integer) do
         --  start random number generator
         Random_Production.Reset(G);
         Product_Number := 1;
         Chef_Type_Number := Product;
         Production := Production_Time;
      end Start;
      Put_Line(ESC & "[93m" & "C: Chef of " & Product_Name(Chef_Type_Number) & " has came to work and Started cooking" & ESC & "[0m");
      loop

         Random_Time := Duration(Random_Production.Random(G));
         delay Random_Time;
         Embargo_risk := Random_Embargo.Random(E); ---6a
         Put_Line(ESC & "[93m" & "C: Chef has coocked " & Product_Name(Chef_Type_Number)
                  & " number "  & Integer'Image(Product_Number) & " embargo:  " & Integer'Image(Embargo_risk)& ESC & "[0m");
            --tu sie zaczyna 6b
         if Embargo_risk=10 then
            B.Impose_Embargo(Chef_Type_Number, true); --rozpoczecie embargo
            delay Duration(40);
            B.Impose_Embargo(Chef_Type_Number, false); --zakonczenie embargo
         else
             --ZADANIE 3B i 2 selektywne z budzikiem 4 zrównoważenie bufora lub dostaw
            select
               B.Take(Chef_Type_Number, Product_Number);
               Product_Number := Product_Number + 1;
            or
                 --Put_Line(ESC & "[93m" & "Too many products, wait 5s"  & ESC & "[0m");
               delay Duration(10);
            end select;
         end if;
      end loop;
   end Chef;

   --MCKLIENT
task body McKlient is
   subtype Consumption_Time_Range is Integer range 4 .. 8;
   package Random_Consumption is new
     Ada.Numerics.Discrete_Random(Consumption_Time_Range);

   -- Each McKlient takes any (random) McMeal from the Buffer
   package Random_McMeal is new
     Ada.Numerics.Discrete_Random(McMeal_Type);

   G: Random_Consumption.Generator;
   GA: Random_McMeal.Generator;
   McKlient_Nb: McKlient_Type;
   McMeal_Number: Integer;
   Consumption: Integer;
   McMeal_Type: Integer;
   Total_Wait_Time: Duration := 0.0; -- Track total wait time
   Reaction_Threshold: constant Duration := 15.0; -- Reaction threshold (2 seconds)
   McKlient_Name: constant array (1 .. Number_Of_McKlients)
     of String(1 .. 9)
     := ("McKlient1", "McKlient2");

begin
   accept Start(McKlient_Number: in McKlient_Type;
                Consumption_Time: in Integer) do
      Random_Consumption.Reset(G);
      Random_McMeal.Reset(GA);
      McKlient_Nb := McKlient_Number;
      Consumption := Consumption_Time;
   end Start;

   Put_Line(ESC & "[96m" & "Client: To the McDonald's, came " & McKlient_Name(McKlient_Nb) & ESC & "[0m");

   loop
      delay Duration(Random_Consumption.Random(G)); -- Simulate consumption time

      -- Keep generating random McMeals until a valid one is delivered
      loop
            Total_Wait_Time := Total_Wait_Time + 1.0;
            
            if Total_Wait_Time >= Reaction_Threshold then
               --ZAD 3.c gdy za dlugo czeka klient
            Put_Line(ESC & "[96m" & McKlient_Name(McKlient_Nb) & " says: HOW LONG I HAVE TO WAIT!" & ESC & "[0m");
            end if;
         --Put_Line(ESC & "[96m" & McKlient_Name(McKlient_Nb) & " has waited " & Duration'Image(Total_Wait_Time) & " seconds so far" & ESC & "[0m");

         McMeal_Type := Random_McMeal.Random(GA) ; -- Generate a random McMeal type

         -- Try to take a McMeal from the Buffer
         B.Deliver(McMeal_Type, McMeal_Number);

            --ZAD 3a - klient zamawia az /=0
         if McMeal_Type /= 0 then
            -- Valid McMeal is delivered
            Put_Line(ESC & "[96m" & McKlient_Name(McKlient_Nb) & " got " & McMeal_Name(McMeal_Type) & " with number " & Integer'Image(McMeal_Type) & ESC & "[0m");

               exit; -- Exit the loop as a valid meal has been delivered
         else
               -- Invalid McMeal (McMeal_Number = 0), generate another one
            Total_Wait_Time := Total_Wait_Time + 1.0;
            Put_Line(ESC & "[96m" & "Meal " & Integer'Image(McMeal_Number) &   ": " & McKlient_Name(McKlient_Nb) & " ordered " & McMeal_Name(McMeal_Type) & ", but the meal is wrong. Trying again." & ESC & "[0m");
            McMeal_Type := Random_McMeal.Random(GA) ;
               delay Duration(1.0); -- delay before reordering
         end if;
      end loop;
   end loop;
end McKlient;






   --Buffer--
   task body Buffer is
      Kitchen_Capacity: constant Integer := 30;
      Number_Of_Products_To_Remove: constant Integer := 15;
      type Kitchen_type is array (Chef_Type) of Integer;
      Kitchen: Kitchen_type
        := (0, 0, 0, 0, 0);
      McMeal_Content: array(McMeal_Type, Chef_Type) of Integer
        := ((0,0,0,0,0),(2, 1, 2, 0, 2),
            (1, 2, 0, 1, 0),
            (3, 2, 2, 0, 1));
      Max_McMeal_Content: array(Chef_Type) of Integer;
      McMeal_Number: array(McMeal_Type) of Integer
        := (1, 1, 1,1);
      In_Kitchen: Integer := 0;


      subtype Product_Range is Integer range 1 .. 5;
      package Random_Product is new Ada.Numerics.Discrete_Random(Product_Range);
      G: Random_Product.Generator;


      --4 a
      procedure Remove_Excess_Products is
         Product_To_Remove: Integer;
         Products_Removed: Integer := 0;
      begin
         Random_Product.Reset(G);
         Put_Line(ESC & "[91m" & "chef - overload ,mamma mia we need to wait 15s " & ESC & "[0m");

         while Products_Removed < Number_Of_Products_To_Remove loop
            -- Losowo wybieramy produkt do usuniecia
            Product_To_Remove := Random_Product.Random(G);


            if Kitchen(Product_To_Remove) > 0 then
               Kitchen(Product_To_Remove) := Kitchen(Product_To_Remove) - 1;
               In_Kitchen := In_Kitchen - 1;
               Products_Removed := Products_Removed + 1;

            end if;
         end loop;


      end Remove_Excess_Products;

      procedure Setup_Variables is
      begin
         for W in Chef_Type loop
            Max_McMeal_Content(W) := 0;
            for Z in McMeal_Type loop
               if McMeal_Content(Z, W) > Max_McMeal_Content(W) then
                  Max_McMeal_Content(W) := McMeal_Content(Z, W);
               end if;
            end loop;
         end loop;
      end Setup_Variables;

      function Can_Accept(Product: Chef_Type) return Boolean is
      begin
         if In_Kitchen >= Kitchen_Capacity then
            return False;
         else
            return True;
         end if;
      end Can_Accept;

      function Can_Deliver(McMeal: McMeal_Type) return Boolean is
      begin
         for W in Chef_Type loop
            if Kitchen(W) < McMeal_Content(McMeal, W) then
               return False;
            end if;
         end loop;
         return True;
      end Can_Deliver;

      procedure Kitchen_Contents is
      begin
         for W in Chef_Type loop
            Put_Line("|   kitchen supplies: " & Integer'Image(Kitchen(W)) & "  "& Product_Name(W));
         end loop;
         Put_Line("|   Number products in kitchen: " & Integer'Image(In_Kitchen));
      end Kitchen_Contents;

      ------ 5a ----
      function do_Embargo(Product: Chef_Type; start: Boolean) return Boolean is
      begin
         if start then
            Put_Line(ESC & "[93m" & "C: Embargo of: " & Product_Name(Product) & " has started, chef won't be able to cook it" & ESC & "[0m");
         else
            Put_Line(ESC & "[93m" & "C: Embargo of: " & Product_Name(Product) & " has ended, chef is now able to cook it" & ESC & "[0m");
         end if;
         return true;
      end do_Embargo;

   begin
      Put_Line(ESC & "[91m" & "B: Bufor started" & ESC & "[0m");
      Setup_Variables;

      loop
         select
            -- Przyjmowanie produktów od szefów kuchni
            accept Take(Product: in Chef_Type; Number: in Integer) do
               if Can_Accept(Product) then
                  Put_Line(ESC & "[91m" & "kitchen: take product " & Product_Name(Product) & " number " & Integer'Image(Number) & ESC & "[0m");
                  Kitchen(Product) := Kitchen(Product) + 1;
                  In_Kitchen := In_Kitchen + 1;

                  -- Sprawdzamy, czy kuchnia osiagnela maksymalna pojemnosc
                  if In_Kitchen >= Kitchen_Capacity then
                     -- Usuwanie 15 losowych produktow, jesli kuchnia jest pena
                     Remove_Excess_Products;
                  end if;
               else
                  Put_Line(ESC & "[91m" & "Kitchen: reject product  " & Product_Name(Product) & " number " &
                          Integer'Image(Number) & ESC & "[0m");
               end if;
            end Take;
         or
              -- Dostarczanie McZestawów do klientów
            accept Deliver(McMeal: in McMeal_Type; Number: out Integer) do
               if Can_Deliver(McMeal) then
                  Put_Line(ESC & "[91m" & "Kitchen: delivered  " & McMeal_Name(McMeal) & " number " &
                          Integer'Image(McMeal_Number(McMeal)) & ESC & "[0m");
                  for W in Chef_Type loop
                     Kitchen(W) := Kitchen(W) - McMeal_Content(McMeal, W);
                     In_Kitchen := In_Kitchen - McMeal_Content(McMeal, W);
                  end loop;
                  Number := McMeal_Number(McMeal);
                  McMeal_Number(McMeal) := McMeal_Number(McMeal) + 1;
               else
                  Put_Line(ESC & "[91m" & "kitchen: product is missing on  " & McMeal_Name(McMeal) & ESC & "[0m");
                  Number := 0;
               end if;
            end Deliver;
         or
            ----5b-----
            accept Impose_Embargo (Product : in Chef_Type; start: Boolean) do
               if do_Embargo(Product, start) then
                  null;
               end if;
            end Impose_Embargo;
         end select;
         -- Sprawdzanie aktualnej zawartosci kuchni
         Kitchen_Contents;
      end loop;
   end Buffer;



----------------------------------------------------"MAIN" FOR SIMULATION---
begin
   for I in 1 .. Number_Of_Chefs loop
      P(I).Start(I, 10);
   end loop;
   for J in 1 .. Number_Of_McKlients loop
      K(J).Start(J,12);
   end loop;
end Simulation;
