program Ejercicio;
const
     fin = 30000;
type
    enteros = file of integer;

var
   num_enteros: enteros;
   num: integer;
   nom_fisico: string;
begin
     write('Ingresar nombre del archivo: ');
     readln(nom_fisico);

     assign(num_enteros, nom_fisico);
     rewrite(num_enteros);

     write('Ingresar un numero entero: ');
     readln(num);
     while (num <> fin) do begin
           write(num_enteros, num);25
           write('Ingresar un numero entero: ');
           readln(num);
           end;
           
     close(num_enteros);
end.
