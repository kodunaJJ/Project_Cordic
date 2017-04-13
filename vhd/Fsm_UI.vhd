------------------------------fsm_UI.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Fsm_UI is
  port(Clk                         : in  std_logic;
       Reset                       : in  std_logic;
       Load_pressed_event          : in  std_logic;
       Load_release_event          : in  std_logic;
       --Load_button                 : in  std_logic;
       Start_button_event          : in  std_logic;
       New_calc_button_event       : in  std_logic;
       Toggle_display_button_event : in  std_logic;
       XY_msb                      : in  std_logic;
       End_cal_event               : in  std_logic;
       --Reset_button_event          : out std_logic;
       --Reset_load_button_event_1   : out std_logic;
       Led_sign                    : out std_logic;
       XY_value_sel                : out std_logic;
       --Start_conv            : out std_logic;
       Start_cal                   : out std_logic;
       Z_lsb_reg_Ena               : out std_logic;
       Z_mid_reg_Ena               : out std_logic;
       Z_msb_reg_Ena               : out std_logic;
       Z_in_part_sel               : out std_logic_vector(2 downto 0);
		 State_display : out std_logic_vector (27 downto 0)
		 -- lsb/mid/msb byte selection of Zin 
   --Op_code_reg_ena       : out std_logic
       );
end Fsm_UI;

architecture A of Fsm_UI is
  type STATE is (Idle, Load, Display);
  signal Current_State, Next_State                           : State;
  signal Current_load_count, Next_load_count                 : unsigned(2 downto 0);
  signal Current_XY_value_sel, Next_XY_value_sel             : std_logic;
  signal Current_Z_in_lsb_ena, Next_Z_in_lsb_ena             : std_logic;
  signal Current_Z_in_mid_ena, Next_Z_in_mid_ena             : std_logic;
  signal Current_Z_in_msb_ena, Next_Z_in_msb_ena             : std_logic;
  --signal Current_reset_button_event, Next_reset_button_event : std_logic;
  --signal Current_reset_load_button_event_1,
    --Next_reset_load_button_event_1 : std_logic;
  signal load_count        : unsigned(2 downto 0);
  signal Load_button_event : std_logic;

