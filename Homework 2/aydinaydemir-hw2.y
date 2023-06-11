%{
#include <stdio.h>
void yyerror (const char *msg) {return; }    
%}

%token tSTRING tGET tSET tFUNCTION tPRINT tIF tRETURN tADD tSUB tMUL tDIV tINC tGT tEQUALITY tDEC tLT tLEQ tGEQ tIDENT tNUM
%start code

%%

code : '[' statements ']'
statements : 
        | statements statement ;
statement : stSet | stIf | stPrint | stIncrement | stDecrement | stReturn | stExpression ;
stSet : '[' tSET ',' tIDENT ',' stExpression ']';
stExpression : tNUM | tSTRING | expGet | declFunc | oprApplication | condition ;
stIf : '[' tIF ',' condition ',' then  elseOrNot ']' ;
then : '[' statements ']' ;
elseOrNot : 
        | '[' statements ']' ;
stPrint : '[' tPRINT ',' stExpression ']' ;
stIncrement : '[' tDEC ',' tIDENT ']' ;
stDecrement : '[' tINC ',' tIDENT ']' ;
condition : '[' condOp ',' stExpression ',' stExpression ']' ;
condOp : tLEQ|tEQUALITY|tGT|tLT|tGEQ ;
expGet : '[' tGET ',' tIDENT getArgs ']';
getArgs :
        | ',' '[' argList ']' ;
argList : 
        | stExpression 
        | argList ',' stExpression ;
declFunc : '[' tFUNCTION ',' '[' paramList ']' ',' '[' statements ']' ']'
paramList : 
          | tIDENT
          | paramList ',' tIDENT ;
oprApplication : '[' operator ',' stExpression ',' stExpression ']';
operator : tADD | tSUB | tMUL | tDIV;
stReturn : '[' tRETURN returnVal ']';
returnVal : 
          | ',' stExpression ;

%%

int main(){

    if (yyparse()){
        // parse error
        printf("ERROR\n");
        return 1;
    }
    else{
        //succesfull parsing
        printf("OK\n");
        return 0;
    }

}