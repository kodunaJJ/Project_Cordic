library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;
use lib_VHDL.Z_calc;

entity test_Z_calc is

end entity test_Z_calc;

architecture test of test_Z_calc is

  component Z_calc is
    generic (
      N : positive);
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

  component Rom_atan_cordic is
    port (
      Rom_Address : in  std_logic_vector(3 downto 0);
      Rom_out     : out std_logic_vector(15 downto 0));
  end component Rom_atan_cordic;

-- extern signal
  signal Sig_Z0          : std_logic_vector(15 downto 0);
  signal Sig_Angle       : std_logic_vector(15 downto 0);
  signal Sig_sel         : std_logic;
  signal Sig_Sign        : std_logic;
  signal Sig_In_Enable   : std_logic;
  signal Sig_Clk         : std_logic                    := '0';
  signal Sig_Reset       : std_logic;
  signal Sig_Msb         : std_logic;
  signal Sig_rom_address : std_logic_vector(3 downto 0);
  signal Sig_rom_out     : std_logic_vector(15 downto 0);
  signal Sig_iteration   : std_logic_vector(3 downto 0) := "0001";

  constant Clk_period       : time := 10 ns;
  constant iteration_period : time := 2*Clk_period;
  constant simu_period      : time := 30*Clk_period;
--type tab_rom is array (0 to 15) of std_logic_vector(15 downto 0);
--    constant atan_rom : tab_rom :=
--    (0 => "0110010010000111", 1 => "0011101101011000" , 2 => "0001111101011011",
--     -- 45                                      --      14.036
--    3 => "0000111111101010" , 4 => "0000011111111101" , 5 => "0000001111111111",
--     --
--     6        => "0000000111111111" , 7 => "0000000111111111" ,  8 => "0000000001111111" ,

--    9 => "0000000000111111" , 10 => "0000000000011111" , 11 => "0000000000001111",
--     --
--     12 => "0000000000000111", 13 =>  "0000000000000011", 14 =>  "0000000000000001",
--     --
--     15 => "0000000000000000");


begin  -- architecture test

  Sig_Sign <= not Sig_Msb;

  Z_calc_test : Z_calc
    generic map (
      N => 16)
    port map (
      Z0        => Sig_Z0,
      Angle     => Sig_Angle,
      Sel       => Sig_sel,
      Sign      => Sig_Sign,
      In_Enable => Sig_In_Enable,
      Clk       => Sig_Clk,
      Reset     => Sig_Reset,
      Msb       => Sig_Msb
      );

  Rom_atan_cordic_test : Rom_atan_cordic
    port map (
      Rom_Address => Sig_rom_address,
      Rom_out     => Sig_Angle
      );

  Sig_Clk         <= not Sig_Clk                                   after Clk_period;
  Sig_iteration   <= std_logic_vector(unsigned(Sig_iteration) + 1) after iteration_period;
  Sig_rom_address <= Sig_iteration;
  Sig_Sign        <= not Sig_Msb;

  spy_process : process
  begin  -- process spy_process
    init_signal_spy("/test_Z_calc/Z_calc_test/Mux_out", "Mux_out", 1, -1);
    init_signal_spy("/test_Z_calc/Z_calc_test/Buff_OE", "buff_OE", 1, -1);
    wait;
  end process spy_process;

  process
  begin

    -- waveform generation start on unsigned op
    Sig_Reset     <= '1';
    Sig_Z0        <= "0010001011000011";  -- insert angle to calculate
    Sig_sel       <= '0';
    Sig_In_Enable <= '0';
    --Sig_iteration <= "0001";
    wait for 3*Clk_period;
    assert false report "End reset period" severity note;

    Sig_Reset     <= '0';
    Sig_sel       <= '0';
    Sig_In_Enable <= '1';

    wait for Clk_period;
    assert false report "Calculation start" severity note;

    while unsigned(Sig_iteration) < 16 loop
      Sig_sel       <= '1';
      Sig_In_Enable <= '1';

      wait for Clk_period;

      Sig_In_Enable <= '0';
      wait for Clk_period;

    end loop;

    wait for simu_period;
    assert false report "end OF SIMULATION" severity failure;

  end process;


end architecture test;
