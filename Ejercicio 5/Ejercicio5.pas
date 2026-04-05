program Ejercicio4;

type
	celular = record
		cod: integer;
		nom: string[20];
		desc: string;
		marca: string[20];
		precio: real;
		stock_min: integer;
		stock_disp: integer;
		end;
	celulares = file of celular;
	
procedure menu(var opc:integer);
begin
	writeln();
	writeln('- Marcar 0 para cerrar el programa -');
	writeln('- Marcar 1 para crear un archivo no ordenado desde el archivo de texto -');
    writeln('- Marcar 2 para listar todos los elementos con stock menor al minimo -');
    writeln('- Marcar 3 para buscar todos los elementos con una descripcion especifica -');
    writeln('- Marcar 4 para exportar el archivo no ordenado a un archivo de texto -');
    writeln('- Marcar 5 para agregar un nuevo celular al archivo no ordenado -');
    writeln('- Marcar 6 para modificar el stock de un celular -');
    writeln('- Marcar 7 para exportar los celulares sin stock a un archivo de texto -');
    write('Ingresar un numero: ');
    readln(opc);
end;

procedure cargarArchivo;
var
	txt: Text;
	cel: celulares;
	nom_fisico: string;
	c: celular;
begin
	assign(txt, 'celulares.txt');
	write('Ingresar nombre del archivo en el que desea guardar los datos: ');
	readln(nom_fisico);
	assign(cel, nom_fisico);
	reset(txt);
	rewrite(cel);
	while (not eof(txt)) do begin 
		readln(txt, c.cod, c.precio, c.marca);
		readln(txt, c.stock_disp, c.stock_min, c.desc);
		readln(txt, c.nom);
		write(cel, c);
		end;
	close(txt); close(cel);
	writeln('Archivo cargado correctamente en "celulares.txt".');
end;

procedure mostrarCel(c:celular);
begin
	writeln('Nombre: ',c.nom);
	writeln('	Codigo: ',c.cod);
	writeln('	Descripcion: ',c.desc);
	writeln('	Marca: ',c.marca);
	writeln('	Precio: ',c.precio);
	writeln('	Stock Minimo: ',c.stock_min);
	writeln('	Stock Disponible: ',c.stock_disp);
end;

procedure listarMenorStock;
var
	cel: celulares;
	nom_fisico: string;
	c: celular;
begin
	write('Ingresar nombre del archivo que guarda todos los datos: ');
	readln(nom_fisico);
	assign(cel, nom_fisico);
	reset(cel);
	writeln('--- Listado de productos con stock menor al minimo ---');
	writeln();
	while (not eof(cel)) do begin
		read(cel, c);
		if (c.stock_disp < c.stock_min) then
			mostrarCel(c);
		end;
	close(cel);
	writeln('--- ---------------------------------------------- ---');
	writeln();
end;

procedure listarConDescripcion;
var
	cel: celulares;
	nom_fisico, descrip: string;
	c: celular;
begin
	write('Ingresar nombre del archivo que guarda todos los datos: ');
	readln(nom_fisico);
	assign(cel, nom_fisico);
	write('Ingresar descripcion a buscar: ');
	readln(descrip);
	reset(cel);
	writeln('--- Listado de productos con esa descripcion especifica ---');
	writeln();
	while (not eof(cel)) do begin
		read(cel, c);
		if (c.desc = descrip) then
			mostrarCel(c);
		end;
	close(cel);
	writeln('--- --------------------------------------------------- ---');
	writeln();
end;

procedure exportarArchivo;
var
	cel: celulares;
	nom_fisico: string;
	c: celular;
	txt: Text;
begin
	writeln('Se exportara a "celulares.txt"');
	write('Ingresar el nombre del archivo desde el que se cargan los datos: ');
	readln(nom_fisico);
	assign(cel, 'celulares.txt');
	assign(txt, nom_fisico);
	reset(cel);
	rewrite(txt);
	while (not eof(cel)) do begin
		read(cel, c);
		writeln(txt, c.cod,' ',c.precio,' ',c.marca);
		writeln(txt, c.stock_disp,' ',c.stock_min,' ',c.desc);
		writeln(txt, c.nom);
		end;
	close(cel); close(txt);
	writeln('Se exporto correctamente.');
