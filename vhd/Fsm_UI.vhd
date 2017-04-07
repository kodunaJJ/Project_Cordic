------------------------------fsm_UI.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Fsm_UI is
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
end Fsm_UI;

architecture A of Fsm_UI is
  type STATE is (Idle, Load, Display);
  signal Current_State, Next_State               : State;
  signal Current_load_count, Next_load_count     : unsigned(2 downto 0);
  signal Current_XY_value_sel, Next_XY_value_sel : std_logic;
  signal load_count                              : unsigned(2 downto 0);

begin

  load_count    <= Current_load_count;
  XY_value_sel  <= Current_XY_value_sel;
  Z_in_part_sel <= std_logic_vector(load_count);


  P_STATE : process(Clk, Reset)
  begin
    if (Clk = '1' and Clk'event) then
      if (Reset = '1') then
        Current_State        <= Idle;
        Current_load_count   <= (others => '0');
        Current_XY_value_sel <= '0';
      else
        Current_State        <= Next_State;
        Current_load_count   <= Next_load_count;
        Current_XY_value_sel <= Next_XY_value_sel;
      end if;
    end if;
  end process P_STATE;

  P_FSM : process(Current_State, Current_load_count, Current_XY_value_sel, Load_button,
                  Start_button, New_calc_button, Toggle_display_button, XY_msb)
  begin

    Next_load_count   <= Current_load_count;
    Next_State        <= Idle;
    Next_XY_value_sel <= '0';
    XY_value_sel      <= '0';
    Start_cal         <= '0';
    --Start_conv      <= '0';
    Led_sign          <= '0';
    Z_lsb_reg_Ena     <= '0';
    Z_mid_reg_Ena     <= '0';
    Z_msb_reg_Ena     <= '0';
    --Op_code_reg_ena <= '0';

    case Current_State is

      when Idle =>
        Next_load_count <= (others => '0');

        if (Load_button'event and Load_button = '0') then
          Next_State    <= Load;
          Z_lsb_reg_Ena <= '1';
        elsif (Start_button'event and Start_button = '0') then
          Start_cal <= '1';
        elsif (End_cal'event and End_cal = '1') then
          Next_State <= Display;
        end if;

      when Load =>
        Next_State <= Load;

        if (Load_button'event and Load_button = '0') then
          Next_load_count <= load_count + "001";
        end if;

        case load_count is

          when "001" =>
            Z_mid_reg_Ena <= '1';

          when "010" =>
            Z_msb_reg_Ena <= '1';

          when others =>
            null;
        end case;


        --if (load_count = "011") then
        --  -- see what to do

        --end if;

        --if (Start_button'event and Start_button = '0') then
        --  Start_conv <= '1';
        --end if;

        if (load_count = "011") then
          Next_State <= Idle;
        end if;

      when Display =>
        Led_sign <= XY_msb;

        if(Toggle_display_button'event and Toggle_display_button = '0') then
          Next_XY_value_sel <= not Current_XY_value_sel;
        end if;

        if(New_calc_button'event and New_calc_button = '0') then
          Next_State <= Idle;
        end if;

    end case;


  end process P_FSM;

end architecture;












