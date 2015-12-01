--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: RTL design for the OCP slave controller
--
--  Revision    : Check history on GitHub
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ocp_slave_ctrl is
port(

  rd_clk_i : in std_logic;
  rst_i: in std_logic;

-- OCP IN (slave) for Patmos
  MCmd_i          : in  std_logic_vector(2 downto 0);
  MAddr_i         : in  std_logic_vector(15 downto 0);
  MData_i         : in  std_logic_vector(31 downto 0);
  MByteEn_i       : in  std_logic_vector(3 downto 0);
  SResp_o         : out std_logic_vector(1 downto 0);
  SData_o         : out std_logic_vector(31 downto 0);

-- fft_controller
  start_cmd_o           : out std_logic;
  stop_cmd_o            : out std_logic;
  result_ready_fft_i    : in std_logic;
  obuf_data_i           : in std_logic_vector(15 downto 0);
  obuf_rd_en_o          : out std_logic;
  obuf_rd_addr_o        : out std_logic_vector(5 downto 0)

 );

end ocp_slave_ctrl;

architecture rtl of ocp_slave_ctrl is

  type state_type is (S0_IDLE,
                      S1_START_CMD,
                      S2_STOP_CMD,
                      S3_READ_STATUS,
							        S4_CLEAR_STATUS,
							        S5_READ_BUFFER);

  signal state, next_state : state_type;
  signal clr_status_r          : std_logic;
  signal buffer_rd_data : std_logic_vector(15 downto 0);
  signal result_ready_r : std_logic_vector(31 downto 0);
  signal s5_read_resp, s5_read_resp_d : std_logic_vector(1 downto 0);
  signal status_zero_pad : std_logic_vector(30 downto 0) := (others => '0');


begin

CL: process(rd_clk_i, state, MCmd_i, MAddr_i, MData_i, s5_read_resp_d, buffer_rd_data, result_ready_r)
  begin
    --default output values
    next_state <= state;
    SData_o <= (others => '0');
    SResp_o <= (others => '0');
    clr_status_r <= '0';
    obuf_rd_en_o <= '0';
    obuf_rd_addr_o <= (others => '0');
    start_cmd_o <='0';
    stop_cmd_o <= '0';

  case(state) is

    when S0_IDLE =>
      if (MAddr_i(15 downto 12) = "1101" and MCmd_i = "010" ) then
        next_state <= S1_START_CMD;
      elsif (MAddr_i(15 downto 12) = "1110" and MCmd_i = "010" ) then
          next_state <= S2_STOP_CMD;
      elsif (MAddr_i(15 downto 12) = "1111" and MCmd_i = "001" ) then
        next_state <= S3_READ_STATUS;
      elsif (MAddr_i(15 downto 12) = "1111" and MCmd_i = "010" ) then
        next_state <= S4_CLEAR_STATUS;
      elsif (MAddr_i(15 downto 12) < "1101" and MCmd_i = "001" ) then
        next_state <= S5_READ_BUFFER;
      end if;

    when S1_START_CMD =>
          start_cmd_o <= MData_i(0);
          SResp_o <= "01";
          next_state <= S0_IDLE;

    when S2_STOP_CMD =>
          stop_cmd_o <= MData_i(0);
          SResp_o <= "01";
          next_state <= S0_IDLE;

    when S3_READ_STATUS =>
        SData_o <= result_ready_r;
        SResp_o <= "01";
        next_state <= S0_IDLE;

    when S4_CLEAR_STATUS =>
        clr_status_r <= '1';
        SResp_o <= "01";
        next_state <= S0_IDLE;

    when S5_READ_BUFFER =>
        SData_o <= std_logic_vector(resize(unsigned(buffer_rd_data), SData_o'length));
        SResp_o <= s5_read_resp_d;
        obuf_rd_en_o <= '1';
        obuf_rd_addr_o <= MAddr_i(5 downto 0);
        next_state <= S0_IDLE;

    when OTHERS =>
        next_state <= S0_IDLE;

  end case;

  end process;

s5_read_resp <= "01" when (state = S5_READ_BUFFER and next_state = S0_IDLE);

status_register : process(rd_clk_i, rst_i)
  begin
    if (rst_i = '1') then
      result_ready_r <= (others => '0');
    elsif(rd_clk_i'event and rd_clk_i = '1') then
      if (clr_status_r = '1') then
        result_ready_r <= (others => '0');
      elsif (result_ready_fft_i = '1') then
        result_ready_r <= "00000000000000000000000000000001";
		else
			result_ready_r <= result_ready_r;
      end if;
    end if;
  end process;


SEQ:  process(rd_clk_i, rst_i)
  begin
    if (rst_i = '1') then
      state <= S0_IDLE;
      buffer_rd_data <= (others => '0');
      s5_read_resp_d <= "00";
    elsif(rd_clk_i'event and rd_clk_i = '1') then
      state <= next_state;
      buffer_rd_data <= obuf_data_i;
      s5_read_resp_d <= s5_read_resp;
    end if;
  end process;

end rtl;
