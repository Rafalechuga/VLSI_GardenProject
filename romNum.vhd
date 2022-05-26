LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--romNum bus_dir, cs, bus_datos
ENTITY romNum IS
PORT(
	bus_dir: IN INTEGER RANGE 0 TO 9;
	cs: IN STD_LOGIC;
	bus_datos: OUT INTEGER RANGE 0 TO 9
);
END ENTITY;

ARCHITECTURE arq OF romNum IS
	CONSTANT l0: INTEGER := 0;
	CONSTANT l1: INTEGER := 1;
	CONSTANT l2: INTEGER := 2;
	CONSTANT l3: INTEGER := 3;
	CONSTANT l4: INTEGER := 4;
	CONSTANT l5: INTEGER := 5;
	CONSTANT l6: INTEGER := 6;
	CONSTANT l7: INTEGER := 7;
	CONSTANT l8: INTEGER := 8;
	CONSTANT l9: INTEGER := 9;
	
	TYPE memoria IS ARRAY( 0 TO 9 ) OF INTEGER RANGE 0 TO 9;
	CONSTANT mem_rom: memoria :=( l0,l1, l2, l3, l4, l5, l6, l7, l8, l9 );
	
	SIGNAL dato: INTEGER RANGE 0 TO 9;
	
BEGIN 

	prom: PROCESS( bus_dir ) BEGIN 
		dato <= mem_rom( bus_dir  );
	
	END PROCESS prom;
	
	pbuf: PROCESS( dato, cs ) BEGIN
		IF( cs = '1' ) THEN
			bus_datos <= dato;
		ELSE
			bus_datos <= 0;
		END IF;
	END PROCESS pbuf;
	
END ARCHITECTURE;