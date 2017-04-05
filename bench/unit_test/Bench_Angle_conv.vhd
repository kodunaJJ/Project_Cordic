library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Angle_conv;

entity test_Angle_conv is
end test_Angle_conv;

architecture test of test_Angle_conv is
  component Angle_conv
    generic (
      N : positive);
    port (Clk            : in  std_logic;
          Reset          : in  std_logic;
          Z_in           : in  std_logic_vector(N-1 downto 0);
          Buff_OE_Cad_in : in  std_logic;
          Buff_OE_Z0     : in  std_logic;
          XY_out_cmd     : out std_logic_vector(3 downto 0);
          Z0_out         : out std_logic_vector(N-4 downto 0)
          );
  end component;

  signal Sig_Clk            : std_logic;
  signal Sig_Reset          : std_logic;
  signal Sig_Z_in           : std_logic_vector(18 downto 0);
  signal Sig_Buff_OE_Z0     : std_logic;
  signal Sig_Buff_OE_Cad_in : std_logic;
  signal Sig_XY_out_cmd     : std_logic_vector (3 downto 0);
  signal Sig_Z0_out         : std_logic_vector(15 downto 0);


  constant delay_400 : time := 400 ns;
  constant delay_60  : time := 60 ns;
  constant delay_10  : time := 10 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;

begin
  Conversion : Angle_conv
    generic map (
      N => 19)
    port map (
      Clk            => Sig_Clk,
      Reset          => Sig_Reset,
      Z_in           => Sig_Z_in,
      Buff_OE_Z0     => Sig_Buff_OE_Z0,
      Buff_OE_Cad_in => Sig_Buff_OE_Cad_in,
      XY_out_cmd     => Sig_XY_out_cmd,
      Z0_out         => Sig_Z0_out);


  process
  begin
    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0000000000000000000";
    wait for delay_60;

    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0001100100100001110";  --pi/2
    wait for delay_60;

    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0011001001000011110";  --pi
    wait for delay_60;


    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0100101101100101110";  --3pi/2
    wait for delay_60;

    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0110010010000111110";  --2pi
    wait for delay_60;

    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0100101101100101110";
    wait for delay_60;

    Sig_Buff_OE_Z0     <= '1';
    Sig_Buff_OE_Cad_in <= '1';
    Sig_Z_in       <= "0100101101100101110";

  end process;

  process
  begin
    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
-- process for signal Reset
  process
  begin
    Sig_Reset <= '1';
    wait for delay_2;
    Sig_Reset <= '0';
    wait for delay_10;
    Sig_Reset <= '1';
    wait for delay_10;
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
