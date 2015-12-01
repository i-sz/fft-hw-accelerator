--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for Clock Domain Crossing
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CDC is
  port(
    clk_a : in std_logic;
    clk_b : in std_logic;
    rst_i : in std_logic;
    valid_i : in std_logic;
    valid_o : out std_logic
  );
end CDC;


architecture rtl of CDC is

signal reg_t_clk_a : std_logic;
signal reg_d1_clk_b, reg_d2_clk_b, reg_d3_clk_b : std_logic;
signal valid_s, valid_d : std_logic;

begin

--input T-register clk_a
process(clk_a, rst_i)
begin
  if (rst_i = '1') then
    reg_t_clk_a <= '0';
  elsif(clk_a'event and clk_a = '1') then
    if (valid_i = '1') then
      reg_t_clk_a <= not reg_t_clk_a;
    end if;
  end if;
end process;

--3 stage synchronizer
process(clk_b, rst_i)
begin
  if (rst_i = '1') then
    reg_d1_clk_b <= '0';
    reg_d2_clk_b <= '0';
    reg_d3_clk_b <= '0';
    valid_d <= '0';
  elsif(clk_b'event and clk_b = '1') then
      reg_d1_clk_b <= reg_t_clk_a;
      reg_d2_clk_b <= reg_d1_clk_b;
      reg_d3_clk_b <= reg_d2_clk_b;
      valid_d <= valid_s;
  end if;
end process;

valid_s <= reg_d2_clk_b xor reg_d3_clk_b;
valid_o <= valid_d;


end rtl;
