LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--selector s, uMin,dMin, uHor, dHor sOut
ENTITY selector IS
PORT(
	s: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	uMin,dMin,uHor,dHor: OUT INTEGER RANGE 0 TO 9;
	sOut: OUT INTEGER RANGE -1 TO 3
);
END ENTITY;

ARCHITECTURE arq OF selector IS
	SIGNAL sMid: INTEGER RANGE 0 TO 3:= 3;
BEGIN 
		sOut <= sMid;
		
		WITH s SELECT sMid <= 	
		0 	WHEN "00", --Programa riego 0 -> 06:00
		1 	WHEN "01", --Programa riego 1 -> 08:00
		2 	WHEN "10", --Programa riego 2 -> 10:00
		3 	WHEN "11", --Reloj Corriente
		3 WHEN OTHERS;
		-----------------------
		-- SET U. MINUTOS		--
		-----------------------
		WITH sMid SELECT uMin <=
		0 WHEN 0,
		0 WHEN 1,
		0 WHEN 2,
		0 WHEN OTHERS;
		
		-----------------------
		-- SET D. MINUTOS		--
		-----------------------
		WITH sMid SELECT dMin <=
		0 WHEN 0,
		0 WHEN 1,
		0 WHEN 2,
		0 WHEN OTHERS;
		
		-----------------------
		-- SET U. HORAS		--
		-----------------------
		WITH sMid SELECT uHor <=
		6 WHEN 0,
		8 WHEN 1,
		0 WHEN 2,
		0 WHEN OTHERS;
		
		-----------------------
		-- SET D. HORAS		--
		-----------------------
		WITH sMid SELECT dHor <=
		0 WHEN 0,
		0 WHEN 1,
		1 WHEN 2,
		0 WHEN OTHERS;
		
		
END ARCHITECTURE;