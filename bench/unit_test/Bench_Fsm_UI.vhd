library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;
use lib_VHDL.Fsm_UI;

entity test_Fsm_UI is
end test_FSM_UI;

architecture test of test_Fsm_UI is
  component Fsm_UI is
    port(Clk                   : in  std_logic;
         Reset                 : in  std_logic;
         Load_button           : in  std_logic;
         Start_button          : in  std_logic;
         New_calc_button       : in  std_logic;
         Toggle_display_button : in  std_logic;
         XY_msb                : in  std_logic;
         End_cal               : in  std_logic;
         Led_sign              : out std_logic;
         XY_value_sel          : out std_logic;
         --Start_conv            : out std_logic;
         Start_cal             : out std_logic;
         Z_lsb_reg_Ena         : out std_logic;
         Z_mid_reg_Ena         : out std_logic;
         Z_msb_reg_Ena         : out std_logic;
         Z_in_part_sel         : out std_logic_vector(2 downto 0)  -- lsb/mid/msb byte selection of Zin 
     --Op_code_reg_ena       : out std_logic
         );

  end component;

  signal Sig_Clk                   : std_logic;
  signal Sig_Reset                 : std_logic;
  signal Sig_Load_button           : std_logic := '1';
  signal Sig_Start_button          : std_logic := '1';
  signal Sig_New_calc_button       : std_logic := '1';
  signal Sig_Toggle_display_button : std_logic := '1';
  signal Sig_XY_msb                : std_logic := '0';
  signal Sig_End_cal               : std_logic := '1';
  signal Sig_Led_sign              : std_logic;
  signal Sig_XY_value_sel          : std_logic := '0';
  signal Sig_Start_cal             : std_logic;
  signal Sig_Z_lsb_reg_Ena         : std_logic;
  signal Sig_Z_mid_reg_Ena         : std_logic;
  signal Sig_Z_msb_reg_Ena         : std_logic;
  signal Sig_Z_in_part_sel         : std_logic_vector(2 downto 0);

  constant delay_400 : time := 400 ns;
  constant delay_200 : time := 200 ns;
  constant delay_60  : time := 60 ns;
  constant delay_10  : time := 10 ns;
  constant delay_20  : time := 20 ns;
  constant delay_5   : time := 5 ns;
  constant delay_2   : time := 2 ns;
  constant delay_1   : time := 1 ns;
  
begin
  G : Fsm_UI
    port map(
      Clk                   => Sig_Clk,
      Reset                 => Sig_Reset,
      Load_button           => Sig_Load_button,
      Start_button          => Sig_Start_cal,
      New_calc_button       => Sig_New_calc_button,
      Toggle_display_button => Sig_Toggle_display_button,
      XY_msb                => Sig_XY_msb,
      End_cal               => Sig_End_cal,
      Led_sign              => Sig_Led_sign,
      XY_value_sel          => Sig_XY_value_sel,
      --Start_conv            : out std_logic;
      Start_cal             => Sig_Start_cal,
      Z_lsb_reg_Ena         => Sig_Z_lsb_reg_Ena,
      Z_mid_reg_Ena         => Sig_Z_mid_reg_Ena,
      Z_msb_reg_Ena         => Sig_Z_msb_reg_Ena,
      Z_in_part_sel         => Sig_Z_in_part_sel
      );


  process
  begin
    Sig_Load_button <= '1';
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

end test;
