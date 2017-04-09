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

  signal Sig_Clk                   : std_logic := '1';
  signal Sig_Reset                 : std_logic := '1';
  signal Sig_Load_button           : std_logic := '1';
  signal Sig_Start_button          : std_logic := '1';
  signal Sig_New_calc_button       : std_logic := '1';
  signal Sig_Toggle_display_button : std_logic := '1';
  signal Sig_XY_msb                : std_logic := '0';
  signal Sig_End_cal               : std_logic := '1';
  signal Sig_Led_sign              : std_logic;
  signal Sig_output_value          : std_logic_vector(N-4 downto 0);
  signal Sig_Z_in                  : std_logic_vector(7 downto 0);

  constant delay_2000 : time := 2000 ns;  -- simu duration
  constant delay_400  : time := 400 ns;
  constant delay_200  : time := 200 ns;
  constant delay_60   : time := 60 ns;
  constant delay_10   : time := 10 ns;
  constant delay_20   : time := 20 ns;    -- Clk period
  constant delay_5    : time := 5 ns;
  constant delay_2    : time := 2 ns;
  constant delay_1    : time := 1 ns;

  constant Button_press_duration   : time := 60 ns;
  constant Button_release_duration : time := 80 ns;
  constant Button_action           : time := Button_release_duration
                                             +Button_press_duration;
  constant Calcul_duration         : time := 750 ns;



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

  Sig_Clk <= not Sig_Clk after delay_10;

  process
  begin

    -- Angle value definition
    Sig_Z_in <= "00000000", "00001111" after Button_release_duration/2,
                "11110000" after Button_action+Button_release_duration/2,
                "11001001" after 2*Button_action+Button_release_duration/2;
    Sig_Reset <= '0' after 3*delay_10;

-- user action to load the angle value
    Sig_Load_button <= '0' after Button_release_duration,
                       '1' after Button_action,    -- first time button pressed
                       '0' after Button_action+Button_release_duration,
                       '1' after 2*Button_action,  -- second time button pressed      
                       '0' after 2*Button_action+Button_release_duration,
                       '1' after 3*Button_action;  -- third time button pressed

    Sig_Start_button <= '0' after 3*Button_action+Button_release_duration,
                        '1' after 4*Button_action;  -- start calculation

-- user action to display X or Y value calculated
    Sig_Toggle_display_button <= '0' after 4*Button_action+Calcul_duration
                                 +Button_release_duration,  -- display Y value
                                 '1' after 5*Button_action+Calcul_duration,
                                 '0' after 5*Button_action+Calcul_duration
                                 +Button_release_duration,  -- display X value
                                 '1' after 6*Button_action+Calcul_duration;

    Sig_New_calc_button <= '0' after 6*Button_action+Calcul_duration
                           +Button_release_duration,
                           '1' after 7*Button_action+Calcul_duration;

    wait for 3*delay_2000;
    assert false report " FIN DE LA SIMULATION" severity failure;
  end process;

end architecture;
