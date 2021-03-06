--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: TOP RTL design with the OCP slave and the FFT controller
--
--  Revision    : Check history on GitHub
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fft_hw_accelerator_top is
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

 end fft_hw_accelerator_top;

 architecture rtl of fft_hw_accelerator_top is

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
     result_ready_o : out std_logic;
     m1_samples_i: in std_logic_vector(15 downto 0)

    );
  end component;

  component ocp_slave_ctrl is
  port(
    rd_clk_i  : in std_logic;
    rst_i     : in std_logic;

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

 end component;



 signal start_cmd_s, stop_cmd_s, result_ready_fft_s, rd_result_s : std_logic;
 signal result_s : std_logic_vector(15 downto 0);
 signal rd_result_addr_s : std_logic_vector (5 downto 0);


begin

  fft_ctrl_inst : fft_controller_top
  port map(
    rd_clk_i => rd_clk_i,
    wr_clk_i => wr_clk_i,
    rst_i => rst_i,
    start_cmd_i => start_cmd_s,
    stop_cmd_i => stop_cmd_s,
    wr_i => wr_i,
    rd_i => rd_result_s,
    rd_addr_i => rd_result_addr_s,
    result_o => result_s,
    result_ready_o => result_ready_fft_s,
    m1_samples_i => ch0_data_i
  );

  ocp_slave_ctrl_inst : ocp_slave_ctrl
  port map(
    rd_clk_i    => rd_clk_i,
    rst_i       => rst_i,
    MCmd_i      => MCmd,
    MAddr_i     => MAddr,
    MData_i     => MData,
    MByteEn_i   => MByteEn,
    SResp_o     => SResp,
    SData_o     => SData,
    start_cmd_o => start_cmd_s,
    stop_cmd_o  => stop_cmd_s,
    result_ready_fft_i => result_ready_fft_s,
    obuf_data_i => result_s,
    obuf_rd_en_o => rd_result_s,
    obuf_rd_addr_o => rd_result_addr_s
  );




end rtl;
