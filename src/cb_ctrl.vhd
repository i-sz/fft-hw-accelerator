--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for Circular-buffer control with cdc, write pointer
--                and read pointer 
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cb_ctrl is
   generic (
    WINDOW_SIZE : integer := 4;
    WINDOW_CNT_WIDTH  : integer := 3;
    TRANSFORM_LENGTH : integer := 64;
    ADDR_WIDTH : integer :=  6
    );
  port(
    wr_clk_i : in std_logic;
    rd_clk_i : in std_logic;
    rst_i : in std_logic;
    wr_i : in std_logic;
    rd_i : in std_logic;
    rd_init_i : in std_logic;
    wr_init_i : in std_logic;
    wr_addr_o : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    rd_addr_o : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    wr_init_done_o : out std_logic;
    wr_window_done_o : out std_logic;
    rd_samples_done_o : out std_logic

  );

end cb_ctrl;

architecture rtl of cb_ctrl is



  signal wr_init_done_s, wr_init_done_fe_d, wr_init_done_dd, wr_init_done_fe, wr_init_done_d : std_logic;


  component wr_ptr is
     generic (
      WINDOW_SIZE : integer := 4;
      WINDOW_CNT_WIDTH  : integer := 3;
      TRANSFORM_LENGTH : integer := 64;
      ADDR_WIDTH : integer :=  6
      );
    port(
      wr_clk_i : in std_logic;
      rst_i : in std_logic;
      wr_i : in std_logic;
      wr_init_i : in std_logic;
      wr_addr_o : out std_logic_vector(ADDR_WIDTH-1 downto 0);
      wr_init_done_o : out std_logic;
      wr_window_done_o : out std_logic
    );
  end component;

  component rd_ptr is
     generic (
      WINDOW_SIZE : integer := 4;
      WINDOW_CNT_WIDTH  : integer := 3;
      TRANSFORM_LENGTH : integer := 64;
      ADDR_WIDTH : integer :=  6
      );
    port(
      rd_clk_i : in std_logic;
      rst_i : in std_logic;
      rd_i : in std_logic;
      rd_init_i : in std_logic;
      rd_addr_o : out std_logic_vector(ADDR_WIDTH-1 downto 0);
      rd_samples_done_o : out std_logic
    );
  end component;


  component CDC is
    port(
      clk_a : in std_logic;
      clk_b : in std_logic;
      rst_i : in std_logic;
      valid_i : in std_logic;
      valid_o : out std_logic
    );
  end component;

signal wr_init_d2, wr_init_d1, wr_init_done_sync, wr_window_done_sync : std_logic;

  begin

wr_ptr_inst : wr_ptr
generic map (
      WINDOW_SIZE => WINDOW_SIZE,
      WINDOW_CNT_WIDTH  => WINDOW_CNT_WIDTH,
      TRANSFORM_LENGTH => TRANSFORM_LENGTH,
      ADDR_WIDTH => ADDR_WIDTH
      )
port map(
  wr_clk_i => wr_clk_i,
  rst_i => rst_i,
  wr_i => wr_i,
  wr_init_i => wr_init_d2,
  wr_addr_o => wr_addr_o,
  wr_init_done_o => wr_init_done_sync,
  wr_window_done_o => wr_window_done_sync
);

rd_ptr_inst : rd_ptr
generic map (
      WINDOW_SIZE => WINDOW_SIZE,
      WINDOW_CNT_WIDTH  => WINDOW_CNT_WIDTH,
      TRANSFORM_LENGTH => TRANSFORM_LENGTH,
      ADDR_WIDTH => ADDR_WIDTH
      )
port map(
  rd_clk_i => rd_clk_i,
  rst_i => rst_i,
  rd_i => rd_i,
  rd_init_i => rd_init_i,
  rd_addr_o => rd_addr_o,
  rd_samples_done_o => rd_samples_done_o
);

--CLOCK DOMAIN CROSSING

wr_init_done_cdc : CDC
port map(
  clk_a => wr_clk_i,
  clk_b => rd_clk_i,
  rst_i => rst_i,
  valid_i => wr_init_done_sync,
  valid_o => wr_init_done_o
);

wr_window_done_cdc : CDC
port map(
  clk_a => wr_clk_i,
  clk_b => rd_clk_i,
  rst_i => rst_i,
  valid_i => wr_window_done_sync,
  valid_o => wr_window_done_o
);

--wr_init_i_cdc : CDC
--port map(
--  clk_a => rd_clk_i,
--  clk_b => wr_clk_i,
--  rst_i => rst_i,
--  valid_i => wr_init_i,
--  valid_o => wr_init_s
--);

wr_init_i_cdc : process(wr_clk_i, rst_i)
begin
  if (rst_i = '1') then
    wr_init_d1 <= '0';
    wr_init_d2 <= '0';
  elsif (wr_clk_i'event and wr_clk_i='1') then
    wr_init_d1 <= wr_init_i;
    wr_init_d2 <= wr_init_d1;
  end if;
end process;


end rtl;
