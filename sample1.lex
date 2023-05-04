/* 
 * Sample Scanner1: 
 * Description: Replace the string "username" from standard input 
 *              with the user's login name (e.g. lgao)
 * Usage: (1) $ flex sample1.lex
 *        (2a on Mac OS X) $ gcc lex.yy.c -ll 
 *        (2b on Linux)    $ gcc lex.yy.c -lfl
 *        (3) $ ./a.out
 *            stdin> username
 *	      stdin> Ctrl-D
 * Question: What is the purpose of '%{' and '%}'?
 *           What else could be included in this section?
 */

%{
/* need this for the call to getlogin() below */
#include <unistd.h>
%}

%%
username	printf("%s\n", getlogin());
%%

int main()
{
  yylex();
}

