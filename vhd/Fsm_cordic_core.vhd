------------------------------fsm_core.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Fsm_cordic_core is
  port(Clk         : in  std_logic;
       Reset       : in  std_logic;
       Start_cal   : in  std_logic;
       End_cal     : out std_logic;
       Buff_IE_X_Y : out std_logic;
       Buff_IE_Z   : out std_logic;
       Data_sel    : out std_logic;
       Rom_Address : out std_logic_vector(3 downto 0);
       Shift_count_1 : out std_logic_vector(3 downto 0);
       Shift_count_2 : out std_logic_vector(3 downto 0);
       Buff_OE     : out std_logic);
end Fsm_cordic_core;

-- Machine à états contrôlant le calcul des coordonnées.

architecture A of FSM is
  type STATE is (Idle, Calculation);

  signal Current_State, Next_State         : State;
  signal Current_iteration, Next_iteration : unsigned(15 downto 0);
  signal iteration                         : unsigned(3 downto 0);

begin

  Rom_Address <= std_logic_vector(iteration);
  iteration   <= Current_iteration; -- a changer avec schema donner par le prof

  -- comment incrementer i tous les deux cycles ?? ajout buffer pour rom_out ?

  P_STATE : process(Clk, Reset)
  begin
    if (Reset = '1') then
      Current_State     <= Idle;
      Current_iteration <= (others => '0');
    elsif (Clk = '1' and Clk'event) then
      Current_State     <= Next_State;
      Current_iteration <= Next_iteration;
    end if;
  end process P_STATE;

  P_FSM : process(Current_state, START_CAL, iteration)
  begin

    Next_iteration <= (others => '0');
    Next_State     <= Idle;
    Data_sel = '0';
    End_cal = '1';
    Buff_IE_X_Y = '0';
    Buff_IE_Z = '0';
    Buff_OE = '0';

    case Current_state is

      when Idle =>
        if iteration = (others => '1') then
          Buff_OE <= '1';
        end if;

        if Start_cal = '1' then
          Next_State <= Calculation;
        end if;

      when Calculation =>
        End_cal     <= '0';
        Buff_IE_X_Y <= '1';
        Next_State  <= Calculation;

        if iteration(0) = '0' then
          Buff_IE_Z <= '1';
        end if;

        case iteration is
          when "00000" =>
            Next_iteration <= iteration + "00001";
          when "11111" =>
            data_sel   <= '1';
            Next_State <= Idle;
          when others =>
            data_sel       <= '1';
            Next_iteration <= iteration + "00001";
        end case;
      when others =>
        Next_State <= Idle;
    end case;
  end process P_FSM;
end A;
