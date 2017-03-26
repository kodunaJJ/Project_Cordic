------------------------------fsm_core.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Fsm_cordic_core is
  generic (
    N : positive
    );
  port(Clk            : in  std_logic;
       Reset          : in  std_logic;
       Start_cal      : in  std_logic;
       iteration      : in  std_logic_vector(3 downto 0);
       Counter_enable : out std_logic;
       --Counter_load : out std_logic;
       --Count_data: out std_logic_vector( 3 downto 0);
       Counter_reset  : out std_logic;
       End_cal        : out std_logic;
       Buff_IE_X_Y    : out std_logic;
       Buff_IE_Z      : out std_logic;
       Data_sel       : out std_logic;
       Rom_Address    : out std_logic_vector(3 downto 0);
       Shift_count_1  : out std_logic_vector(N-1 downto 0);
       Shift_count_2  : out std_logic_vector(N-1 downto 0);
       Buff_OE        : out std_logic);
end Fsm_cordic_core;

-- Machine à états contrôlant le calcul des coordonnées.

architecture A of Fsm_cordic_core is
  type STATE is (Idle, Calculation);

  signal Current_State, Next_State         : State;
  signal Current_Buff_IE_Z, Next_Buff_IE_Z : std_logic;
  signal Current_data_sel, Next_data_sel : std_logic;
  signal Current_Counter_enable, Next_Counter_enable : std_logic;
  signal Buff_IE_Z_int                     : std_logic;
  signal iteration_intern                  : unsigned(iteration'range);
  signal iteration_intern_incd             : unsigned(iteration'range);

begin

  Rom_Address      <= std_logic_vector(iteration);
  iteration_intern <= unsigned(iteration);
  Shift_count_1    <= std_logic_vector(('0'& unsigned(iteration))+1);
  Shift_count_2    <= std_logic_vector(('0'& unsigned(iteration))+3);
  Buff_IE_Z_int    <= Current_Buff_IE_Z;
  Buff_IE_Z        <= Buff_IE_Z_int;
  Buff_IE_X_Y      <= Buff_IE_Z_int;
  Data_sel <= Current_data_sel;
  
  P_STATE : process(Clk, Reset)
  begin
    if (Reset = '1') then
      Current_State     <= Idle;
      Current_Buff_IE_Z <= '0';
      Current_data_sel <= '0';
    elsif (Clk = '1' and Clk'event) then
      Current_State     <= Next_State;
      Current_Buff_IE_Z <= Next_Buff_IE_Z;
      Current_data_sel <= Next_data_sel;
    end if;
  end process P_STATE;

  P_FSM : process(Current_state, Start_cal, iteration_intern, Buff_IE_Z_int)
  begin

    Next_State     <= Idle;
    Next_Data_sel       <= '0';
    End_cal        <= '1';
    --Buff_IE_X_Y    <= '0';
    --Buff_IE_Z      <= '0';
    Next_Buff_IE_Z <= '0';              -- a voir
    Buff_OE        <= '0';
    Counter_reset  <= '0';
    Counter_enable <= '0';


    case Current_state is

      when Idle =>
        if iteration_intern = 15 then
          Buff_OE <= '1';
        end if;

        if Start_cal = '1' then
          Next_Buff_IE_Z <= '1';
          --Next_State <= Calculation;
        end if;

        if Buff_IE_Z_int = '1' then
          Next_State <= Calculation;
        end if;

        --Counter_enable <= '0';
        Counter_reset  <= '1';

      when Calculation =>
        End_cal        <= '0';
        --Buff_IE_X_Y <= '1';
        Next_State     <= Calculation;
        --Buff_IE_Z   <= Clk;
        Next_Buff_IE_Z <= not Current_Buff_IE_Z;
        Counter_enable <= Buff_IE_Z_int and Current_data_sel;

        case iteration_intern is
          when "0000" =>
              Next_data_sel <= '1';              
          when "1111" =>
            Next_data_sel   <= '1';
            Next_State <= Idle;
            Next_Buff_IE_Z <= '0';
          when others =>
            Next_data_sel <= '1';
        end case;
      when others =>
        Next_State <= Idle;
    end case;
  end process P_FSM;
end A;
