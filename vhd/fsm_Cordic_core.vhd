------------------------------FSM.vhd----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity FSM is
  port(Clk                     : in  std_logic;
       Reset                   : in  std_logic;
       ADC_Eocb                : in  std_logic;
       ADC_Convstb             : out std_logic;
       ADC_Rdb                 : out std_logic;
       ADC_csb                 : out std_logic;
       DAC_WRb                 : out std_logic;
       DAC_csb                 : out std_logic;
       LDACb                   : out std_logic;
       CLRb                    : out std_logic;
       Rom_Address             : out std_logic_vector(4 downto 0);
       Delay_Line_Address      : out std_logic_vector(4 downto 0);
       Delay_Line_sample_shift : out std_logic;
       Accu_ctrl               : out std_logic;
       Buff_OE                 : out std_logic);
end FSM;

-- Machine à états contrôlant le filtre numérique.

architecture A of FSM is
  type STATE is (Calculation, sample_store, DAC_write);

  signal Current_State, Next_State : State;
  signal Current_count, Next_count : unsigned(4 downto 0);
  signal count                     : unsigned(4 downto 0);


  --signal ROM_Addr_u        : unsigned(4 downto 0); -- remplacement possible par
  -- count ?????
  --signal Delay_Line_Addr_u : unsigned(4 downto 0);

begin

  Rom_Address        <= std_logic_vector(count);
  Delay_Line_Address <= std_logic_vector("11111" - count);
  count              <= Current_count;



  P_STATE : process(Clk, Reset)
  begin
    if (Reset = '1') then
      Current_State <= DAC_write;
      Current_count <= (others => '1');
    elsif (Clk = '1' and Clk'event) then
      Current_State <= Next_State;
      Current_count <= Next_count;
    end if;
  end process P_STATE;

  P_FSM : process(Current_state, ADC_Eocb, count)
  begin
    case Current_state is
      when Calculation =>
        case count is
          when "00000" =>
            LDACb   <= '0';
            ADC_csb <= '1';
            ADC_Rdb <= '1';
            Delay_Line_sample_shift <= '0';
            Next_State <= Calculation;
            Next_count <= count + "00001";
          when "10001" =>
            ADC_Convstb <='0';
            Next_count <= count + "00001";
            Next_State <= Calculation;
          when "11111" =>
            Accu_ctrl <= '0';
	    --DAC_csb <= '0'; -- Jordan
 	    --DAC_WRb <= '0'; -- Change		
            Next_State <= DAC_write;
          when others =>
            LDACb <= '1';
            ADC_Convstb <= '1';
            Accu_ctrl <= '0';
            Next_State <= Calculation;
            Next_count <= count + "00001";
        end case;
        
      when DAC_write =>
        if (count = "11111") then
          Accu_ctrl   <= '1';
          Buff_OE     <= '1';
          ADC_Rdb     <= '0';
          ADC_csb     <= '0';
          ADC_Convstb <= '1';
          DAC_csb     <= '0'; -- Jordan
          DAC_WRb     <= '0'; -- Change	deuxime
          CLRb <= '1';
          Next_count  <= "00000";
        elsif (count = "00000") then
          Buff_OE <= '0';
          DAC_csb <= '1';
          DAC_WRb <= '1';
        end if;
        if (ADC_Eocb = '1') then
          Next_State <= DAC_write;
        else
          Next_State <= sample_store;
        end if;

      when sample_store =>
        Delay_Line_sample_shift <= '1';
        Buff_OE                 <= '0';
        DAC_csb                 <= '1';
        DAC_WRb                 <= '1';
        Next_State              <= Calculation;
        Next_count              <= "00000";
      when others =>
        Next_State <= DAC_write;
    end case;
  end process P_FSM;
end A;
