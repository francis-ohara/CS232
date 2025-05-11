-- Francis O'Hara Aidoo
-- CS 232 Spring 2013
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- The alu circuit implements the specified operation on srcA and srcB, putting
-- the result in dest and setting the appropriate condition flags.

-- The opcode meanings are shown in the case statement below

-- condition outputs
-- cr(0) <= '1' if the result of the operation is 0
-- cr(1) <= '1' if there is a 2's complement overflow
-- cr(2) <= '1' if the result of the operation is negative
-- cr(3) <= '1' if the operation generated a carry of '1'

-- Note that the and/or/xor operations are defined on std_logic_vectors, so you
-- may have to convert the srcA and srcB signals to std_logic_vectors, execute
-- the operation, and then convert the result back to an unsigned.  You can do
-- this all within a single expression.


entity alu is
    port (
        srcA: in  unsigned(15 downto 0); -- input A
        srcB: in  unsigned(15 downto 0); -- input B
        op: in  std_logic_vector(2 downto 0); -- operation
        cr: out std_logic_vector(3 downto 0); -- condition outputs
        dest: out unsigned(15 downto 0));        -- output value

end alu;

architecture test of alu is

    -- The signal tdest is an intermediate signal to hold the result and
    -- catch the carry bit in location 16.
    signal tdest: unsigned(16 downto 0);

    -- define intermediate signals for arithmetic overflow conditions
    signal operation_is_addition: boolean;
    signal operation_is_subtraction: boolean;
    signal srcA_is_positive: boolean;
    signal srcA_is_negative: boolean;
    signal srcB_is_positive: boolean;
    signal srcB_is_negative: boolean;
    signal srcA_and_srcB_are_same_sign: boolean;
    signal result_is_positive: boolean;
    signal result_is_negative: boolean;
    signal result_sign_is_different_from_operand_sign: boolean;

    -- Note that you should always put the carry bit into index 16, even if the
    -- carry is shifted out the right side of the number (into position -1) in
    -- the case of a shift or rotate operation.  This makes it easy to set the
    -- condition flag in the case of a carry out.

begin  -- test
    process (srcA, srcB, op)
    begin  -- process
        case op is
            when "000" => tdest <= (srcA(15) & srcA) + (srcB(15) & srcB);       -- addition     tdest = srcA + srcB
            when "001" => tdest <= (srcA(15) & srcA) - (srcB(15) & srcB);       -- subtraction  tdest = srcA - srcB
            when "010" => tdest <= '0' & (srcA and srcB);       -- and          tdest = srcA and srcB
            when "011" => tdest <= '0' & (srcA or srcB);       -- or           tdest = srcA or srcB
            when "100" => tdest <= '0' & (srcA xor srcB);       -- xor          tdest = srcA xor srcB
            when "101" =>        -- shift        tdest = srcA shifted left by one if srcB(0) is 0, otherwise arithmetic shifted right
                if srcB(0) = '0' then
                    tdest <= srcA(15 downto 0) & '0';
                else
                    tdest <= '0' & srcA(15) & srcA(15 downto 1);
                end if;
            when "110" =>        -- rotate       tdest = srcA rotated left by one if srcB(0) is 0, otherwise right
                if srcB(0) = '0' then
                    tdest <= srcA(15 downto 0) & srcA(15);
                else
                    tdest <= srcA(0) & srcA(0) & srcA(15 downto 1);
                end if;
            when "111" =>        -- pass         tdest = srcA
                tdest <= '0' & srcA;
            when others =>
                null;
        end case;
    end process;

    -- connect the low 16 bits of tdest to dest here
    dest <= tdest(15 downto 0);

    -- set intermediate signals for checking arithmetic overflow conditions
    operation_is_addition <= TRUE when op = "000" else FALSE;
    operation_is_subtraction <= TRUE when op = "001" else FALSE;
    srcA_is_positive <= TRUE when srcA(15) = '0' else FALSE;
    srcA_is_negative <= not srcA_is_positive;
    srcB_is_positive <= TRUE when srcB(15) = '0' else FALSE;
    srcB_is_negative <= not srcB_is_positive;
    srcA_and_srcB_are_same_sign <= (srcA_is_positive and srcB_is_positive) or (srcA_is_negative and srcB_is_negative);
    result_is_positive <= TRUE when tdest(15) = '0' else FALSE;
    result_is_negative <= not result_is_positive;
    result_sign_is_different_from_operand_sign <= not ((result_is_positive and srcA_is_positive and srcB_is_positive) or (result_is_negative and srcA_is_negative and srcB_is_negative));

    -- set the four CR output bits here
    cr(0) <= '1' when (tdest(15 downto 0) = "0000000000000000") else '0';
    cr(1) <= '1' when (operation_is_addition and srcA_and_srcB_are_same_sign and result_sign_is_different_from_operand_sign) or
        (operation_is_subtraction and ((srcA_is_negative and srcB_is_positive and result_is_positive) or (srcA_is_positive and srcB_is_negative and result_is_negative)))
            else '0';
    cr(2) <= '1' when tdest(15) = '1' else '0';
    cr(3) <= '1' when tdest(16) = '1' else '0';



end test;
