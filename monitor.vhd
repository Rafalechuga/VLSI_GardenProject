library ieee;
use ieee.std_logic_1164.all;
--monitor (input_clk, segments, dsp_ss, mode, alarm, red, green, blue, h_sync, v_sync)
entity monitor is
GENERIC(
	h_pulse  :  INTEGER   := 96;   --horiztonal sync pulse width in pixels
   h_bp     :  INTEGER   := 48;   --horiztonal back porch width in pixels
   h_pixels :  INTEGER   := 640;  --horiztonal display width in pixels
   h_fp     :  INTEGER   := 16;   --horiztonal front porch width in pixels
   h_pol    :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
   v_pulse  :  INTEGER   := 2;     --vertical sync pulse width in rows
   v_bp     :  INTEGER   := 33;    --vertical back porch width in rows
   v_pixels :  INTEGER   := 480;  --vertical display width in rows
   v_fp     :  INTEGER   := 10;     --vertical front porch width in rows
   v_pol    :  STD_LOGIC := '0';
	
	pixels_y :  INTEGER := 478;   --row that first color will persist until
   pixels_x :  INTEGER := 600  --column that first color will persist until
);
port(
	input_clk		:  in std_logic;  --for this example is 50MHz
	segments			:	in std_logic_vector( 0 to 6 );
	dsp_ss			: 	in std_logic_vector( 3 DOWNTO 0 );
	mode				: 	in std_logic_vector( 1 DOWNTO 0 );
	alarm				: 	in std_logic;

	red					: out std_logic_vector (3 downto 0);
	green					: out std_logic_vector (3 downto 0);
	blue					: out std_logic_vector (3 downto 0);

	h_sync			: out std_logic;
	v_sync			: out std_logic

 );
end;

architecture arq of monitor is
	signal pix_clk 	:STD_LOGIC:= '0';
	signal disp_ena  	:STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
	signal column    	:INTEGER;    --horizontal pixel coordinate
	signal row       	:INTEGER;    --vertical pixel coordinate
	signal reset_n		:std_logic:='1';
	signal cs			:std_logic;
	
	CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  
	CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;

	
