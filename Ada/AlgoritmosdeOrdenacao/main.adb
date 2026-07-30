with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   subtype Vetor is array (Positive range <>) of Integer;

   procedure Swap (A, B : in out Integer) is
      Temp : Integer := A;
   begin
      A := B;
      B := Temp;
   end Swap;

   procedure Bubble_Sort (V : in out Vetor) is
   begin
      for I in reverse V'First + 1 .. V'Last loop
         for J in V'First .. I - 1 loop
            if V (J) > V (J + 1) then
               Swap (V (J), V (J + 1));
            end if;
         end loop;
      end loop;
   end Bubble_Sort;

   procedure Selection_Sort (V : in out Vetor) is
      Min_Pos : Positive;
   begin
      for I in V'First .. V'Last - 1 loop
         Min_Pos := I;
         for J in I + 1 .. V'Last loop
            if V (J) < V (Min_Pos) then
               Min_Pos := J;
            end if;
         end loop;
         Swap (V (I), V (Min_Pos));
      end loop;
   end Selection_Sort;

   procedure Insertion_Sort (V : in out Vetor) is
      Key : Integer;
      J   : Integer;
   begin
      for I in V'First + 1 .. V'Last loop
         Key := V (I);
         J   := I - 1;
         while J >= V'First and then V (J) > Key loop
            V (J + 1) := V (J);
            J := J - 1;
         end loop;
         V (J + 1) := Key;
      end loop;
   end Insertion_Sort;

   procedure Merge (V : in out Vetor; Left, Mid, Right : Positive) is
      L : Vetor (Left .. Mid);
      R : Vetor (Mid + 1 .. Right);
      I, J, K : Positive;
   begin
      for C in Left .. Mid loop L (C) := V (C); end loop;
      for C in Mid + 1 .. Right loop R (C) := V (C); end loop;

      I := Left;
      J := Mid + 1;
      K := Left;
      while I <= Mid and then J <= Right loop
         if L (I) <= R (J) then
            V (K) := L (I); I := I + 1;
         else
            V (K) := R (J); J := J + 1;
         end if;
         K := K + 1;
      end loop;
      while I <= Mid loop V (K) := L (I); I := I + 1; K := K + 1; end loop;
      while J <= Right loop V (K) := R (J); J := J + 1; K := K + 1; end loop;
   end Merge;

   procedure Merge_Sort (V : in out Vetor; Left, Right : Positive) is
      Mid : Positive;
   begin
      if Left < Right then
         Mid := (Left + Right) / 2;
         Merge_Sort (V, Left, Mid);
         Merge_Sort (V, Mid + 1, Right);
         Merge (V, Left, Mid, Right);
      end if;
   end Merge_Sort;

   function Partition (V : in out Vetor; Low, High : Positive) return Positive is
      Pivot : Integer := V (High);
      I     : Integer := Low - 1;
   begin
      for J in Low .. High - 1 loop
         if V (J) < Pivot then
            I := I + 1;
            Swap (V (I), V (J));
         end if;
      end loop;
      Swap (V (I + 1), V (High));
      return I + 1;
   end Partition;

   procedure Quick_Sort (V : in out Vetor; Low, High : Positive) is
      Pi : Positive;
   begin
      if Low < High then
         Pi := Partition (V, Low, High);
         if Pi > Low then Quick_Sort (V, Low, Pi - 1); end if;
         Quick_Sort (V, Pi + 1, High);
      end if;
   end Quick_Sort;

   procedure Heapify (V : in out Vetor; N, I : Natural) is
      Largest : Natural := I;
      Left    : Natural := 2 * I + 1;
      Right   : Natural := 2 * I + 2;
   begin
      if Left < N and then V (V'First + Left) > V (V'First + Largest) then
         Largest := Left;
      end if;
      if Right < N and then V (V'First + Right) > V (V'First + Largest) then
         Largest := Right;
      end if;
      if Largest /= I then
         Swap (V (V'First + I), V (V'First + Largest));
         Heapify (V, N, Largest);
      end if;
   end Heapify;

   procedure Heap_Sort (V : in out Vetor) is
      N : Natural := V'Length;
   begin
      for I in reverse 0 .. N / 2 - 1 loop
         Heapify (V, N, I);
      end loop;
      for I in reverse 1 .. N - 1 loop
         Swap (V (V'First), V (V'First + I));
         Heapify (V, I, 0);
      end loop;
   end Heap_Sort;

   procedure Shell_Sort (V : in out Vetor) is
      N    : Natural := V'Length;
      Gap  : Natural := N / 2;
      J    : Natural;
      Temp : Integer;
   begin
      while Gap > 0 loop
         for I in V'First + Gap .. V'Last loop
            Temp := V (I);
            J := I;
            while J >= V'First + Gap and then V (J - Gap) > Temp loop
               V (J) := V (J - Gap);
               J := J - Gap;
            end loop;
            V (J) := Temp;
         end loop;
         Gap := Gap / 2;
      end loop;
   end Shell_Sort;

   procedure Counting_Sort (V : in out Vetor) is
      Max_Val : Integer := V (V'First);
      Idx     : Positive := V'First;
   begin
      for I in V'Range loop
         if V (I) > Max_Val then Max_Val := V (I); end if;
      end loop;
      declare
         Count : array (0 .. Max_Val) of Natural := (others => 0);
      begin
         for I in V'Range loop Count (V (I)) := Count (V (I)) + 1; end loop;
         for I in Count'Range loop
            while Count (I) > 0 loop
               V (Idx) := I;
               Idx := Idx + 1;
               Count (I) := Count (I) - 1;
            end loop;
         end loop;
      end;
   end Counting_Sort;

   procedure Radix_Sort (V : in out Vetor) is
      Max_Val : Integer := V (V'First);
      Exp     : Positive := 1;
   begin
      for I in V'Range loop
         if V (I) > Max_Val then Max_Val := V (I); end if;
      end loop;
      while Max_Val / Exp > 0 loop
         declare
            Output : Vetor (V'Range);
            Count  : array (0 .. 9) of Natural := (others => 0);
         begin
            for I in V'Range loop
               Count ((V (I) / Exp) mod 10) := Count ((V (I) / Exp) mod 10) + 1;
            end loop;
            for I in 1 .. 9 loop Count (I) := Count (I) + Count (I - 1); end loop;
            for I in reverse V'Range loop
               declare D : Natural := (V (I) / Exp) mod 10;
               begin
                  Output (V'First + Count (D) - 1) := V (I);
                  Count (D) := Count (D) - 1;
               end;
            end loop;
            for I in V'Range loop V (I) := Output (I); end loop;
         end;
         Exp := Exp * 10;
      end loop;
   end Radix_Sort;

   procedure Bucket_Sort (V : in out Vetor) is
      N      : constant Natural := V'Length;
      Max_Val : Integer := V (V'First);
      Min_Val : Integer := V (V'First);
   begin
      if N <= 0 then return; end if;
      for I in V'Range loop
         if V (I) > Max_Val then Max_Val := V (I); end if;
         if V (I) < Min_Val then Min_Val := V (I); end if;
      end loop;
      declare
         Bucket_Range : constant Natural := (Max_Val - Min_Val + 1 + 9) / 10;
         type Bucket_Data is array (0 .. 9) of Vetor (V'Range);
         Buckets  : Bucket_Data;
         B_Cnt    : array (0 .. 9) of Natural := (others => 0);
         Idx      : Positive := V'First;
      begin
         for I in V'Range loop
            declare B : Natural := (V (I) - Min_Val) / Bucket_Range;
            begin
               if B > 9 then B := 9; end if;
               B_Cnt (B) := B_Cnt (B) + 1;
               Buckets (B)(V'First + B_Cnt (B) - 1) := V (I);
            end;
         end loop;
         for B in 0 .. 9 loop
            if B_Cnt (B) > 0 then
               for I in 2 .. B_Cnt (B) loop
                  declare
                     Key : Integer := Buckets (B)(V'First + I - 1);
                     J   : Integer := I - 1;
                  begin
                     while J >= 1 and then Buckets (B)(V'First + J - 1) > Key loop
                        Buckets (B)(V'First + J) := Buckets (B)(V'First + J - 1);
                        J := J - 1;
                     end loop;
                     Buckets (B)(V'First + J) := Key;
                  end;
               end loop;
               for I in 1 .. B_Cnt (B) loop
                  V (Idx) := Buckets (B)(V'First + I - 1);
                  Idx := Idx + 1;
               end loop;
            end if;
         end loop;
      end;
   end Bucket_Sort;

   procedure Print_Array (V : Vetor) is
   begin
      for I in V'Range loop
         Put (V (I), Width => 1);
         Put (" ");
      end loop;
      New_Line;
   end Print_Array;

   Size  : Positive;
   Opcao : Integer;

   subtype Random_Range is Natural range 0 .. 999;
   package Random_Int is new Ada.Numerics.Discrete_Random (Random_Range);
   Gen : Random_Int.Generator;

   Vet : Vetor (1 .. 1);
begin
   Put_Line ("--- ALGORITMOS DE ORDENACAO (ADA) ---");
   Put ("Digite o tamanho do vetor: ");
   Get (Size);

   declare
      V : Vetor (1 .. Size);
   begin
      Random_Int.Reset (Gen);
      for I in 1 .. Size loop
         V (I) := Random_Int.Random (Gen);
      end loop;

      Put_Line ("Vetor original:");
      Print_Array (V);

      Put_Line ("1  - Bubble Sort");
      Put_Line ("2  - Selection Sort");
      Put_Line ("3  - Insertion Sort");
      Put_Line ("4  - Merge Sort");
      Put_Line ("5  - Quick Sort");
      Put_Line ("6  - Heap Sort");
      Put_Line ("7  - Shell Sort");
      Put_Line ("8  - Counting Sort");
      Put_Line ("9  - Radix Sort");
      Put_Line ("10 - Bucket Sort");
      Put_Line ("0  - Sair");
      Put ("Opcao: ");
      Get (Opcao);

      case Opcao is
         when 1 => Bubble_Sort (V);
         when 2 => Selection_Sort (V);
         when 3 => Insertion_Sort (V);
         when 4 => Merge_Sort (V, 1, Size);
         when 5 => Quick_Sort (V, 1, Size);
         when 6 => Heap_Sort (V);
         when 7 => Shell_Sort (V);
         when 8 => Counting_Sort (V);
         when 9 => Radix_Sort (V);
         when 10 => Bucket_Sort (V);
         when 0 => null;
         when others =>
            Put_Line ("Opcao invalida");
            return;
      end case;

      Put_Line ("Vetor ordenado:");
      Print_Array (V);
   end;
end Main;
