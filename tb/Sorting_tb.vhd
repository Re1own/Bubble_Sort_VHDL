library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sorting_tb is
end Sorting_tb;

architecture Behavioral of Sorting_tb is
  -- Constants and signals
  constant w : integer := 8;
  constant k : integer := 4;

  signal clk       : std_logic := '0';
  signal reset     : std_logic := '1';
  signal DataIn    : std_logic_vector(w-1 downto 0);
  signal Radd      : std_logic_vector(k-1 downto 0);
  signal WrInit    : std_logic := '0';
  signal s         : std_logic := '0';
  signal Rd        : std_logic := '0';
  signal DataOut   : std_logic_vector(w-1 downto 0);
  signal Done      : std_logic;
  file input_file    :   text;
  file expected_output_file : text;


begin 
    
    UUT:    entity work.Sorting
    generic map(w => w, k => k)
    port map(
      clk => clk,
      reset => reset,
      DataIn => DataIn,
      Radd => Radd,
      WrInit => WrInit,
      s => s,
      Rd => Rd,
      DataOut => DataOut,
      Done => Done
    );


    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    Read_file: process
        variable input_line      : line;
        variable expected_line   : line;
        variable vRadd  : std_logic_vector(k-1 downto 0);
        variable vDataIn     : std_logic_vector(w-1 downto 0);
        variable vexpected_data   : std_logic_vector(w-1 downto 0);
        variable actual_data     : std_logic_vector(w-1 downto 0);
        variable space             :   character;
    
    Begin    
        file_open(input_file, "input1.txt", READ_MODE);
--        file_open(expected_output_file, "expected_output.txt", READ_MODE);
        
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        
        wait until falling_edge(clk);
        s <= '0';
      
        WrInit <= '1';
        while not endfile(input_file) loop
          readline(input_file, input_line);
--          readline(expected_output_file, expected_line);
          
          hread(input_line, vRadd);
          Radd <= vRadd;
          
          read(input_line, space);
          hread(input_line, vDataIn);
          DataIn <= vDataIn;
          
          wait for 10 ns;
         end loop;
        WrInit <= '0';

        file_close(input_file);
        file_close(expected_output_file);
        
        wait until falling_edge(clk);
        Rd <= '1';
        for i in 0 to (2**(k-1) - 1) loop
          Radd <= std_logic_vector(to_unsigned(i, k));
          wait for 10 ns;
        end loop;
        Rd <= '0';
        
        
        wait for 10 ns;
        
        wait until falling_edge(clk);
        s <= '1';

        wait until Done = '1';
        s <= '0';

        
        
        wait until falling_edge(clk);
        Rd <= '1';
        for i in 0 to (2**(k-1) - 1) loop
          Radd <= std_logic_vector(to_unsigned(i, k));
          wait for 10 ns;
        end loop;
        Rd <= '0';
        
    wait;
    end process;
    
    
    
    
    
    
    
    

end Behavioral;