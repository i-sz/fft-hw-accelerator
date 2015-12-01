--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: Streaming Interface for Altera's FFT core, flow control for
--                Avalaon-ST interface.
--
--  Revision    : Check history on GitHubs
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stream_ins is
  port(
   clk_i : in std_logic;
   rst_i : in STD_LOGIC;
   start_cmd_i : in std_logic;
   stop_cmd_i : in std_logic;
   sink_valid	: IN STD_LOGIC;
   sink_sop	: IN STD_LOGIC;
   sink_eop	: IN STD_LOGIC;
   source_ready	: out STD_LOGIC;
   sink_ready	: in STD_LOGIC;
   source_sop	: OUT STD_LOGIC;
   source_eop	: OUT STD_LOGIC;
   source_valid	: OUT STD_LOGIC;
   rd_o  : out std_logic;
   wr_init_o : out std_logic;
   rd_init_o : out std_logic;
   wr_init_done_i : in std_logic;
   wr_window_done_i : in std_logic;
   rd_samples_done_i : in std_logic;
   result_wr_en_o : out std_logic;
   result_ready_o : out std_logic;
   result_wr_addr_o : out std_logic_vector (5 downto 0)

  );
end stream_ins;

architecture rtl of stream_ins is

type state_type is (S0_IDLE,
                    S1_INIT,
                    S2_SEND_INIT_PACKET,
                    S1_WAIT_FOR_SAMPLES,
                    S2_SEND_PACKET,
                    S3_SOURCE_READY,
                    S4_GET_RESULTS);

signal state, next_state : state_type;
signal result_wr_addr_reg, result_wr_addr_next : unsigned(5 downto 0);
signal result_wr_en_reg, s4_state_tr, s4_state_tr_d : std_logic;
signal wr_init_done_d, wr_window_done_d : std_logic;
signal source_valid_s, source_sop_s, source_eop_s : std_logic;

begin

process(clk_i, rst_i)
begin
  if (rst_i = '1') then
    wr_init_done_d <= '0';
    wr_window_done_d <= '0';
  elsif (clk_i'event and clk_i ='1') then
      wr_init_done_d <= wr_init_done_i;
      wr_window_done_d <= wr_window_done_i;
  end if;
end process;

-- Main state machine combinatorial logic for state transitions
CL: process(clk_i, state, start_cmd_i, stop_cmd_i, wr_init_done_d, wr_init_done_i, wr_window_done_i, wr_window_done_d, rd_samples_done_i, sink_valid, sink_ready, sink_sop, sink_eop)
begin
  --default output values
  next_state <= state;
  s4_state_tr <= '0';

case(state) is

  when S0_IDLE =>
    if (start_cmd_i ='1') then
      next_state <= S1_INIT;
    else
      next_state <= S0_IDLE;
    end if;

  when S1_INIT =>
    if (wr_init_done_i = '1' and sink_ready ='1') then
      next_state <= S2_SEND_INIT_PACKET;
    else
      next_state <= S1_INIT;
    end if;

  when S2_SEND_INIT_PACKET =>
    if (rd_samples_done_i = '1') then
      next_state <= S3_SOURCE_READY;
    else
      next_state <= S2_SEND_INIT_PACKET;
    end if;

  when S1_WAIT_FOR_SAMPLES =>
    if (wr_window_done_i = '1' and sink_ready ='1') then
      next_state <= S2_SEND_PACKET;
    else
      next_state <= S1_WAIT_FOR_SAMPLES;
    end if;

  when S2_SEND_PACKET =>
      if (rd_samples_done_i = '1') then
        next_state <= S3_SOURCE_READY;
      else
        next_state <= S2_SEND_PACKET;
      end if;

  when S3_SOURCE_READY =>
      if (sink_valid = '1' and sink_sop='1') then
        next_state <= S4_GET_RESULTS;
      else
            next_state <= S3_SOURCE_READY;
      end if;
  when S4_GET_RESULTS =>
        if (sink_valid='1' and sink_eop ='1') then
            if (stop_cmd_i = '1') then
              next_state <= S0_IDLE;
              s4_state_tr <= '1';
            else
                next_state <= S1_WAIT_FOR_SAMPLES;
                s4_state_tr <= '1';
            end if;
        else
            next_state <= S4_GET_RESULTS;
            s4_state_tr <= '0';
        end if;
  when OTHERS =>
            next_state <= S0_IDLE;

end case;

end process;


--OUTPUT assigments
process(clk_i, rst_i)
begin
  if (rst_i = '1') then
    source_valid <= '0';
    source_sop <=  '0';
    source_eop <=  '0';
  elsif (clk_i'event and clk_i = '1') then
    source_valid <= source_valid_s;
    source_sop <=  source_sop_s;
    source_eop <=  source_eop_s;
  end if;
end process;



--input buffer ctrl signals
rd_o <= '1' when (state = S2_SEND_INIT_PACKET or state = S2_SEND_PACKET) else '0';
rd_init_o <= '1' when (state = S2_SEND_INIT_PACKET) else '0';
wr_init_o <= '1' when (state = S1_INIT) else '0';


--Avalon IF output signals
source_valid_s <= '1' when ((state =  S2_SEND_INIT_PACKET and wr_init_done_d = '1') or state = S2_SEND_INIT_PACKET or (state = S2_SEND_PACKET  and wr_window_done_d = '1') or state = S2_SEND_PACKET) else '0';
source_sop_s <= '1' when ((state =  S2_SEND_INIT_PACKET and wr_init_done_d = '1') or (state = S2_SEND_PACKET and wr_window_done_d = '1')) else '0';
source_eop_s <= '1' when ((state = S2_SEND_INIT_PACKET and rd_samples_done_i = '1') or (state = S2_SEND_PACKET and rd_samples_done_i = '1')) else '0';

source_ready <= '1' when (state = S3_SOURCE_READY or state = S4_GET_RESULTS) else '0';

--otuput buffer ctrl signals
result_wr_en_o <= '1' when (state = S4_GET_RESULTS or s4_state_tr_d = '1') else '0';
--result_wr_addr_next <= result_wr_addr_reg + 1 when state = S4_GET_RESULTS else result_wr_addr_reg;
result_wr_addr_o <= std_logic_vector(result_wr_addr_reg(5 downto 0));

result_ready_o <= '1' when (s4_state_tr_d = '1') else '0';

result : process(clk_i, rst_i)
begin
  if (rst_i = '1') then
    result_wr_addr_reg <=  (others => '0');
  elsif (clk_i'event and clk_i = '1') then
    if (result_wr_addr_reg = "111111") then
      result_wr_addr_reg <=  (others => '0');
    elsif (state = S4_GET_RESULTS) then
        result_wr_addr_reg <= result_wr_addr_reg + 1;
    end if;
  end if;
end process;


SEQ : process(clk_i, rst_i)
begin
  if (rst_i = '1') then
    state <= S0_IDLE;
    s4_state_tr_d <= '0';
  elsif (clk_i'event and clk_i = '1') then
    state <= next_state;
    s4_state_tr_d <= s4_state_tr;
  end if;
end process;

end rtl;
