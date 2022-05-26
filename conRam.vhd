LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--conRam d0, d1, d2, d3, contDisp, ss7
ENTITY conRam IS
PORT(
	d0,d1,d2,d3: IN INTEGER RANGE 0 TO 9;
	contDisp: IN INTEGER RANGE 0 TO 3;
	ss7: OUT STD_LOGIC_VECTOR( 6 DOWNTO 0 )
);
END ENTITY;

ARCHITECTURE arq OF conRam IS
	SIGNAL midSs7: INTEGER RANGE 0 TO 9;
BEGIN 
	WITH contDisp SELECT midSs7<=
	d0 WHEN 0,
	d1 WHEN 1,
	d2 WHEN 2,
	d3 WHEN 3,
	d0 WHEN OTHERS;
	
	WITH midSs7 SELECT ss7 <=
	"0111111" when 0,
	"0000110" when 1,
	"1011011" when 2,
	"1001111" when 3,
	"1100110" When 4,
	"1101101" When 5,
	"1111101" When 6,
	"0000111" When 7,
	"1111111" When 8,
	"1100111" When 9,
	"1000000" When others;
		
		
END ARCHITECTURE;