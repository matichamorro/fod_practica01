program Ejercicio2;

type
	enteros = file of integer;
	
function prom(total, cant: integer): real;
begin
	if (cant = 0) then prom := 0
	else prom := total / cant;
end;

var
	num_enteros: enteros;
	num, total, cant_total, cant_menores: integer;
	nom_fisico: string;
begin
	write('Ingresar nombre del archivo: ');
    readln(nom_fisico);
    
    assign(num_enteros,nom_fisico);
    reset(num_enteros);
    
    cant_total := 0;
    cant_menores := 0;
    total := 0;
    
    writeln('Archivo: ',nom_fisico);
    writeln();
    
    while (not eof(num_enteros)) do begin
		read(num_enteros, num);
		cant_total := cant_total + 1;
		if (num < 15000) then cant_menores := cant_menores + 1;
		total := total + num;
		writeln(num);
		end;
		
	writeln('Cantidad de numeros menores a 15000: ',cant_menores);
	writeln('Promedio de los numeros: ',prom(total, cant_total));
	readln();
end.
		
    
