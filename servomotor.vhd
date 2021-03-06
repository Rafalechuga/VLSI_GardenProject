LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- servomotor clk, pi, pf, control
ENTITY servomotor IS
PORT(
	clk, pi, pf: IN STD_LOGIC;
	control: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE arq OF servomotor IS
	SIGNAL clkl: STD_LOGIC;
	SIGNAL contador: INTEGER RANGE 0 TO 2500:= 0;
	SIGNAL valor: INTEGER RANGE 0 TO 200;
	SIGNAL conteo: INTEGER RANGE 0 TO 200;
	SIGNAL duty: INTEGER RANGE 0 TO 200:=15;
BEGIN
	PROCESS( clk )BEGIN	
		IF( RISING_EDGE( clk ) ) THEN
			IF( contador = 2500) THEN	
				contador <= 0;
				clkl <= NOT clkl;
			ELSE
				contador <= contador + 1;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS( clkl, pi, pf, valor ) BEGIN
		IF( RISING_EDGE( clkl ) ) THEN	
			IF( pi = '1' ) THEN
				valor <= 5;
			ELSIF( pf = '1' ) THEN
				valor <= 24;
			END IF;
		END IF;
		duty <= valor;
	END PROCESS;
	
	PROCESS( clkl )BEGIN
		IF( RISING_EDGE( clkl ) ) THEN
			IF( conteo <= duty ) THEN
				control <= '1';
			ELSE
				control <= '0';
			END IF;
			
			IF( conteo = 200 ) THEN
				conteo <= 0;
			ELSE
				conteo <= conteo +	 1;
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;