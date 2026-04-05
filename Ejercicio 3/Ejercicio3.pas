program Ejercicio3;
const fin = 'fin';
type
	empleado = record
		num, edad, dni: integer;
		ape, nom: string[30];
		end;
	empleados = file of empleado;
	
procedure leerEmp(var e:empleado);
begin
	write('Ingresar apellido: ');
	readln(e.ape);
	if (e.ape <> 'fin') then begin
		write('Ingresar nombre: ');
		readln(e.nom);
		write('Ingresar numero: ');
		readln(e.num);
		write('Ingresar edad: ');
		readln(e.edad);
		write('Ingresar DNI: ');
		readln(e.dni);
	end;
end;
	
procedure cargarArchivo(var emp:empleados);
var
	e: empleado;
	nom_fisico: string;
begin
	write('Ingresar nombre del archivo: ');
    readln(nom_fisico);
    assign(emp,nom_fisico);
	rewrite(emp);
	leerEmp(e);
	while (e.ape <> fin) do begin
		write(emp, e);
		leerEmp(e);
		end;
	close(emp);
end;

procedure mostrarMenu(var opc:integer; var termino:boolean);
begin
	writeln('- Marcar 0 para cerrar el programa -');
	writeln('- Marcar 1 para mostrar empleados con un apellido especifico -');
    writeln('- Marcar 2 para mostrar todos los empleados -');
    writeln('- Marcar 3 para mostrar empleados proximos a jubilarse -');
    writeln('- Marcar 4 para agregar un nuevo empleado al final del archivo -');
    writeln('- Marcar 5 para cambiar la edad de un empleado -');
    writeln('- Marcar 6 para exportar todos los datos de los empleados -');
    writeln('- Marcar 7 para exportar los datos de los empleados sin DNI -');
    readln(opc);
    if (opc = 0) then termino := true;
end;

procedure mostrarEmp(e: empleado);
begin
	write('Nombre y apellido: ',e.nom,' ',e.ape);
	write(', Numero: ',e.num);
	write(', Edad: ',e.edad);
	writeln(', DNI: ',e.dni);
end;

procedure mostrarArchivoUno(var emp:empleados; nom_fisico: string);
var
	e: empleado;
	ape_buscado: string;
	encontro: boolean;
begin
    write('Ingresar apellido a buscar: ');
    readln(ape_buscado);
    encontro := False;
    writeln('---- Datos de empleados con apellido: ',ape_buscado,' ----');
    writeln();
    reset(emp);
    while (not eof(emp)) do begin
		read(emp,e);
		if (e.ape = ape_buscado) then begin
			if (not encontro) then encontro := True;
			mostrarEmp(e);
		end;
	end;
	if (not encontro) then writeln('No se encontro empleados con ese apellido');
	close(emp);
	writeln();
end;

procedure mostrarArchivoDos(var emp:empleados; nom_fisico: string);
var
	e: empleado;
begin
    writeln('---- Datos de todos los empleados ----');;
    writeln();
    reset(emp);
    while (not eof(emp)) do begin
		read(emp,e);
		mostrarEmp(e);
		end;
	close(emp);
	writeln();
end;

procedure mostrarArchivoTres(var emp:empleados; nom_fisico: string);
var
	e: empleado;
begin
    writeln('---- Datos de todos los empleados proximos a jubilarse ----');
    writeln();
    reset(emp);
    while (not eof(emp)) do begin
		read(emp,e);
		if (e.edad > 70) then mostrarEmp(e);
		end;
	close(emp);
	writeln();
end;

procedure agregarEmpleado(var emp:empleados; nue:empleado);
var
	e: empleado;
	encontro: boolean;
begin
	encontro := false;
	reset(emp);
	while (not eof(emp)) and (not encontro) do begin
		read(emp, e);
		if (e.num = nue.num) then encontro := true;
		end;
	if (eof(emp)) then write(emp,nue)
	else writeln('Numero de empleado ya existente. No se completó la operación.');
	close(emp);
end;

procedure modificarEdad(var emp: empleados);
var
	e: empleado;
	encontro: boolean;
	num_emp, nue_edad: integer;
begin
	encontro := false;
	writeln('Ingresar empleado a modificar: ');
	readln(num_emp);
	reset(emp);
	while (not eof(emp)) and (not encontro) do begin
		read(emp, e);
		if (e.num = num_emp) then begin
			writeln('Edad original del empleado: ',e.edad);
			write('Ingresar nueva edad del empleado: ');
			readln(nue_edad);
			e.edad := nue_edad;
			seek(emp, filepos(emp) - 1);
			write(emp, e);
			writeln('Cambio completado con éxito.');
			encontro := true;
		end;
	end;
	close(emp);
	if (not encontro) then writeln('No se encontró el empleado buscado.');
end;

procedure exportarEmp(var emp:empleados);
var
	e: empleado;
	nom_fisico: string;
	txt:Text;
begin
	write('Ingresar nombre del archivo con extensión .txt: ');
	readln(nom_fisico);
	assign(txt, nom_fisico);
	reset(emp);
	rewrite(txt);
	while (not eof(emp)) do begin
		read(emp, e);
		writeln(txt, e.num,' ',e.edad,' ',e.dni,' ',e.ape,' ',e.nom);
		end;
	close(emp); close(txt);
end;

procedure exportarEmpSinDni(var emp:empleados);
var
	e: empleado;
	nom_fisico: string;
	txt:Text;
begin
	write('Ingresar nombre del archivo con extensión .txt: ');
	readln(nom_fisico);
	assign(txt, nom_fisico);
	reset(emp);
	rewrite(txt);
	while (not eof(emp)) do begin
		read(emp, e);
		if (e.dni = 0) then
			writeln(txt, e.num,' ',e.edad,' ',e.dni,' ',e.ape,' ',e.nom);
		end;
	close(emp); close(txt);
end;

var
	emp: empleados;
	nom_fisico: string;
	opcion: integer;
	termino: boolean;
	e: empleado;
begin
	cargarArchivo(emp);
	write('Ingresar nombre del archivo: ');
    readln(nom_fisico);
    assign(emp,nom_fisico);
   
    termino := false;
    mostrarMenu(opcion, termino);
    
    while (not termino) do begin
		case opcion of
			1:	mostrarArchivoUno(emp,nom_fisico);
			2: 	mostrarArchivoDos(emp,nom_fisico);
			3:	mostrarArchivoTres(emp,nom_fisico);
			4: 	begin 
				leerEmp(e); 
				agregarEmpleado(emp,e);
				end;
			5: 	modificarEdad(emp); 
			6: 	exportarEmp(emp);
			7:  exportarEmpSinDni(emp);
			end;
		mostrarMenu(opcion, termino);
		end;
end.
	
		

