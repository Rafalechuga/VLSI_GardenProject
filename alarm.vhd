LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--selector uM0, dM0, uH0, dH0, uM1, dM1, uH1, dH1, alarm
ENTITY alarm IS
PORT(
	uM0, dM0, uH0, dH0, uM1, dM1, uH1, dH1: INTEGER RANGE 0 TO 9;
	alarm: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE arq OF alarm IS
	
BEGIN 
	PROCESS( uM0, dM0, uH0, dH0, uM1, dM1, uH1, dH1 ) BEGIN
		IF( uM0 = uM1 AND dM0 = dM1 AND uH0 = uH1 AND dH0 = dH1 ) THEN
			alarm <= '1';
		ELSE
			alarm <= '0';
		END IF;
	END PROCESS;
		
		
END ARCHITECTURE;