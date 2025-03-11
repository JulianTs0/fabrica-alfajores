% Hechos

alfajor('MT', 'maicena tradicional', 250.0, 35000.0).
alfajor('TDL', 'triple de dulce de leche con glasé', 350.0, 48000.0).
alfajor('DDL', 'doble de dulce de leche con cobertura', 280.0, 32000.0).
alfajor('DM', 'doble de membrillo con glasé', 220.0, 25000.0).

ingredientes('A', 'Aceite vegetal').
ingredientes('D', 'Dulce de leche').
ingredientes('E', 'Endulzante').
ingredientes('F', 'Fécula de maíz').
ingredientes('V', 'Esencia de vainilla').

ciclo(1, 'MT', ['A', 'D', 'F'], fecha(10, 5, 2024), 320.0).
ciclo(2, 'TDL', [], fecha(10, 5, 2024), 300.0).
ciclo(3, 'DDL', [], fecha(12, 5, 2024), 480.0).
ciclo(4, 'DM', ['D', 'V'], fecha(12, 5, 2024), 310.0).
ciclo(5, 'MT', ['E', 'F'], fecha(13, 5, 2024), 180.0).
ciclo(6, 'TDL', ['D', 'E'], fecha(13, 5, 2024), 260.0).
ciclo(7, 'DDL', [], fecha(15, 5, 2024), 290.0).
ciclo(8, 'DM', [], fecha(15, 5, 2024), 420.0).
ciclo(9, 'MT', ['D', 'E', 'F'], fecha(16, 5, 2024), 330.0).
ciclo(10, 'TDL', ['A', 'D', 'E', 'V'], fecha(16, 5, 2024), 400.0).

%Reglas

% No sabemos si hay que usar el round para pasar a INT
regla1(Codigo,CantidadAlfajores):-ciclo(Codigo,CodigoAlfajor,_,_,CantKg),
                                  alfajor(CodigoAlfajor,_,Peso,_),
                                  CantidadParcial is (CantKg / (Peso / 1000)),
                                  CantidadAlfajores is round(CantidadParcial).

% Cuando el codigo es 5 muestra la variable Mes en vez de codigo
regla2(Codigo,Descripcion,Dia,Mes,CantidadAprox):-ciclo(Codigo,CodigoAlfajor,_,fecha(Dia,Mes,_),_),
                                                  alfajor(CodigoAlfajor,Descripcion,_,_),
                                                  regla1(Codigo,CantidadAprox).

regla3:-(
         (ciclo(_,_,Extras,_,_), length(Extras,Longitud), Longitud is 0);
         (regla1(_,CantidadAlfajores), CantidadAlfajores > 1500)
         ),!.

regla4(Codigo,Importe):-ciclo(Codigo,CodigoAlfajor,_,_,CantKg),alfajor(CodigoAlfajor,_,_,Precio),Importe is CantKg * Precio.

regla5(CodigoAlfajor,ImporteTotal):-findall(Importe,(ciclo(Codigo,CodigoAlfajor,_,_,_),regla4(Codigo,Importe)),ImporteAcumulado),
                                    sumlist(ImporteAcumulado,ImporteTotal).

regla6(ListaTuplas):-findall((Nombre,Ganancia),(alfajor(CodigoAlfajor,Nombre,_,_),regla5(CodigoAlfajor,Ganancia)),ListaTuplas).