begin

	process (input_clk)
	begin
		if input_clk'event and input_clk='1' then
			pix_clk <= not pix_clk;
		end if;
	end process;
	
	PROCESS(pix_clk, reset_n)
    VARIABLE h_count  :  INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
    VARIABLE v_count  :  INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
  BEGIN
  
    IF(reset_n = '0') THEN  --reset asserted
      h_count := 0;         --reset horizontal counter
      v_count := 0;         --reset vertical counter
      h_sync <= h_pol;		 --deassert horizontal sync
      v_sync <= v_pol;	  	 --deassert vertical sync
      disp_ena <= '0';      --disable display
      column <= 0;          --reset column pixel coordinate
      row <= 0;             --reset row pixel coordinate
      
    ELSIF(pix_clk'EVENT AND pix_clk = '1') THEN

      --counters
      IF(h_count < h_period - 1) THEN    --horizontal counter (pixels)
        h_count := h_count + 1;
      ELSE
        h_count := 0;
        IF(v_count < v_period - 1) THEN  --veritcal counter (rows)
          v_count := v_count + 1;
        ELSE
          v_count := 0;
        END IF;
      END IF;

      --horizontal sync signal
      IF(h_count < h_pixels + h_fp OR h_count > h_pixels + h_fp + h_pulse) THEN
        h_sync <= NOT h_pol;    --deassert horiztonal sync pulse
      ELSE
        h_sync <= h_pol;        --assert horiztonal sync pulse
      END IF;
      
      --vertical sync signal
      IF(v_count < v_pixels + v_fp OR v_count > v_pixels + v_fp + v_pulse) THEN
        v_sync <= NOT v_pol;    --deassert vertical sync pulse
      ELSE
        v_sync <= v_pol;        --assert vertical sync pulse
      END IF;
      
      --set pixel coordinates
      IF(h_count < h_pixels) THEN  --horiztonal display time
        column <= h_count;         --set horiztonal pixel coordinate
      END IF;
      IF(v_count < v_pixels) THEN  --vertical display time
        row <= v_count;            --set vertical pixel coordinate
      END IF;

      --set display enable output
      IF(h_count < h_pixels AND v_count < v_pixels) THEN  --display time
        disp_ena <= '1';                                  --enable display
      ELSE                                                --blanking time
        disp_ena <= '0';                                  --disable display
      END IF;
    END IF;
  END PROCESS;
  
  PROCESS(disp_ena, row, column) BEGIN

		IF(disp_ena = '1') THEN        --display time
			if( dsp_ss(3) = '1' ) then
				if    ((row > 210 and row <220) and (column>140 and column<170) and segments(6)='1') THEN -- segmento a
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>170 and column<180) and segments(5)='1') THEN --segmento b
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>170 and column<180) and segments(4)='1') THEN --segmento c
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 290 and row <300) and (column>140 and column<170) and segments(3)='1') THEN --segmento d
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>130 and column<140) and segments(2)='1') THEN --segmento e
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>130 and column<140) and segments(1)='1') THEN --segmento f
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 250 and row <260) and (column>140 and column<170) and segments(0)='1') THEN --segmento g
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				--- VISUALIZACI??N DE MODO
				elsif ((row > 100 and row <110) and (column>140 and column<170) and mode = "11" ) THEN
						red <= (OTHERS => '1'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '1');
				elsif ((row > 110 and row <140) and (column>150 and column<160) and mode = "11" ) THEN
						red <= (OTHERS => '1'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '1');
				elsif ((row > 100 and row <110) and (column>200 and column<230) and ( mode = "00" OR mode = "01" OR mode = "10") ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '1');
				elsif ((row > 110 and row <140) and (column>200 and column<210) and ( mode = "00" OR mode = "01" OR mode = "10") ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '1');
				elsif ((row > 110 and row <140) and (column>220 and column<230) and ( mode = "00" OR mode = "01" OR mode = "10") ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '1');
				elsif ((row > 120 and row <130) and (column>210 and column<220) and ( mode = "00" OR mode = "01" OR mode = "10") ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '1');
				-- VISUALIZACION DE ALARMA
				elsif ((row > 100 and row <140) and (column>340 and column<370) and alarm = '1' ) THEN
						red <= (OTHERS => '1'); 
						green	<= (OTHERS => '1');
						blue <= (OTHERS => '0');
				-- VISUALIZACION DE PUNTOS HORA
				elsif ((row > 230 and row <240) and (column>250 and column<260) ) THEN
						red <= (OTHERS => '1'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '0');
				elsif ((row > 270 and row <280) and (column>250 and column<260) ) THEN
						red <= (OTHERS => '1'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '0');
				-- VISUALIZACION MARCOS
				elsif ((row > 70 and row < 90) and (column>120 and column< 390) ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '1');
						blue <= (OTHERS => '0');
				elsif ((row > 310 and row <330) and (column>120 and column< 390) ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '1');
						blue <= (OTHERS => '0');
				elsif ((row > 70 and row < 330) and (column>100 and column< 120) ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '1');
						blue <= (OTHERS => '0');
				elsif ((row > 70 and row < 330) and (column>390 and column< 410) ) THEN
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '1');
						blue <= (OTHERS => '0');
				else		
						red <= (OTHERS => '0');  --es el fondo
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '0');
				end if;
			elsif( dsp_ss(2) = '1' ) THEN
				if    ((row > 210 and row <220) and (column>200 and column<230) and segments(6)='1') THEN -- segmento a
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>230 and column<240) and segments(5)='1') THEN --segmento b
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>230 and column<240) and segments(4)='1') THEN --segmento c
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 290 and row <300) and (column>200 and column<230) and segments(3)='1') THEN --segmento d
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>190 and column<200) and segments(2)='1') THEN --segmento e
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>190 and column<200) and segments(1)='1') THEN --segmento f
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 250 and row <260) and (column>200 and column<230) and segments(0)='1') THEN --segmento g
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				else		
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '0');
				end if;
			elsif( dsp_ss(1) = '1' ) then
				if    ((row > 210 and row <220) and (column>280 and column<310) and segments(6)='1') THEN -- segmento a
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>310 and column<320) and segments(5)='1') THEN --segmento b
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>310 and column<320) and segments(4)='1') THEN --segmento c
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 290 and row <300) and (column>280 and column<310) and segments(3)='1') THEN --segmento d
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>270 and column<280) and segments(2)='1') THEN --segmento e
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>270 and column<280) and segments(1)='1') THEN --segmento f
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 250 and row <260) and (column>280 and column<310) and segments(0)='1') THEN --segmento g
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				else		
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '0');
				end if;
			elsif( dsp_ss(0) = '1' ) then			
				if    ((row > 210 and row <220) and (column>340 and column<370) and segments(6)='1') THEN -- segmento a
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>370 and column<380) and segments(5)='1') THEN --segmento b
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>370 and column<380) and segments(4)='1') THEN --segmento c
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 290 and row <300) and (column>340 and column<370) and segments(3)='1') THEN --segmento d
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 260 and row <290) and (column>330 and column<340) and segments(2)='1') THEN --segmento e
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 220 and row <250) and (column>330 and column<340) and segments(1)='1') THEN --segmento f
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				elsif ((row > 250 and row <260) and (column>340 and column<370) and segments(0)='1') THEN --segmento g
						red <= (OTHERS => '1');
						green<=(OTHERS => '0');
						blue<=(OTHERS => '0');
				else		
						red <= (OTHERS => '0'); 
						green	<= (OTHERS => '0');
						blue <= (OTHERS => '0');
				end if;
			end if;
		END IF;  --del enable
  
  END PROCESS;

end architecture;