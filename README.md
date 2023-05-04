# quiwa-easy-lexical-analyzer
Tokenizes quiwa pseudocode and prints it in the form `<Identifier,TokenType>`

To execute:
1. `flex ps2.lex`
2. `gcc lex.yy.c -o out -lfl`
3. `./out <FILE_NAME_OF_TEST_CASE>.easy`

Alternatively, you can use this single command and print the output to an out.txt file:
`flex ps2.lex && gcc lex.yy.c -o out -lfl && ./out <FILE_NAME_OF_CODE>.easy > out.txt`

Testing was done under Ubuntu 22.04 (WSL), but other platforms should work, too.

Important notes:
- T_OP_REL only accepts the equality operator `==` or `:=` as to remove ambiguity with the T_OP_ASSIGN `=`. Thus, hanoi.easy (line 6) got changed to `if n == 1 then output 'Move disk from peg' S 'to peg' T`
- The program indents itself based on the QUIWA pseudocode (for easier debugging purposes). It adds a '.' for every whitespace it encounters from the code.
- It also adds + for every '[' or '(' in the stack. This is to check for balanced parentheses
