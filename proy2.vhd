LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PROY2 IS
PORT(
	s: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	cs: IN STD_LOGIC;
	clk: IN STD_LOGIC;
	servo: OUT STD_LOGIC;
	
	red					: out std_logic_vector (3 downto 0);
	green					: out std_logic_vector (3 downto 0);
	blue					: out std_logic_vector (3 downto 0);

	h_sync			: out std_logic;
	v_sync			: out std_logic
	
);
END ENTITY;

ARCHITECTURE arq OF PROY2 IS
	SIGNAL cSel: INTEGER RANGE -1 TO 3;
	--Reloj principal
	SIGNAL c1Hz: STD_LOGIC;
	SIGNAL cContDsp: INTEGER RANGE 0 TO 3;
	SIGNAL cSsg0, cSsg1: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL cDisp0: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL cUMin0, cDMin0,cUHor0, cDHor0: INTEGER;
	--Memoria
	SIGNAL cDir0, cDir1, cDir2, cDir3: INTEGER RANGE 0 TO 9;
	SIGNAL cDat0, cDat1, cDat2, cDat3: INTEGER RANGE 0 TO 9;
	SIGNAL cUMin1, cDMin1,cUHor1, cDHor1: INTEGER RANGE 0 TO 9;
	
	SIGNAL disp: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL ss7:  STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	
	SIGNAL alrm: STD_LOGIC;
	SIGNAL opn, cls: STD_LOGIC;
	
BEGIN 
	disp <= cDisp0;
	
	u0: ENTITY WORK.selector( arq ) PORT MAP( s, cDir0, cDir1, cDir2, cDir3, cSel );
	
	u1: ENTITY WORK.mainClock( arq ) PORT MAP( clk, cSsg0, cDisp0, c1Hz, cUMin0, cDmin0, cUHor0, cDHor0, cContDsp );
	
	u2: ENTITY WORK.romNum( arq ) PORT MAP( CDir0, cs, cDat0 );
	u3: ENTITY WORK.romNum( arq ) PORT MAP( CDir1, cs, cDat1 );
	u4: ENTITY WORK.romNum( arq ) PORT MAP( CDir2, cs, cDat2 );
	u5: ENTITY WORK.romNum( arq ) PORT MAP( CDir3, cs, cDat3 );
	
	u6: ENTITY WORK.ram( arq ) PORT MAP( c1Hz, c1Hz, cs, cDat0, cUmin1 );
	u7: ENTITY WORK.ram( arq ) PORT MAP( c1Hz, c1Hz, cs, cDat1, cDmin1 );
	u8: ENTITY WORK.ram( arq ) PORT MAP( c1Hz, c1Hz, cs, cDat2, cUHor1 );
	u9: ENTITY WORK.ram( arq ) PORT MAP( c1Hz, c1Hz, cs, cDat3, cDHor1 );
	
	u10: ENTITY WORK.conRam( arq ) PORT MAP( cUmin1, cDmin1, cUHor1, cDHor1, cContDsp, cSsg1 );
	u11: ENTITY WORK.alarm( arq )  PORT MAP( cUmin0, cDMin0, cUHor0, cDhor0, cUMin1, cDMin1, cUHor1, cDHor1, alrm);
	u12: ENTITY WORK.selSs7( arq ) PORT MAP( cSsg1, cSsg0, cSel, ss7 );
	
	u13: ENTITY WORK.monitor(arq) PORT MAP( clk, ss7, disp, s, alrm, red, green, blue, h_sync, v_sync );
	
	u14: ENTITY WORK.wateringTime( arq ) PORT MAP( c1Hz, alrm, cls, opn );
	u15: ENTITY WORK.servomotor( arq ) PORT MAP( clk, cls, opn, servo );
	
END ARCHITECTURE;

--selector s, uMin,dMin, uHor, dHor sOut
-- mainClock clk, ssg, disp, uMin, dMin, uHor, dHor
--romNum bus_dir, cs, bus_datos
--ram clkWr, clkRd, WrEn, dataIn, dataOut
--conRam d0, d1, d2, d3, contDisp, ss7
--alarm uM0, dM0, uH0, dH0, uM1, dM1, uH1, dH1, alarm
--selSs7 ss70, ss71, sel, ss7Out
-- wateringTime (clk, alrm, cls, opn)
-- servomotor clk, pi, pf
