# quiwa-easy-lexical-analyzer
Tokenizes quiwa pseudocode and prints it in the form `<Identifier,TokenType>`

To execute:
1. `flex ps1.lex`
2. `gcc lex.yy.c -o out -lfl`
3. `./out <FILE_NAME_OF_TEST_CASE>.easy`

Testing was done under Ubuntu 22.04 (WSL), but other platforms should work, too.