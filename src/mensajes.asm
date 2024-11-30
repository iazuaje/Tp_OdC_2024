global mensajes

section .data 
    msjSeparador                db  "====================================",10,0
    msjTitulo                   db  "=            EL ASALTO             =",10,0
    msjInputFila                db  "Ingrese la fila de la pieza que desea mover: ", 0
    msjInputColumna             db  "Ingrese la columna de la pieza que desea mover: ", 0
    msjInputFilaDestino         db  "Ingrese la fila de la ubicacion a la que desea moverse: ", 0
    msjInputColumnaDestino      db  "Ingrese la columna de la ubicacion a la que desea moverse: ", 0
    msjInputError               db  "(ERROR) -- El valor ingresado es invalido, ingrese otro:", 10, 0
    msjJgSoldados               db  "Es el turno de los soldados (X):", 10, 0
    msjJgOficiales              db  "Es el turno de los oficiales (O):", 10, 0
    msjOrigenInvalido           db  "(ERROR) -- Coordenada invalida, ingrese otras coordenadas:",10,0
    msjGananSoldados            db  "Fin del Juego - Ganan los soldados",10,0
    msjGananOficiales           db  "Fin del Juego - Ganan los oficiales",10,0