end;
	
procedure leerCel(var c:celular);
begin
	write('Nombre: ');
	readln(c.nom);
	write('	Codigo: ');
	readln(c.cod);
	write('	Descripcion: ');
	readln(c.desc);
	write('	Marca: ');
	readln(c.marca);
	write('	Precio: ');
	readln(c.precio);
	write('	Stock Minimo: ');
	readln(c.stock_min);
	write('	Stock Disponible: ');
	readln(c.stock_disp);
end;
	
procedure agregarCel;
var
	cel: celulares;
	nom_fisico: string;
	c, nue: celular;
	encontro: boolean;
begin
	encontro := false;
	write('Ingresar el nombre del archivo desde el que se cargan los datos: ');
	readln(nom_fisico);
	assign(cel, nom_fisico);
	writeln('Ingresar los datos del celular a agregar: ');
	leerCel(nue);
	writeln();
	reset(cel);
	while (not eof(cel)) and (not encontro) do begin
		read(cel, c);
		if (c.nom = nue.nom) then encontro := true;
		end;
	if (encontro) then begin c.stock_disp := c.stock_disp + nue.stock_disp;
							seek(cel, filepos(cel) - 1);
							write(cel, c);
							writeln('El celular ya existe en el archivo. Se agrego el stock indicado al ya existente.');
							end
	else begin write(cel, nue);
			   writeln('Se agrego correctamente el celular nuevo.');
			   end;
	close(cel);
end;

procedure cambiarStock;
var		
	cel: celulares;
	nom_fisico, nom_a_buscar: string;
	c: celular;
	encontro: boolean;	
	nue_stock: integer;
begin
	encontro := false;
	write('Ingresar el nombre del archivo desde el que se cargan los datos: ');
	readln(nom_fisico);
	assign(cel, nom_fisico);
	write('Ingresar el nombre del celular a buscar: ');
	readln(nom_a_buscar);
	reset(cel);
	while (not eof(cel)) and (not encontro) do begin
		read(cel, c);
		if (c.nom = nom_a_buscar) then begin 
			encontro := true;
			writeln('El stock actual del producto es: ',c.stock_disp);
			write('Ingresar el nuevo stock del producto: ');
			readln(nue_stock);
			c.stock_disp := nue_stock;
			seek(cel, filepos(cel) - 1);
			write(cel, c);
			writeln();
			writeln('El stock fue modificado correctamente');
			end;
		end;
	if (not encontro) then writeln('Error: No se encontro el producto buscado.');
	close(cel);
end;
		
procedure exportarSinStock;
var
	cel: celulares;
	nom_fisico: string;
	c: celular;
	txt: Text;
begin
	writeln('Se exportara a "SinStock.txt"');
	write('Ingresar el nombre del archivo desde el que se cargan los datos: ');
	readln(nom_fisico);
	assign(cel, nom_fisico);
	assign(txt, 'SinStock.txt');
	reset(cel);
	rewrite(txt);
	while (not eof(cel)) do begin
		read(cel, c);
		if (c.stock_disp = 0) then begin
			writeln(txt, c.cod,' ',c.precio,' ',c.marca);
			writeln(txt, c.stock_disp,' ',c.stock_min,' ',c.desc);
			writeln(txt, c.nom);
			end;
		end;
	close(cel); close(txt);
	writeln('Se exporto correctamente.');
end;
		
var 
	opc: integer;
begin	
	repeat
		menu(opc);
		case opc of
			1: cargarArchivo;
			2: listarMenorStock;
			3: listarConDescripcion;
			4: exportarArchivo;
			5: agregarCel;
			6: cambiarStock;
			7: exportarSinStock;
			end;
	until (opc = 0)
end.
