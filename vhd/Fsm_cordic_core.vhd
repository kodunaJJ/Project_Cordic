------------------------------fsm_core.vhd----------------------------------------

-- FSM CONTROLLING THE CALCULATION OF SINE AND COSINE VALUE

----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Fsm_cordic_core is
  generic (
    N : positive                        -- data_size
    );
  port(Clk            : in  std_logic;
       Reset          : in  std_logic;
       Start_cal      : in  std_logic;
       iteration      : in  std_logic_vector(3 downto 0);
       Counter_enable : out std_logic;
       End_cal        : out std_logic;
       Buff_IE_XYZ    : out std_logic;
       Data_sel       : out std_logic;
       Rom_Address    : out std_logic_vector(3 downto 0);
       Shift_count_1  : out std_logic_vector(N-1 downto 0);
       Shift_count_2  : out std_logic_vector(N-1 downto 0);
       Buff_OE        : out std_logic);
end Fsm_cordic_core;

architecture A of Fsm_cordic_core is
  type STATE is (Idle, Calculation);

  signal Current_State, Next_State         : State;
  signal Current_Buff_IE_Z, Next_Buff_IE_Z : std_logic;
  signal Current_data_sel, Next_data_sel   : std_logic;
  signal iteration_intern                  : unsigned(iteration'range);

begin

  Rom_Address      <= std_logic_vector(iteration);
  iteration_intern <= unsigned(iteration);
  Shift_count_1    <= std_logic_vector(('0'& unsigned(iteration))+1);
  Shift_count_2    <= std_logic_vector(('0'& unsigned(iteration))+3);
  Buff_IE_XYZ        <= Current_Buff_IE_Z;
  Data_sel         <= Current_data_sel;

  P_STATE : process(Clk, Reset)
  begin
    if (Clk = '1' and Clk'event) then
      if (Reset = '1') then
        Current_State     <= Idle;
        Current_Buff_IE_Z <= '0';
        Current_data_sel  <= '0';
      else
        Current_State     <= Next_State;
        Current_Buff_IE_Z <= Next_Buff_IE_Z;
        Current_data_sel  <= Next_data_sel;
      end if;
    end if;
  end process P_STATE;

  P_FSM : process(Current_state, Start_cal, iteration_intern, Current_Buff_IE_Z, Current_data_sel)
  begin

    Next_State     <= Idle;
    Next_Data_sel  <= '0';
    End_cal        <= '1';
    Next_Buff_IE_Z <= '0';
    Buff_OE        <= '0';
    Counter_enable <= '0';


    case Current_state is

      when Idle =>
        if iteration_intern = 15 then
          Buff_OE <= '1';
          End_cal <= '0';
          Counter_enable <= '1';
        end if;

        if Start_cal = '1' then
          Next_Buff_IE_Z <= '1';
        end if;

        if Current_Buff_IE_Z = '1' then
          Next_State <= Calculation;
        end if;

      when Calculation =>
        Next_State     <= Calculation;
        Next_Buff_IE_Z <= not Current_Buff_IE_Z;
        Counter_enable <= Current_Buff_IE_Z and Current_data_sel;
        Next_Data_sel <= '1';

          if (iteration_intern = "1111") then
            Next_State     <= Idle;
            Next_Buff_IE_Z <= '0';
          end if;
        
      when others =>
        Next_State <= Idle;
    end case;
  end process P_FSM;
end A;
