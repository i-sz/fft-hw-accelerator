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
  signal result_ready_r : std_logic_vector(31 downto 0);
  signal next_SResp, Sresp_d : std_logic_vector(1 downto 0);
  signal status_zero_pad : std_logic_vector(30 downto 0) := (others => '0');


begin


  --Register
	process(rd_clk_i, rst_i)
	begin
		if rst_i = '1' then
			SResp_o <= (others => '0');
		elsif rising_edge(rd_clk_i) then
			SResp_o <= next_SResp;
		end if;
	end process;




process (rd_clk_i, MCmd_i, MAddr_i, MData_i, obuf_data_i, result_ready_r)
begin
  SData_o <= (others => '0');
  next_SResp <= (others => '0');
  clr_status_r <= '0';
  obuf_rd_en_o <= '0';
  obuf_rd_addr_o <= MAddr_i(5 downto 0);
  start_cmd_o <='0';
  stop_cmd_o <= '0';
      case(MAddr_i) is
      --STATUS REGISTER
        when X"FFFD" =>
          case(MCmd_i) is
            when "001" => --write
              clr_status_r <= '1';
              SData_o <= (others => '0');
              next_SResp <= "01";
            when "010" => --read
              clr_status_r <= '0';
              SData_o <= result_ready_r;
              next_SResp <= "01";
            when others =>
              clr_status_r <= '0';
              SData_o <= (others => '0');
              next_SResp <= "00";
          end case;
        --START COMMAND
        when X"FFFE" =>
          case(MCmd_i) is
            when "001" => --write
              start_cmd_o <= MData_i(0);
              SData_o <= (others => '0');
              next_SResp <= "01";
            when others =>
              start_cmd_o <= '0';
              SData_o <= (others => '0');
              next_SResp <= "00";
          end case;
          --STOP COMMAND
          when X"FFFF" =>
            case(MCmd_i) is
              when "001" => --write
                stop_cmd_o <= MData_i(0);
                SData_o <= (others => '0');
                next_SResp <= "01";
              when others =>
                stop_cmd_o <= '0';
                SData_o <= (others => '0');
                next_SResp <= "00";
            end case;
            --OTHER ADDRESS IS RESERVED FOR BUFFER
          when others =>   --start command
            case(MCmd_i) is
              when "010" => --read
                SData_o <= std_logic_vector(resize(unsigned(obuf_data_i), SData_o'length));
                next_SResp <= "01";
                obuf_rd_en_o <= '1';
                obuf_rd_addr_o <= MAddr_i(5 downto 0);
              when others =>
                SData_o <= (others => '0');
                next_SResp <= "00";
                obuf_rd_en_o <= '0';
                obuf_rd_addr_o <= (others => '0');
              end case;
        end case;
end process;



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


end rtl;
