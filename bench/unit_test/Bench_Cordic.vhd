library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library lib_VHDL;
use lib_VHDL.Cordic;

entity test_Cordic is

  generic (
    N : positive := 19);

end test_Cordic;

architecture test of test_Cordic is

  component Cordic is
    generic (
      N : positive := 19);
    port(
      Z_in                  : in  std_logic_vector(7 downto 0);  --change for bench
      Clk                   : in  std_logic;
      Reset                 : in  std_logic;
      Load_button           : in  std_logic;
      Start_button          : in  std_logic;
      New_calc_button       : in  std_logic;
      Toggle_display_button : in  std_logic;
      End_cal               : out std_logic;
      Led_sign              : out std_logic;
      XY_output             : out std_logic_vector(N-4 downto 0)
      );
  end component Cordic;

  signal Sig_Clk                   : std_logic;
  signal Sig_Reset                 : std_logic;
  signal Sig_Load_button           : std_logic := '1';
  signal Sig_Start_button          : std_logic := '1';
  signal Sig_New_calc_button       : std_logic := '1';
  signal Sig_Toggle_display_button : std_logic := '1';
  signal Sig_XY_msb                : std_logic := '0';
  signal Sig_End_cal               : std_logic := '1';
  signal Sig_Led_sign              : std_logic;
  signal Sig_output_value          : std_logic_vector(N-4 downto 0);
  signal Sig_Z_in                  : std_logic_vector(7 downto 0);

  constant delay_400 : time := 2000 ns;
  constant delay_200 : time := 200 ns;
  constant delay_60  : time := 60 ns;
  constant delay_10  : time := 10 ns;
  constant delay_20  : time := 20 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;


begin

  Cordic_test : Cordic
    generic map(
      N => 19)

  port map (
    Z_in                  => Sig_Z_in,
    Clk                   => Sig_Clk,
    Reset                 => Sig_Reset,
    --Start_cal             => Sig_start_cal,
    Load_button           => Sig_Load_button,
    Start_button          => Sig_Start_button,
    New_calc_button       => Sig_New_calc_button,
    Toggle_display_button => Sig_Toggle_display_button,
    End_cal               => Sig_End_cal,
    Led_sign              => Sig_Led_sign,
    XY_output             => Sig_output_value
    );

 process
  begin
    Sig_Load_button <= '1';
    Sig_Z_in <= "00001111";
    wait for delay_20*3;
        Sig_Load_button <= '0';
    --    --Etat Load 1
        Sig_Load_button <= '1';
        wait for delay_20*3;
        Sig_Load_button <= '0';
    --    --Etat Load 2
        wait for delay_20*3;
        Sig_Load_button <= '1';
        wait for delay_20*3;
        Sig_Load_button <= '0';
    --    --Etat Idle


      Sig_End_cal <= '1';
      wait for delay_20*5;
  --    --Etat Display
      Sig_Toggle_display_button <= '0';
      wait for delay_20*3;
      Sig_New_calc_button <= '1';
      wait for delay_20*3;
      Sig_New_calc_button <= '0';
  end process;


  process
  begin
    wait for delay_400;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;
-- process for signal Reset
  process
  begin
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

end architecture;
