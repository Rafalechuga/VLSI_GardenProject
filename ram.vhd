library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
--ram clkWr, clkRd, WrEn, dataIn, dataOut
entity ram is
port(   
	  clkWr   : in std_logic;
	  clkRd	 : in std_logic;
	  WrEN	 : in std_logic;
	  dataIn  : in integer range 0 to 9;
	  dataOut : out integer range 0 to 9

);
end entity;

architecture arq of ram is
	type matrix is array (0 to 1) of integer range 0 to 9;
	signal 	    memory : matrix;
	signal 	 dataInBuf : integer range 0 to 9;
	signal AddressWrite : integer range 0 to 9;
	signal  AddressRead : integer range 0 to 9;
	
begin
	--Acceso de escritura
	process (clkWr) begin
		if(clkWr'event and clkWr='1' and WrEn='1') then
					dataInBuf <= dataIn;
			memory( 0 ) <= dataInbuf;

		end if;
	end process;

	process(clkRd) begin
		if(clkRd'event and clkRd='1')then
			dataOut <= memory( 0 );
		end if;
	end process;
	
end architecture;