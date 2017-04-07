library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;
use lib_VHDL.Fsm_UI;

entity test_Fsm_UI is

end test_Fsm_UI;

architecture test of test_Fsm_UI is

  component test_Fsm_UI is

    generic (
      N : positive
      );
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

  constant delay_1 : time := 1 ns;

  signal Sig_clk : std_logic;
  signal Sig_Reset : std_logic;
  signal Sig_Load_button : std_logic;
  signal Sig_Start_button : std_logic;
  signal Sig_New_calc_button : std_logic;
  signal Sig_Toggle_dispaly_button : std_logic;
  signal 
  
