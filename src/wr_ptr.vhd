--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for generating the write address
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity wr_ptr is
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
end wr_ptr;

architecture rtl of wr_ptr is

  signal wr_ptr_reg, wr_ptr_next : unsigned(ADDR_WIDTH-1 downto 0);
  signal wr_addr_reg : unsigned(ADDR_WIDTH-1 downto 0);
  signal wr_window_reg : std_logic;
  signal wr_addr_s : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal wr_init_done_s, wr_init_done_fe_d, wr_init_done_dd, wr_init_done_fe, wr_init_done_d : std_logic;
  signal window_cnt : unsigned(WINDOW_CNT_WIDTH-1 downto 0);


  begin

--incrementing write pointers
wr_ptr_adder: process (window_cnt, wr_ptr_reg)
begin
  if (window_cnt = x"1") then
    wr_window_reg <= '1';
  else
    wr_window_reg <= '0';
  end if;
end process;

--wr_ptr_register : process (wr_clk_i, rst_i)
--begin
--  if (rst_i = '1') then
--    wr_ptr_reg <= to_unsigned(WINDOW_SIZE, ADDR_WIDTH);
--  elsif (wr_clk_i'event and wr_clk_i='1') then
--    if (wr_ptr_reg = to_unsigned(TRANSFORM_LENGTH-1, ADDR_WIDTH) and wr_window_reg = '1') then
--      wr_ptr_reg <= (others => '0');
--    else
--      wr_ptr_reg <= wr_ptr_reg;
--    end if;
-- end if;
--end process;

window_counter : process (wr_clk_i, rst_i)
begin
  if (rst_i = '1') then
    window_cnt <= (others=>'0');
  elsif (wr_clk_i'event and wr_clk_i='1') then
    if (wr_init_done_fe = '1' or wr_window_reg = '1') then
      window_cnt <= to_unsigned(WINDOW_SIZE, WINDOW_CNT_WIDTH);
    elsif  (window_cnt > x"0" and wr_i = '1' ) then
        window_cnt <= window_cnt - 1;
    end if;
  end if;
end process;


wr_addr_counter : process (wr_clk_i, rst_i)
begin
  if (rst_i = '1') then
    wr_addr_reg <= (others=>'0');
  elsif (wr_clk_i'event and wr_clk_i='1') then
    if (wr_i = '1') then
        wr_addr_reg <= wr_addr_reg + 1;
    end if;
  end if;
end process;

wr_init_done_reg : process (wr_clk_i, rst_i)
begin
  if (rst_i = '1') then
    wr_init_done_d <= '0';
  elsif (wr_clk_i'event and wr_clk_i='1') then
    wr_init_done_d <= wr_init_done_s;
  end if;
end process;


process (wr_clk_i, rst_i) begin
        if (rst_i = '1') then
            wr_init_done_fe_d <= '0';
        elsif (wr_clk_i'event and wr_clk_i='1') then
            if (wr_init_done_fe = '1') then
                wr_init_done_fe_d <= '1';
            else
                wr_init_done_fe_d <= wr_init_done_fe_d;
            end if;
        end if;
end process;


wr_init_done_fe <= '1' when (wr_init_done_s = '0' and wr_init_done_d = '1') else '0';
wr_addr_s <= std_logic_vector(wr_addr_reg(ADDR_WIDTH-1 downto 0));

wr_init_done_s <= '1' when (wr_addr_s = std_logic_vector(to_unsigned(TRANSFORM_LENGTH-1, ADDR_WIDTH)) and wr_init_i = '1') else '0';

wr_init_done_o <= wr_init_done_s;
wr_window_done_o <= wr_window_reg;
wr_addr_o <= wr_addr_s;

end rtl;
