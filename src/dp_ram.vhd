--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for Simple Duap-Port, multi-clock RAM 
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;


ENTITY dp_ram IS
  generic (
    ADDR_WIDTH : integer := 6;
    NR_OF_WORDS : integer := 64
 );
   PORT
   (
      rdclock : IN   std_logic;
      wrclock : IN   std_logic;
      data   : IN   std_logic_vector(15 downto 0);
      wraddress: IN  std_logic_vector(ADDR_WIDTH-1 downto 0);
      rdaddress:  IN  std_logic_vector(ADDR_WIDTH-1 downto 0);
      wren     : IN   std_logic;
      rden     : IN std_logic;
      q      : OUT  std_logic_vector(15 downto 0)
   );
END dp_ram;

ARCHITECTURE rtl OF dp_ram IS
  type RAM is array (0 to NR_OF_WORDS-1) of std_logic_vector(15 downto 0);
  signal ram_block : RAM;
--  attribute ramstyle of rtl : architecture is "M9K, new_data";
BEGIN
   PROCESS (wrclock)
   BEGIN
      IF (wrclock'event AND wrclock = '1') THEN
         IF (wren = '1') THEN
            ram_block(to_integer(unsigned(wraddress))) <= data;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (rdclock)
   BEGIN
      IF (rdclock'event AND rdclock = '1') THEN
        IF (rden = '1') THEN
          q <= ram_block(to_integer(unsigned(rdaddress)));
        END IF;
      END IF;
   END PROCESS;

END rtl;
