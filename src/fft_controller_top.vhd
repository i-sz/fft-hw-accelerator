--------------------------------------------------------------------------------
--
--  Project     : Masters Thesis at Technical University of Denmark,
--                Department of Applied AMthematics and Computer Science,
--                http://www.compute.dtu.dk
--
--	Title		    : Hardware accelerators for the T-CREST multi-core platform
--	Student	    : Istvan Szonyi (s131153@student.dtu.dk)
--
--	Description	: TOP RTL design for the FFT controllers
--
--  Revision    : Check history on GitHub
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fft_controller_top is
port(

  rd_clk_i : in std_logic;
  wr_clk_i : in std_logic;
  rst_i: in std_logic;
  start_cmd_i : in std_logic;
  stop_cmd_i : in std_logic;
  wr_i : in std_logic;
  rd_i : in std_logic;
  rd_addr_i : in std_logic_vector(5 downto 0);
  result_o : out std_logic_vector(15 downto 0);
  result_ready_o : out std_logic;
  m1_samples_i: in std_logic_vector(15 downto 0)
 );

 end fft_controller_top;

 architecture rtl of fft_controller_top is

   --INPUT BUFFER
   constant ADDR_WIDTH_INPUT_BUFFER : integer := 7;
   constant NR_OF_WORDS_INPUT_BUFFER : integer := 128;

   --OUTPUT BUFFER
   constant ADDR_WIDTH_OUTPUT_BUFFER : integer := 6;
   constant NR_OF_WORDS_OUTPUT_BUFFER : integer := 64;

   --CB_BUFFER_CTRL
   constant WINDOW_SIZE : integer := 4;
   constant WINDOW_CNT_WIDTH  : integer := 3;
   constant TRANSFORM_LENGTH : integer := 64;




   signal rd_en_ibuf, rd_init_s, rd_samples_done_s : std_logic;
   signal wr_init_s, wr_init_done_s, wr_window_done_s, wr_delayed : std_logic;
   signal wr_addr_ibuf, rd_addr_ibuf : std_logic_vector(ADDR_WIDTH_INPUT_BUFFER-1 downto 0);

   signal data_ibuf, data_delayed : std_logic_vector(15 downto 0);
   signal result_fft, result_fft_d : std_logic_vector(15 downto 0);
   signal result_wr_addr_s : std_logic_vector(ADDR_WIDTH_OUTPUT_BUFFER-1 downto 0);
   signal result_wr_en_s, rst_n : std_logic;

   signal sink_valid_fft, sink_sop_fft, sink_eop_fft, sink_ready_fft : std_logic;
   signal source_valid_stmi, source_sop_stmi, source_eop_stmi, source_ready_stmi : std_logic;

 --input buffer delay
 component input_buffer_delay is
   port(
     clk_i		: IN std_logic;
     rst_i		: IN std_logic;
     wr_i		  : IN STD_LOGIC;
     data_i		: in std_logic_vector(15 downto 0);
     wr_o		  : OUT STD_LOGIC;
     data_o		: OUT std_logic_vector(15 downto 0)
   );
 end component;


  -- circular buffer ctrl
   component cb_ctrl is
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
   end component;

   --dual port RAM
   component dp_ram is
     generic (
      ADDR_WIDTH : integer := 6;
      NR_OF_WORDS : integer := 64
      );
     port(
      data		: IN std_logic_vector(15 downto 0);
 		  rdaddress		: IN std_logic_vector(ADDR_WIDTH-1 downto 0);
 		  rdclock		: IN STD_LOGIC;
 		  rden		: IN STD_LOGIC;
 		  wraddress		: IN std_logic_vector(ADDR_WIDTH-1 downto 0);
 		  wrclock		: IN STD_LOGIC;
 		  wren		: IN STD_LOGIC;
 		  q		: OUT std_logic_vector(15 downto 0)
     );
   end component;

   component stream_ins is
     port(
      clk_i : in std_logic;
      rst_i : in STD_LOGIC;
      start_cmd_i : in std_logic;
      stop_cmd_i : in std_logic;
      -- AVALON-ST IF
      sink_valid	: IN STD_LOGIC;
      sink_sop	: IN STD_LOGIC;
      sink_eop	: IN STD_LOGIC;
      --sink_real	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      --sink_imag	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      --sink_error	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      source_ready	: out STD_LOGIC;
      sink_ready	: in STD_LOGIC;
      --source_error	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      source_sop	: OUT STD_LOGIC;
      source_eop	: OUT STD_LOGIC;
      source_valid	: OUT STD_LOGIC;
      --source_real	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      --source_imag	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      --buffer ctrl
      rd_o  : out std_logic;
      wr_init_o : out std_logic;
      rd_init_o : out std_logic;
      wr_init_done_i : in std_logic;
      wr_window_done_i : in std_logic;
      rd_samples_done_i : in std_logic;
     --output buffer ctrl
      result_wr_en_o : out std_logic;
      result_ready_o : out std_logic;
      result_wr_addr_o : out std_logic_vector (5 downto 0)
     );
   end component;

   component fft_64 is
     PORT (
      clk	: IN STD_LOGIC;
		  reset_n	: IN STD_LOGIC;
		  fftpts_in	: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		  inverse	: IN STD_LOGIC;
      --AVALON-ST
		  sink_valid	: IN STD_LOGIC;
		  sink_sop	: IN STD_LOGIC;
		  sink_eop	: IN STD_LOGIC;
		  sink_real	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  sink_imag	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		  sink_error	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		  source_ready	: IN STD_LOGIC;
		  fftpts_out	: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		  sink_ready	: OUT STD_LOGIC;
		  source_error	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		  source_sop	: OUT STD_LOGIC;
		  source_eop	: OUT STD_LOGIC;
		  source_valid	: OUT STD_LOGIC;
		  source_real	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		  source_imag	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;


begin


  ibuf_delay_inst : input_buffer_delay
  port map(
    clk_i => wr_clk_i,
    rst_i	=>rst_i,
    wr_i =>	wr_i,
    data_i => m1_samples_i,
    wr_o  =>	wr_delayed,
    data_o => data_delayed
);

  ibuf_inst : dp_ram
  generic map (
        ADDR_WIDTH => ADDR_WIDTH_INPUT_BUFFER,
        NR_OF_WORDS => NR_OF_WORDS_INPUT_BUFFER
        )
  PORT MAP (
		data	 => data_delayed,
		rdaddress	 => rd_addr_ibuf,
		rdclock	 => rd_clk_i,
		rden	 => rd_en_ibuf,
		wraddress	 => wr_addr_ibuf,
		wrclock	 => wr_clk_i,
		wren	 => wr_delayed,
		q	 => data_ibuf
	);

  obuf_inst : dp_ram
  generic map (
        ADDR_WIDTH => ADDR_WIDTH_OUTPUT_BUFFER,
        NR_OF_WORDS => NR_OF_WORDS_OUTPUT_BUFFER
        )
  PORT MAP (
    data	 => result_fft_d,
    rdaddress	 => rd_addr_i,
    rdclock	 => rd_clk_i,
    rden	 => rd_i,
    wraddress	 => result_wr_addr_s,
    wrclock	 => rd_clk_i,
    wren	 => result_wr_en_s,
    q	 => result_o
  );

  -- circular buffer ctrl
   cb_ctrl_inst : cb_ctrl
   generic map (
      WINDOW_SIZE => WINDOW_SIZE,
      WINDOW_CNT_WIDTH  => WINDOW_CNT_WIDTH,
      TRANSFORM_LENGTH => TRANSFORM_LENGTH,
      ADDR_WIDTH => ADDR_WIDTH_INPUT_BUFFER
    )
     port map(
     wr_clk_i => wr_clk_i,
     rd_clk_i => rd_clk_i,
     rst_i => rst_i,
     wr_i => wr_delayed,
     rd_i => rd_en_ibuf,
     rd_init_i => rd_init_s,
     wr_init_i => wr_init_s,
     wr_addr_o => wr_addr_ibuf,
     rd_addr_o => rd_addr_ibuf,
     wr_init_done_o => wr_init_done_s,
     wr_window_done_o => wr_window_done_s,
     rd_samples_done_o => rd_samples_done_s
     );



    stream_ins_inst : stream_ins
       port map(
        clk_i => rd_clk_i,
        rst_i => rst_i,
        start_cmd_i => start_cmd_i,
        stop_cmd_i => stop_cmd_i,
        -- AVALON-ST IF
        sink_valid	=> sink_valid_fft,
        sink_sop	=> sink_sop_fft,
        sink_eop	=> sink_eop_fft,
        --sink_error	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        source_ready	=> source_ready_stmi,
        sink_ready	=> sink_ready_fft,
        --source_error	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        source_sop	=> source_sop_stmi,
        source_eop	=> source_eop_stmi,
        source_valid	=> source_valid_stmi,

        --buffer ctrl
        rd_o  => rd_en_ibuf,
        wr_init_o => wr_init_s,
        rd_init_o => rd_init_s,
        wr_init_done_i => wr_init_done_s,
        wr_window_done_i => wr_window_done_s,
        rd_samples_done_i => rd_samples_done_s,
       --output buffer ctrl
        result_wr_en_o => result_wr_en_s,
        result_ready_o => result_ready_o,
        result_wr_addr_o => result_wr_addr_s
       );

rst_n <= not rst_i;

      fft_64_inst : fft_64
         PORT MAP (
          clk	=> rd_clk_i,
          reset_n	=> rst_n,
          fftpts_in	=> "1000000",
          inverse	=> '0',
          --AVALON-ST
          sink_valid	=> source_valid_stmi,
          sink_sop	=> source_sop_stmi,
          sink_eop	=> source_eop_stmi,
          sink_real	=> data_ibuf,
          sink_imag	=> (others => '0'),
          sink_error	=> (others => '0'),
          source_ready	=>  source_ready_stmi,
          fftpts_out	=> open,
          sink_ready	=> sink_ready_fft,
          source_error	=> open,
          source_sop	=> sink_sop_fft,
          source_eop	=> sink_eop_fft,
          source_valid	=> sink_valid_fft,
          source_real	=> result_fft,
          source_imag	=> open
      );

      process(rd_clk_i, rst_i)
      begin
        if (rst_i = '1') then
          result_fft_d <= (others => '0');
        elsif (rd_clk_i'event and rd_clk_i = '1') then
          result_fft_d <= result_fft;
        end if;
      end process;



end rtl;
