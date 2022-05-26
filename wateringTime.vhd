LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- wateringTime (clk, alrm, cls, opn)
ENTITY wateringTime IS
PORT(
	clk: IN STD_LOGIC;
	alrm: IN STD_LOGIC;
	cls: OUT STD_LOGIC;
	opn: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE arq OF wateringTime IS
	SIGNAL count: INTEGER RANGE 0 TO 3600 := 0;
BEGIN 
	PROCESS ( clk, alrm  ) BEGIN
		IF( RISING_EDGE( clk ) AND ( alrm = '1' OR count /= 0 ) ) THEN
			IF( count = 3600 ) THEN
				opn <= '0';
				cls <= '1';
				count <= 0;
			ELSE
				opn <= '1';
				cls <= '0';
				count <= count + 1;
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;