begin

  load_count                <= Current_load_count;
  XY_value_sel              <= Current_XY_value_sel;
  Z_lsb_reg_Ena             <= Current_Z_in_lsb_ena;
  Z_mid_reg_Ena             <= Current_Z_in_mid_ena;
  Z_msb_reg_Ena             <= Current_Z_in_msb_ena;
  Z_in_part_sel             <= std_logic_vector(load_count);
  --reset_button_event        <= Current_reset_button_event;
  --Reset_load_button_event_1 <= Current_reset_load_button_event_1;
  --Reset_load_button_event_1 <= Current_reset_button_event;


  P_STATE : process(Clk, Reset)
  begin
    if (Clk = '1' and Clk'event) then
      if (Reset = '1') then
        Current_State                     <= Idle;
        Current_load_count                <= (others => '0');
        Current_XY_value_sel              <= '0';
        Current_Z_in_lsb_ena              <= '0';
        Current_Z_in_mid_ena              <= '0';
        Current_Z_in_msb_ena              <= '0';
        --Current_reset_button_event        <= '0';
        --Current_reset_load_button_event_1 <= '0';
      else
        Current_State                     <= Next_State;
        Current_load_count                <= Next_load_count;
        Current_XY_value_sel              <= Next_XY_value_sel;
        Current_Z_in_lsb_ena              <= Next_Z_in_lsb_ena;
        Current_Z_in_mid_ena              <= Next_Z_in_mid_ena;
        Current_Z_in_msb_ena              <= Next_Z_in_msb_ena;
        --Current_reset_button_event        <= Next_reset_button_event;
        --Current_reset_load_button_event_1 <= Next_reset_load_button_event_1;
      end if;
    --if (Load_button'event and (Load_button = '0')) then
    --  Next_load_count <= load_count + "001";
    --end if;
    end if;
  end process P_STATE;

  P_FSM : process(Current_State, load_count, Current_XY_value_sel,
                  Current_Z_in_lsb_ena, Current_Z_in_mid_ena,
                  Current_Z_in_msb_ena, Load_pressed_event,
                  Load_release_event, Start_button_event,
                  New_calc_button_event, Toggle_display_button_event,
                  XY_msb, End_cal_event
                  )
  begin

    Next_load_count                <= load_count;
    Next_Z_in_lsb_ena              <= Current_Z_in_lsb_ena;
    Next_Z_in_mid_ena              <= Current_Z_in_mid_ena;
    Next_Z_in_msb_ena              <= Current_Z_in_msb_ena;
    Next_State                     <= Idle;
    Next_XY_value_sel              <= '0';
    Start_cal                      <= '0';
	 State_display <= (others => '1');
    --Start_conv      <= '0';
    Led_sign                       <= '0';
    --Next_reset_button_event        <= '0';
    --Next_reset_load_button_event_1 <= '0';
    --Op_code_reg_ena <= '0';

    case Current_State is

      when Idle =>
		State_display <= "1001111010000110001110000110";
        Next_load_count <= (others => '0');

        if (Load_pressed_event = '1') then
          Next_State              <= Load;
          --Next_reset_button_event <= '1';
          Next_Z_in_lsb_ena       <= '1';

        elsif (Start_button_event = '1') then
          Start_cal               <= '1';
          --Next_reset_button_event <= '1';
        elsif (End_cal_event = '1') then
          Next_State              <= Display;
          --Next_reset_button_event <= '1';  -- see if dedicated reset necessary
        end if;

      when Load =>
        Next_State <= Load;
		  State_display <= "1000111100000000010000100001";

        if (Load_pressed_event = '1') then
          Next_load_count         <= load_count + "001";
          --Next_reset_button_event <= '1';
        end if;

        if(load_count = "000" and (Load_release_event = '1')) then
          Next_Z_in_lsb_ena              <= '0';
          --Next_reset_load_button_event_1 <= '1';
          --Next_reset_button_event <= '1';
        end if;

        if (load_count = "000" and
            (Load_pressed_event = '1')) then
          Next_Z_in_mid_ena       <= '1';
          --Next_reset_button_event <= '1';
        elsif (load_count = "001" and
               (Load_release_event = '1')) then
          Next_Z_in_mid_ena              <= '0';
          --Next_reset_load_button_event_1 <= '1';
          --Next_reset_button_event <= '1';
        end if;

        if (load_count = "001" and
            (Load_pressed_event = '1')) then
          Next_Z_in_msb_ena       <= '1';
          --Next_reset_button_event <= '1';
        elsif (load_count = "010" and
               (Load_release_event = '1')) then
          Next_Z_in_msb_ena              <= '0';
          --Next_reset_load_button_event_1 <= '1';
          --Next_reset_button_event <= '1';
        end if;




        --if (load_count = "011") then
        --  -- see what to do

        --end if;

        --if (Start_button'event and Start_button = '0') then
        --  Start_conv <= '1';
        --end if;

        if (load_count = "010" and
            (Load_release_event = '1')) then
          Next_State                     <= Idle;
          --Next_reset_load_button_event_1 <= '1';
          --Next_reset_button_event <= '1';
        end if;

      when Display =>
        Led_sign          <= XY_msb;
        Next_State        <= Display;
        Next_XY_value_sel <= Current_XY_value_sel;

        if((Toggle_display_button_event = '1')) then
          Next_XY_value_sel       <= not Current_XY_value_sel;
			 
          --Next_reset_button_event <= '1';
        end if;
			if Current_XY_value_sel = '0' then 
				State_display <= "1111111100011010000000010010";
			 else 
				State_display <= "1111111001001010011111001000";
			 end if; 
        if((New_calc_button_event = '1')) then
          Next_State              <= Idle;
          --Next_button_event <= '1';
        end if;

      when others =>
        Next_State <= Idle;

    end case;
  end process P_FSM;

end architecture;












