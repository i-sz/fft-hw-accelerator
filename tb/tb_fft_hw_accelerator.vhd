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


entity tb_fft_hw_accelerator is
end tb_fft_hw_accelerator;

architecture testbench of tb_fft_hw_accelerator is

  component fft_hw_accelerator_top is
  port(
    rd_clk_i : in std_logic;
    rst_i: in std_logic;
  -- data stream interface
    wr_clk_i : in std_logic;
    wr_i : in std_logic;
    ch0_data_i : in std_logic_vector(15 downto 0);
  -- OCP IN (slave) for Patmos
    MCmd          : in  std_logic_vector(2 downto 0);
    MAddr         : in  std_logic_vector(15 downto 0);
    MData         : in  std_logic_vector(31 downto 0);
    MByteEn       : in  std_logic_vector(3 downto 0);
    SResp         : out std_logic_vector(1 downto 0);
    SData         : out std_logic_vector(31 downto 0)
   );
 end component;

signal rd_clk_s, wr_clk_s, rst_s, wr_s : std_logic;
signal start_cmd_s, stop_cmd_s, start_s, stop_s, read_status_s, read_buffer_s : std_logic;
signal m1_samples_s : std_logic_vector(15 downto 0);
signal mcmd_s : std_logic_vector(2 downto 0);
signal maddr_d : unsigned(15 downto 0);
signal maddr_s : std_logic_vector(15 downto 0);
signal mdata_s : std_logic_vector(31 downto 0);
signal sresp_s : std_logic_vector(1 downto 0);
signal sdata_s : std_logic_vector(31 downto 0);
begin

DUT : fft_hw_accelerator_top
port map(
  rd_clk_i => rd_clk_s,
  wr_clk_i => wr_clk_s,
  rst_i => rst_s,
  wr_i => wr_s,
  ch0_data_i => m1_samples_s,
  MCmd => mcmd_s,
  MAddr => maddr_s,
  MData => mdata_s,
  MByteEn => "0000",
  SResp => sresp_s,
  SData => sdata_s
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


stimuli : process
begin


rst_s <= '1';
start_cmd_s <= '0';
stop_cmd_s <= '0';
start_s <= '0';
stop_s <= '0';
read_buffer_s <= '0';

wait for 12500ns;
 rst_s <= '1';

 wait for 12500ns;
 rst_s <= '0';

 wait for 100ns;
 start_cmd_s <= '1';
 start_s <= '1';

 wait for 2ns;
 start_s <= '0';
--wr_s <= '1';
--m1_samples_s <="0000111100001111";

 wait for 2ms;
start_cmd_s <= '0';
stop_cmd_s <= '1';
stop_s <= '1';
wait for 2ns;
stop_s <= '0';

wait for 11ns;
read_buffer_s <= '1';
wait for 128ns;
read_buffer_s <= '0';
wait for 10ns;


 end process;

ocp_master : process(rd_clk_s, rst_s, maddr_d, start_cmd_s, stop_cmd_s) is
begin
  if (rst_s = '1') then
    mcmd_s <= (others => '0');
    maddr_s <= (others => '0');
    mdata_s <= (others => '0');
  elsif rising_edge(rd_clk_s) then
      if (start_s ='1') then
        mcmd_s <= "001";
        maddr_s <= X"FFFE";
        mdata_s <= X"00000001";
      elsif (stop_s ='1') then
        mcmd_s <= "001";
        maddr_s <= X"FFFF";
        mdata_s <= X"00000001";
      elsif (read_buffer_s ='1') then
        mcmd_s <= "010";
        maddr_s <= std_logic_vector(maddr_d);
        mdata_s <= X"00000000";
      else
        mcmd_s <= (others => '0');
        maddr_s <= (others => '0');
        mdata_s <= (others => '0');
  end if;
end if;
end process;

process(rd_clk_s, rst_s)
begin
  if (rst_s = '1') then
    maddr_d <= (others => '0');
  elsif(rd_clk_s'event and rd_clk_s ='1') then
    if (maddr_d = x"003F") then
      maddr_d <= (others => '0');
    elsif (read_buffer_s ='1') then
      maddr_d <= maddr_d + 1;
    end if;
  end if;
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
