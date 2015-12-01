--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for generating the read address
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rd_ptr is
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
end rd_ptr;

architecture rtl of rd_ptr is

  signal rd_ptr_reg, rd_ptr_next : unsigned(ADDR_WIDTH-1 downto 0);
  signal rd_addr_reg : unsigned(ADDR_WIDTH-1 downto 0);
  signal rd_samples_done_s : std_logic;
  signal window_cnt : unsigned(ADDR_WIDTH-1 downto 0);

  begin


    --incrementing write pointers
    process (window_cnt)
    begin
      if (window_cnt = x"1") then
        rd_samples_done_s <= '1';
      else
        rd_samples_done_s <= '0';
      end if;
    end process;

    window_counter : process (rd_clk_i, rst_i)
    begin
      if (rst_i = '1') then
        window_cnt <= to_unsigned(TRANSFORM_LENGTH, ADDR_WIDTH);
      elsif (rd_clk_i'event and rd_clk_i='1') then
        if (rd_samples_done_s ='1') then
          window_cnt <= to_unsigned(TRANSFORM_LENGTH, ADDR_WIDTH);
        elsif  (window_cnt > x"0" and rd_i = '1' ) then
            window_cnt <= window_cnt - 1;
        end if;
      end if;
    end process;

    --RD_PTR_ADDER
    rd_ptr_next <= rd_ptr_reg + to_unsigned(WINDOW_SIZE, ADDR_WIDTH) when (rd_addr_reg = to_unsigned(TRANSFORM_LENGTH-1, ADDR_WIDTH)) else rd_ptr_reg;

    rd_ptr_register : process (rd_clk_i, rst_i)
    begin
      if (rst_i = '1') then
        rd_ptr_reg <= (others=>'0');
      elsif (rd_clk_i'event and rd_clk_i='1') then
        rd_ptr_reg <= rd_ptr_next;
      end if;
    end process;

    --incrementing read address
    rd_addr_cnt : process (rd_clk_i, rst_i)
    begin
      if (rst_i = '1') then
        rd_addr_reg <= (others=>'0');
      elsif (rd_clk_i'event and rd_clk_i='1') then
        if (rd_samples_done_s = '1') then
          rd_addr_reg <= (others=>'0');
        elsif (rd_i = '1') then
          rd_addr_reg <= rd_addr_reg + 1;
        end if;
      end if;
    end process;

  --  rd_samples_done_s <= '1' when (rd_addr_reg = to_unsigned(TRANSFORM_LENGTH-1, ADDR_WIDTH)) else '0';
    rd_addr_o <= std_logic_vector(rd_addr_reg(ADDR_WIDTH-1 downto 0) + rd_ptr_reg(ADDR_WIDTH-1 downto 0)) when (rd_init_i = '0' and rd_i ='1') else std_logic_vector(rd_addr_reg(ADDR_WIDTH-1 downto 0));

    rd_samples_done_o <= rd_samples_done_s;
end rtl;
