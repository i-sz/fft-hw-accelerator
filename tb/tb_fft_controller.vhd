--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: Testebcnh for the fft_controller
--
--  Revision    : Check history on GitHub
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity tb_fft_controller is
end tb_fft_controller;



architecture testbench of tb_fft_controller is

  component fft_controller_top is
  port(
    rd_clk_i : in std_logic;
    wr_clk_i : in std_logic;
    rst_i: in std_logic;
    start_cmd_i : in std_logic;
    stop_cmd_i : in std_logic;
    wr_i : in std_logic;
    rd_i : in std_logic;
    rd_addr_i : in std_logic_vector(5 downto 0);
    result_o : out std_logic_vector (15 downto 0);
    m1_samples_i: in std_logic_vector(15 downto 0)
   );
 end component;

signal rd_clk_s, wr_clk_s, rst_s : std_logic;
signal start_cmd_s, stop_cmd_s, wr_s, rd_s : std_logic;
signal m1_samples_s, result_s : std_logic_vector(15 downto 0);
signal rd_addr_s : std_logic_vector (5 downto 0);

begin

DUT : fft_controller_top
port map(
  rd_clk_i => rd_clk_s,
  wr_clk_i => wr_clk_s,
  rst_i => rst_s,
  start_cmd_i => start_cmd_s,
  stop_cmd_i => stop_cmd_s,
  wr_i => wr_s,
  rd_i => rd_s,
  rd_addr_i => rd_addr_s,
  result_o => result_s,
  m1_samples_i => m1_samples_s
);



slow_clock :process
begin
		wr_clk_s <= '0';
        wait for 6250 ns;
		wr_clk_s <= '1';
        wait for 6250 ns;
end process slow_clock;

fast_clock :process
begin
		rd_clk_s <= '0';
        wait for 1 ns;
		rd_clk_s <= '1';
        wait for 1 ns;
end process fast_clock;

--process(wr_clk_s) begin
--  if start_cmd_s = '1' then
--    for i in 0 to 1024 loop
--      wr_s <='1';
--      m1_samples_s <="1111111111111111";
--    end loop;
--  end if;
--end process;

stimuli : process
begin

rst_s <= '1';
rd_s <= '0';
start_cmd_s <= '0';
stop_cmd_s <= '0';
rd_addr_s <= (others => '0');

wait for 12500ns;
 rst_s <= '1';

 wait for 12500ns;
 rst_s <= '0';

 wait for 100ns;
start_cmd_s <= '1';
--wr_s <= '1';
--m1_samples_s <="0000111100001111";

 wait for 2ms;
start_cmd_s <= '0';
stop_cmd_s <= '1';
 end process;


 -----------------------------------------------------------------------------------------------
-- Read input data from files
-----------------------------------------------------------------------------------------------
input_samples : process(wr_clk_s) is
  file r_file     : text open read_mode is "fft_64_real_input.txt";
  variable data_r : integer;
  variable rdata  : line;
begin
  if(rst_s = '1') then
    m1_samples_s  <= std_logic_vector(to_signed(0, 16));
--    wr_s <= '0';
  elsif rising_edge(wr_clk_s) then
    -- send in NUM_FRAMES_c of data or until the end of the file
    if not endfile(r_file) and (stop_cmd_s = '0') then
      if(start_cmd_s = '1') then
        readline(r_file, rdata);
        read(rdata, data_r);
        m1_samples_s  <= std_logic_vector(to_signed(data_r, 16));
--        wr_s <= '1';
      else
        m1_samples_s  <= m1_samples_s;
--        wr_s <= wr_s;
      end if;
    else
      m1_samples_s <= std_logic_vector(to_signed(0, 16));
--      wr_s <= '0';
    end if;
  end if;

end process input_samples;

write_enable : process(wr_clk_s)
begin
  if(rst_s = '1') then
      wr_s <= '0';
  elsif falling_edge(wr_clk_s) then
    if stop_cmd_s = '0' then
      if start_cmd_s = '1' then
        wr_s <= '1';
      else
        wr_s <= wr_s;
      end if;
    else
      wr_s <= '0';
    end if;
  end if;
end process write_enable;


end testbench;
