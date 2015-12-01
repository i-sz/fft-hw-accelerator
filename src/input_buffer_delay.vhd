--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for an input stream delayer 
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_buffer_delay is
  port(
    clk_i		: IN std_logic;
    rst_i		: IN std_logic;
    wr_i		  : IN STD_LOGIC;
    data_i		: in std_logic_vector(15 downto 0);
    wr_o		  : OUT STD_LOGIC;
    data_o		: OUT std_logic_vector(15 downto 0)
  );

end input_buffer_delay;

  architecture rtl of input_buffer_delay is

  signal wr_d, wr_dd : std_logic;
  signal data_d, data_dd : std_logic_vector(15 downto 0);

  begin

  two_stage_delay :  process(clk_i, rst_i) begin
    if (rst_i = '1') then
      wr_d <= '0';
      wr_dd <= '0';
      data_d <= (others => '0');
      data_dd <= (others => '0');
    elsif (clk_i'event and clk_i = '1') then
      wr_d <= wr_i;
      wr_dd <= wr_d;
      data_d <= data_i;
      data_dd <= data_d;
    end if;
  end process;

  wr_o <= wr_dd;
  data_o <= data_dd;

end rtl;
