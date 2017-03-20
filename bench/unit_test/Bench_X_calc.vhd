library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

library lib_VHDL;
use lib_VHDL.XY_calc;

entity X_calc_test is

end entity X_calc_test;

architecture A of X_calc_test is

  component XY_calc is
    generic (
      N : positive;
      P : positive);
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
      Shift_count_1 : in  std_logic_vector (P-1 downto 0);
      Shift_count_2 : in  std_logic_vector (P-1 downto 0);
      Data_n        : out std_logic_vector (N-1 downto 0)
      );
  end component XY_calc;

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

  -- necessary signal for Z_calc block

  signal Sig_Z0          : std_logic_vector(15 downto 0);
  signal Sig_Angle       : std_logic_vector(15 downto 0);
  signal Sig_sel         : std_logic;
  signal Sig_Sign        : std_logic;
  signal Sig_In_Enable   : std_logic                    := '0';
  signal Sig_Clk         : std_logic                    := '1';
  signal Sig_Reset       : std_logic;
  signal Sig_Msb         : std_logic;
  signal Sig_rom_address : std_logic_vector(3 downto 0);
  signal Sig_rom_out     : std_logic_vector(15 downto 0);
  signal Sig_iteration   : std_logic_vector(3 downto 0) := "1110";

-- necessary signal for X_calc block

  signal Sig_X0            : std_logic_vector(15 downto 0);
  signal Sig_sel_X         : std_logic;
  signal Sig_In_Enable_X   : std_logic := '0';
  signal Sig_Out_Enable_X  : std_logic;
  signal Sig_Data_in_i_X   : std_logic_vector(15 downto 0);
  signal Sig_Data_out_i_X  : std_logic_vector(15 downto 0);
  signal Sig_Shift_count_1 : std_logic_vector(4 downto 0);
  signal Sig_Shift_count_2 : std_logic_vector(4 downto 0);
  signal Sig_Data_n        : std_logic_vector(15 downto 0);

  -- necessary signal for Y_calc block

  signal Sig_Y0 : std_logic_vector(15 downto 0);
  signal Sig_Data_in_i_Y : std_logic_vector(15 downto 0);
  signal Sig_Data_out_i_Y : std_logic_vector(15 downto 0);
  signal Sig_Data_n_Y : std_logic_vector(15 downto 0);
  signal Sig_Sign_Y : std_logic;

  constant Clk_period       : time := 2 ns;
  constant iteration_period : time := 2*Clk_period;
  constant simu_period      : time := 70*Clk_period;

begin  -- architecture A

  X_calc_test : XY_calc

    generic map (
      N => 16,
      P => 5)
    port map (
      Clk           => Sig_Clk,
      Reset         => Sig_Reset,
      Data_in       => Sig_X0,
      Sel           => Sig_sel_X,
      Sign          => Sig_Sign,
      In_Enable     => Sig_In_Enable_X,
      Out_Enable    => Sig_Out_Enable_X,
      Data_in_i     => Sig_Data_out_i_Y,
      Data_out_i    => Sig_Data_out_i_X,
      Shift_count_1 => Sig_Shift_count_1,
      Shift_count_2 => Sig_Shift_count_2,
      Data_n        => Sig_Data_n);

  Y_calc_test : XY_calc
    generic map (
      N => 16,
      P => 5)
    port map (
      Clk           => Sig_Clk,
      Reset         => Sig_Reset,
      Data_in       => Sig_Y0,
      Sel           => Sig_sel_X,
      Sign          => Sig_Sign_Y,
      In_Enable     => Sig_In_Enable_X,
      Out_Enable    => Sig_Out_Enable_X,
      Data_in_i     => Sig_Data_out_i_X,
      Data_out_i    => Sig_Data_out_i_Y,
      Shift_count_1 => Sig_Shift_count_1,
      Shift_count_2 => Sig_Shift_count_2,
      Data_n        => Sig_Data_n_Y);
  
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

  Sig_Clk           <= not Sig_Clk                                   after Clk_period;
  Sig_Sign          <= not Sig_Msb;
  Sig_Sign_Y <= Sig_Msb;
  Sig_iteration     <= std_logic_vector(unsigned(Sig_iteration) + 1) after 2*iteration_period;
  Sig_Shift_count_1 <= std_logic_vector(('0'& unsigned(Sig_iteration))+1);
  Sig_Shift_count_2 <= std_logic_vector(('0'& unsigned(Sig_iteration))+3);

  Sig_rom_address <= Sig_iteration;
  Sig_Sign        <= not Sig_Msb;

  process_count : process(Sig_Clk)
  begin
    if (Sig_Clk = '1' and Sig_Clk'event) then
      if Sig_Reset = '1' then
        Sig_In_Enable <= '0';
      end if;
      Sig_In_Enable <= not Sig_In_Enable;

    end if;
  end process process_count;

  spy_process : process
  begin  -- process spy_process
    init_signal_spy("/X_calc_test/Z_calc_test/Mux_out", "Mux_out", 1, -1);
    init_signal_spy("/X_calc_test/Z_calc_test/Buff_OE", "buff_OE", 1, -1);
    init_signal_spy("/X_calc_test/Z_calc_test/result", "result", 1, -1);
    init_signal_spy("/X_calc_test/X_calc_test/", "Buff_in", 1, -1);
    wait;
  end process spy_process;

  process
  begin

    -- waveform generation start on unsigned op
    Sig_Reset       <= '1';
    --Sig_Z0        <= "0000000000000001";  -- (0 deg)
    --Sig_Z0    <= "0100001100000100";    -- pi/6
    --Sig_Z0          <= "1101111001111110";  -- -pi/12
    --Sig_Z0 <= "0110010010000110";       -- pi/4
    Sig_Z0 <= "1101101111111010";        -- (-16 deg)
    Sig_X0          <= "0111011000000000";
    Sig_Y0 <= (others => '0');
    Sig_sel         <= '0';
    Sig_sel_X       <= '0';
    Sig_In_Enable_X <= '0';
    --Sig_In_Enable <= '0';
    --Sig_iteration <= "0001";
    wait for 5*Clk_period;
    assert false report "End reset period" severity note;

    Sig_Reset       <= '0';
    wait for Clk_period;
    Sig_In_Enable_X <= '1';
    wait for 4*Clk_period;
    Sig_sel         <= '1';
    Sig_sel_X <= '1';
    wait for 62*Clk_period;
    Sig_Out_Enable_X <= '1';
    wait for simu_period;
    assert false report "end OF SIMULATION" severity failure;

  end process;


end architecture A;
