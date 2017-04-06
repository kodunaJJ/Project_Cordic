library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Cordic_FPGA;

entity test_Cordic_FPGA is
end test_Cordic_FPGA;

architecture test of test_Cordic_FPGA is
  component Cordic_FPGA
    generic (
      N : positive := 19);
    port(
      Z_in         : in  std_logic_vector(N-1 downto 0);  --change for bench
      Clk          : in  std_logic;
      Reset        : in  std_logic;
      Start_conv   : in  std_logic;
      Start_cal    : in  std_logic;                       -- change for bench
      End_cal      : out std_logic;
      X_out, Y_out : out std_logic_vector(N-4 downto 0)
      );
  end component;

  signal Sig_Clk        : std_logic;
  signal Sig_Reset      : std_logic;
  signal Sig_Z_in       : std_logic_vector(18 downto 0);
  signal Sig_Start_cal  : std_logic := '0';
  signal Sig_Start_conv : std_logic := '0';
  signal Sig_X_out      : std_logic_vector (15 downto 0);
  signal Sig_Y_out      : std_logic_vector(15 downto 0);
  signal Sig_End_cal    : std_logic;
  signal inc_value      : std_logic_vector(18 downto 0) := "0000001011001010110";  -- pi/18


  constant delay_3u : time := 3 us;
  constant delay_200 : time := 200 ns;
  constant delay_60 : time := 60 ns;
  constant delay_10 : time := 10 ns;
  constant delay_20 : time := 20 ns;
  constant delay_5  : time := 5 ns;
  constant delay_2  : time := 2 ns;
  constant delay_1  : time := 1 ns;

begin
  Conversion : Cordic_FPGA
    generic map (
      N => 19)
    port map (
      Clk        => Sig_Clk,
      Reset      => Sig_Reset,
      Z_in       => Sig_Z_in,
      Start_cal  => Sig_Start_cal,
      Start_conv => Sig_Start_conv,
      X_out      => Sig_X_out,
      Y_out      => Sig_Y_out,
      End_cal    => Sig_End_cal);


  --process
  --begin
  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0000000000000000000";
  --  wait for delay_60;

  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0001100100100001110";  --pi/2
  --  wait for delay_60;

  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0011001001000011110";  --pi
  --  wait for delay_60;


  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0100101101100101110";  --3pi/2
  --  wait for delay_60;

  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0110010010000111110";  --2pi
  --  wait for delay_60;

  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0100101101100101110";
  --  wait for delay_60;

  --  Sig_Buff_OE_Z0     <= '1';
  --  Sig_Buff_OE_Cad_in <= '1';
  --  Sig_Z_in       <= "0100101101100101110";

  --end process;

  --process_angle_sweep : process (Sig_End_cal)
  --begin
  --  if (Sig_End_cal'event and Sig_End_cal = '1') then

  --    Sig_Z_in           <= std_logic_vector(unsigned(Sig_Z_in) + unsigned(inc_value));
  --    Sig_Start_conv <= '1';
  --    Sig_Start_conv     <= '0' after delay_20;
      
  --    --Sig_Start_cal <= '1' after 4*delay_20;
  --    --Sig_Start_cal      <= '0' after 5*delay_20;
  --  else
  --    Sig_Start_cal  <= '0';
  --    Sig_Z_in <= Sig_Z_in;
  --  end if;

  --end process process_angle_sweep;

  process
  begin
    Sig_Z_in <= "0000001011001010110";
    Sig_Start_conv <= '1';
    wait for 3*delay_20;
    Sig_Start_conv <= '0';
    Sig_Start_cal <= '1';
    wait for 2*delay_20;
    
    end process;





  --process
  --begin
  --  wait for delay_200;
  --  assert false report " FIN DE LA SIMULATION" severity failure;
  --end process;
-- process for signal Reset
  process
  begin
 
    Sig_Reset <= '1';
    wait for delay_20*3;
    Sig_Reset <= '0';
    wait;
  end process;

  -- process for signal Clk
  process
  begin
    Sig_Clk <= '0';
    wait for delay_10;
    Sig_Clk <= '1';
    wait for delay_10;

  end process;

end test;
