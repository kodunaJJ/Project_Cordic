-----------------------------cordic_core.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cordic_core is
  port(X, Y, Z      : in  std_logic_vector(15 downto 0);
       Clk          : in  std_logic;
       Reset        : in  std_logic;
       Start_cal    : in  std_logic;
       End_cal      : out std_logic;
       X_out, Y_out : out std_logic_vector(15 downto 0));
end Cordic_core;

architecture A of Cordic_core is

  component Z_calc is
    port (
      Z0        : in  std_logic_vector(N-1 downto 0);
      Angle     : in  std_logic_vector(N-1 downto 0);
      Sel       : in  std_logic;
      Sign      : in  std_logic;
      In_Enable : in  std_logic;
      Clk       : in  std_logic;
      Reset     : in  std_logic;
      Msb       : out std_logic);
  end component Z_calc;

  component XY_calc is
    port (
      Clk           : in  std_logic;
      Reset         : in  std_logic;
      Data_in       : in  std_logic_vector(N-1 downto 0);
      Sel           : in  std_logic;
      Sign          : in  std_logic;
      In_Enable     : in  std_logic;
      Out_Enable    : in  std_logic;
      Data_in_i     : in  std_logic_vector(N-1 downto 0);
      Data_out_i    : out std_logic_vector (N-1 downto 0);
      Shift_count_1 : in  std_logic_vector (3 downto 0);
      Shift_count_2 : in  std_logic_vector (3 downto 0);
      Data_n        : out std_logic_vector (N-1 downto 0)
      );
  end component XY_calc;

  component Fsm_cordic_core
    port(Clk           : in  std_logic;
         Reset         : in  std_logic;
         Start_cal     : in  std_logic;
         iteration     : in  std_logic_vector(3 downto 0);
         End_cal       : out std_logic;
         Buff_IE_X_Y   : out std_logic;
         Buff_IE_Z     : out std_logic;
         Data_sel      : out std_logic;
         Rom_Address   : out std_logic_vector(3 downto 0);
         Shift_count_1 : out std_logic_vector(3 downto 0);
         Shift_count_2 : out std_logic_vector(3 downto 0);
         Buff_OE       : out std_logic);
  end component;

  component Rom_atan_cordic
    port(Rom_Address : in  std_logic_vector(3 downto 0);
         Rom_out     : out std_logic_vector(15 downto 0));
  end component;

  component Counter is
    port (
      Clk          : in  std_logic;
      Reset        : in  std_logic;
      Count_enable : in  std_logic;
      Count_in     : in  std_logic_vector(N-1 downto 0);
      Count_out    : out std_logic_vector(N-1 downto 0));
  end component Counter;

  component Clock_divider is
    port (
      Reset   : in  std_logic;
      Clk     : in  std_logic;
      Clk_out : out std_logic);
  end component Clock_divider;


  --signal X_intern, Y_intern, Z_intern : std_logic_vector (15 downto 0);
  --signal Data_sel_intern              : std_logic;
  --signal START_CAL_intern             : std_logic;
  --signal END_CAL_intern               : std_logic;
  --signal Buff_IE_X_Y_intern           : std_logic;
  --signal Rom_Address_intern           : std_logic_vector(3 downto 0);
  --signal Buff_IE_Z_intern             : std_logic;
  signal Rom_out_intern               : std_logic_vector(15 downto 0);
  signal Buff_z_intern_out            : std_logic_vector(N-1 downto 0); --
                                                                        --preciser
                                                                        --N !!!

  signal iter_count : std_logic_vector(3 downto 0);

begin

  U1 : ROM port map (
    Rom_Address => iter_count,
    Rom_out     => Rom_out_intern
    );

  U2 : Alu port map (
    A   => Buff_z_intern_out,
    B   => rom_out_intern,
    cmd => buff_z_intern_out(15)
    );

  U3 : Alu

    port map (
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

