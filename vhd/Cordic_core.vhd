-----------------------------cordic_core.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic_core is
  port(X_in, Y_in, Z : in  std_logic_vector(15 downto 0);
       CLK           : in  std_logic;
       RESET         : in  std_logic;
       START_CAL     : in  std_logic;
       END_CAL       : out std_logic;
       ADC_Rdb       : out std_logic;
       X_out, Y_out  : out std_logic_vector(15 downto 0));
end cordic_core;

architecture A of cordic_core is

  component buff
    port(Buff_in  : in  std_logic_vector(15 downto 0);
         Buff_OE  : in  std_logic;
         CLK      : in  std_logic;
         Reset    : in  std_logic;
         Buff_Out : out std_logic_vector(15 downto 0)) ;
  end component;

  component mux2x1
    port (in1 , in2 : in  std_logic_vector(15 downto 0);
          sel       : in  std_logic_vector(15 downto 0);
          out_mux   : out std_logic_vector (15 downto 0)); 
  end component;

  component barrel_shifter
    port(data_in   : in  std_logic_vector(15 downto 0);
         shift_cmd : in  std_logic_vector(3 downto 0);
         data_out  : out std_logic_vector(15 downto 0));
  end component;

  component Alu
    port (
      A, B : in  std_logic_vector(15 downto 0);  --vrai ou pas
      cmd  : in  std_logic;
      S    : out std_logic_vector(15 downto 0));
  end component;

  component fsm_core
    port(CLK         : in  std_logic;
         RESET       : in  std_logic;
         START_CAL   : in  std_logic;
         END_CAL     : out std_logic;
         data_sel    : out std_logic;
         Buff_IE_X_Y : out std_logic;
         Buff_IE_Z   : out std_logic;
         Buff_OE     : out std_logic;
         Rom_Address : out std_logic_vector(3 downto 0));
  end component;

  component rom
    port(Rom_Address : in  std_logic_vector(3 downto 0);
         Rom_out     : out std_logic_vector(15 downto 0)) ;
  end component;


  signal X_intern, Y_intern, Z_intern : std_logic_vector (15 downto 0);
  signal Data_sel_intern              : std_logic;
  signal START_CAL_intern             : std_logic;
  signal END_CAL_intern               : std_logic;
  signal Buff_IE_X_Y_intern           : std_logic;
  signal Rom_Address_intern                  : std_logic_vector(3 downto 0);
  signal Buff_IE_Z_intern             : std_logic;
  signal Rom_out_intern : std_logic;
  signal Buff_z_intern_out : std_logic_vector;
  
begin

  U1 : ROM port map (
    Rom_Address => Rom_Address_intern,
    Rom_out     => Rom_out_intern
    );

  U2 : Alu port map (
    A           => rom_out_intern,
    B           => buff_z_intern_out,
    cmd => buff_z_intern_out(15)
    );

  U3 : Alu port map (
    Accu_In   => Mult_out,
    Accu_ctrl => Accu_ctrl,
    CLK       => CLK,
    RESET     => RESET,
    Accu_out  => Accu_out
    );

  U5 : BUFF port map (
    Buff_In  => Accu_out(19 downto 12),
    Buff_OE  => Buff_OE,
    CLK      => CLK,
    RESET    => RESET,
    Buff_out => Filter_Out
    );

  U6 : FSM port map (
    CLK                     => CLK,
    Reset                   => Reset,
    ADC_Eocb                => adc_eoc_intern,
    ADC_Convstb             => ADC_Convstb,
    ADC_Rdb                 => ADC_Rdb,
    ADC_csb                 => ADC_csb,
    DAC_WRb                 => DAC_WRb,
    DAC_csb                 => DAC_csb,
    LDACb                   => LDACb,
    CLRB                    => CLRB,
    Rom_Address             => Rom_Address,
    Delay_Line_Address      => Delay_Line_Address,
    Delay_Line_sample_shift => Delay_Line_sample_shift,
    Accu_ctrl               => Accu_ctrl,
    Buff_OE                 => Buff_OE
    );

  U7 : shift_register port map (
    clk       => clk,
    reset     => reset,
    shift_in  => adc_eocb,
    shift_out => adc_eoc_intern
    );          


end A;

