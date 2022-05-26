LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- mainClock clk, ssg, disp, clk1Hz, uMin, dMin, uHor, dHor, contDisp
ENTITY mainClock IS
PORT(
	clk: IN STD_LOGIC;
	ssg: OUT STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	disp: OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	clk1Hz: OUT STD_LOGIC;
	uMin, dMin, uHor, dHor: OUT INTEGER;
	contDisp: OUT INTEGER RANGE 0 TO 3
);
END ENTITY;

ARCHITECTURE arq OF mainClock IS
	SIGNAL clkl, clkl480Hz: STD_LOGIC := '0';
	SIGNAL contador1: INTEGER RANGE 0 TO 25000000:=0;
	SIGNAL contador2: INTEGER RANGE 0 TO 2:=0;
	SIGNAL conteo0, conteo1, conteo2, conteo3, conteo4, conteo5, conteoDisp: INTEGER:= 0;
	SIGNAL bandera0, bandera1, bandera2, bandera3: STD_LOGIC := '0';
	
	SIGNAL salMux: INTEGER;
	
BEGIN
	uMin <= conteo1;
	dMin <= conteo2;
	uHor <= conteo3;
	dHor <= conteo4;

	clk1Hz <= clkl;
	contDisp <= conteoDisp;
	-------------------------
	--  Reloj contador 	----
	-------------------------
	PROCESS( clk )
	BEGIN
		IF( RISING_EDGE( clk ) ) THEN
			IF( contador1 = 25000 ) THEN
				contador1 <= 0;
				clkl <= NOT clkl; 
			ELSE
				contador1 <= contador1 +1;
			END IF;
		END IF;
	END PROCESS;
	
	-------------------------
	--  Reloj displays 	----
	-------------------------
	PROCESS( clk )
	BEGIN
		if clk'event and clk='1' then
			if( contador2 = 2 ) then
				contador2 <= 0;
				clkl480Hz <= not clkl480Hz;
			else	
				contador2 <= contador2 + 1;
			end if;
		end if;
	END PROCESS;
	----------------------------------
	--  Conteo Displays			 	----
	----------------------------------
	PROCESS( clkl480Hz )
	BEGIN
		IF( RISING_EDGE( clkl480Hz ) ) THEN
			IF( conteoDisp = 3 ) THEN
				conteoDisp <= 0;
			ELSE
				conteoDisp <= conteoDisp + 1;
			END IF;
		END IF;
	END PROCESS;
	----------------------------------
	--  Conteo Unidades Minutos 	----
	----------------------------------
	PROCESS( clkl )
	BEGIN
		IF( RISING_EDGE( clkl ) ) THEN
			IF( conteo0 = 60 ) THEN
				conteo0 <= 0;
				bandera0 <= '1';
			ELSE
				conteo0 <= conteo0 + 1;
				bandera0 <= '0';
			END IF;
		END IF;
	END PROCESS;
	----------------------------------
	--  Conteo Unidades Minutos 	----
	----------------------------------
	PROCESS( bandera0 )
	BEGIN
		IF( RISING_EDGE( bandera0 ) ) THEN
			IF( conteo1 = 9 ) THEN
				conteo1 <= 0;
				bandera1 <= '1';
			ELSE
				conteo1 <= conteo1 + 1;
				bandera1 <= '0';
			END IF;
		END IF;
	END PROCESS;
	----------------------------------
	--  Conteo Decenas Minutos 	----
	----------------------------------
	PROCESS( bandera1 )
	BEGIN
		IF( RISING_EDGE( bandera1 ) ) THEN
			IF( conteo2 = 5 ) THEN
				conteo2 <= 0;
				bandera2 <= '1';
			ELSE
				conteo2 <= conteo2 + 1;
				bandera2 <= '0';
			END IF;
		END IF;
	END PROCESS;
	----------------------------------
	--  Conteo Unidades Horas	 	----
	----------------------------------
	PROCESS( bandera2 )
	BEGIN
		IF( RISING_EDGE( bandera2 ) ) THEN
			IF( conteo5 = 21 ) THEN
				conteo5 <= 0;
				conteo3 <= 0;
				bandera3 <= '1';
			ELSE
				IF( conteo3 = 9 ) THEN
					conteo3 <= 0;
					bandera3 <= '1';
				ELSE
					conteo3 <= conteo3 + 1;
					conteo5 <= conteo5 + 1;
					bandera3 <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	----------------------------------
	--  Conteo Unidades Horas	 	----
	----------------------------------
	PROCESS( bandera3 )
	BEGIN
		IF( RISING_EDGE( bandera3 ) ) THEN
			IF( conteo4 = 2 ) THEN
				conteo4 <= 0;
			ELSE
				conteo4 <= conteo4 + 1;
			END IF;
		END IF;
	END PROCESS;
	-------------------------
	--  MUX 					----
	-------------------------
	WITH conteoDisp SELECT
	salMux <=
	conteo1 WHEN 0,
	conteo2 WHEN 1,
	conteo3 WHEN 2,
	conteo4 WHEN 3,
	10 WHEN OTHERS;
	-------------------------
	--  DEMUX 				----
	-------------------------
	WITH conteoDisp SELECT
	disp <=
	"0001" WHEN 0,
	"0010" WHEN 1,
	"0100" WHEN 2,
	"1000" WHEN 3,
	"0000" WHEN OTHERS;
	-------------------------
	--  Dsplay 				----
	-------------------------
	WITH salMux SELECT
	ssg <=
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