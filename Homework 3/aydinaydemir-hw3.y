%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



void yyerror (const char *s) 
{}
%}

%code requires {
#include "hw3.h" // Include your header file using the %code directive
PrintNode * head;  // head of what to print
}




%token tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC

%union {
	StringNode strNode;
	NumberNode numNode;
	TreeNode *exprNode;
	int lineNum;
}

%token <numNode> tNUM
%token <strNode> tSTRING
%token <lineNum> tADD tSUB tMUL tDIV
%type <exprNode> expr

%start prog

%%
prog:		'[' stmtlst ']'
;

stmtlst:	stmtlst stmt |
;

stmt:		setStmt | if | print | unaryOperation | expr {topLevelExprPrintListAdder($1);} | returnStmt
;

getExpr:	'[' tGET ',' tIDENT ',' '[' exprList ']' ']'
		| '[' tGET ',' tIDENT ',' '[' ']' ']'
		| '[' tGET ',' tIDENT ']'
;

setStmt:	'[' tSET ',' tIDENT ',' expr ']'  {topLevelExprPrintListAdder($6);}
;

if:		'[' tIF ',' condition ',' '[' stmtlst ']' ']'
		| '[' tIF ',' condition ',' '[' stmtlst ']' '[' stmtlst ']' ']'
;

print:		'[' tPRINT ',' expr ']' {topLevelExprPrintListAdder($4);}
;


unaryOperation: '[' tINC ',' tIDENT ']'
		| '[' tDEC ',' tIDENT ']'
;

expr:		tNUM { $$ = makeNumber($1,0,0); }
			| tSTRING { $$ = makeString($1,0,0); }
			| '[' tADD ',' expr ',' expr ']' { $$ = makeAddition($4 , $6, $2); }
			| '[' tSUB ',' expr ',' expr ']' { $$ = makeSubtraction($4 , $6, $2); }
			| '[' tMUL ',' expr ',' expr ']' { $$ = makeMultiplication($4 , $6, $2); }
			| '[' tDIV ',' expr ',' expr ']' { $$ = makeDivision($4 , $6, $2); }
			| getExpr { $$ = makeXXX(); }
			| function { $$ = makeXXX(); }
			| condition { $$ = makeXXX(); }
;

function:	 '[' tFUNCTION ',' '[' parametersList ']' ',' '[' stmtlst ']' ']'
		| '[' tFUNCTION ',' '[' ']' ',' '[' stmtlst ']' ']'
;

condition:	'[' tEQUALITY ',' expr ',' expr ']' {topLevelExprPrintListAdder($4); topLevelExprPrintListAdder($6);}
		| '[' tGT ',' expr ',' expr ']'  {topLevelExprPrintListAdder($4); topLevelExprPrintListAdder($6);}
		| '[' tLT ',' expr ',' expr ']'  {topLevelExprPrintListAdder($4); topLevelExprPrintListAdder($6);}
		| '[' tGEQ ',' expr ',' expr ']'  {topLevelExprPrintListAdder($4); topLevelExprPrintListAdder($6);}
		| '[' tLEQ ',' expr ',' expr ']'  {topLevelExprPrintListAdder($4); topLevelExprPrintListAdder($6);}
;

returnStmt:	'[' tRETURN ',' expr ']' {topLevelExprPrintListAdder($4);}
		| '[' tRETURN ']'
;

parametersList: parametersList ',' tIDENT | tIDENT
;

exprList:	exprList ',' expr {topLevelExprPrintListAdder($3);}
	| expr {topLevelExprPrintListAdder($1);}
;

%%

void printTotalList () {
	
	PrintNode * temp = head;

	while (temp != NULL) { // while there are nodes to be printed
		//printf("hello worllllddd\n");
		int misMatch = temp->typeMismatch;
		int whichLine = temp->line;

		if (misMatch == 1) {
			printf("Type mismatch on %d\n", whichLine);
		}
		else {
			int lineno = temp->line;
			if (temp->expressionType == STRING) {			
				char * myStr = temp->text;
				printf("Result of expression on %d is (%s)\n",lineno,myStr );
			}
			else {
				double val = temp->value;

				if (temp->isDouble == 1) {
					printf("Result of expression on %d is (%.1f)\n",lineno,val);

				}
				else {
					printf("Result of expression on %d is (%d)\n",lineno,(int)val);
				}
				

			}

		}

		temp = temp->next;
	}

}

void add2PrintList (PrintNode * toadd) {
	
	PrintNode *  temp = head;
	if (temp == NULL) {
		head = toadd;
		//printf("head changed\n");
	}
	else{
		while (temp->next != NULL) { 
			
			//printf("item found\n");
			temp = temp->next; 
		}
		temp->next = toadd;
		//printf("added Nodes\n");

	}
	
}

PrintNode * createPrintNode (int val, int line, int typemismatch){
	PrintNode * toadd = malloc(sizeof(PrintNode));

	toadd->value = val;
	toadd->line = line;
	toadd->typeMismatch = typemismatch;
	toadd->next = NULL;
	//printf("hello world from inside the createPrintNode %d\n", typemismatch);
	return toadd;
}


char * add2strs (char *left , char *right) {
	char * ret = malloc(strlen(left) + strlen(right) +1);
	strcpy(ret, left);
	strcat(ret,right);
	return ret;
}


TreeNode * makeNumber (NumberNode num, int linee, int isExp) {

	TreeNode * ret = (TreeNode *)malloc (sizeof(TreeNode));

	if (isExp == 1) {
		ret->isExpression = 1;
	}
	else {
		ret->isExpression = 0;
	}
	ret->expressionType = NUM;
	ret->exprNodePtr = (ExprNode *)malloc (sizeof(ExprNode));
	ret->exprNodePtr->numNode1.value = num.value;
	ret->exprNodePtr->numNode1.isDouble = num.isDouble;
	ret->line = linee;

	return ret;
}

TreeNode * makeString (StringNode str, int linee, int isExp) {
	TreeNode * ret = (TreeNode *)malloc (sizeof(TreeNode));

	if (isExp == 1) {
		ret->isExpression = 1;
	}
	else {
		ret->isExpression = 0;
	}
	ret->expressionType = STRING;
	ret->exprNodePtr = (ExprNode *)malloc (sizeof(ExprNode));
	ret->exprNodePtr->strNode1.text = str.text;
	ret->line = linee;

	return ret;
}

TreeNode * makeXXX () {
	TreeNode * ret = (TreeNode *)malloc (sizeof(TreeNode));
	ret->exprNodePtr = (ExprNode *)malloc (sizeof(ExprNode));
	ret->expressionType = XXX;

	return ret;
}

TreeNode * makeAddition (TreeNode * left, TreeNode * right, int linenumber) { // TODO: DEAL WITH THE LINE NUMBER

	if ( left->expressionType == NUM && right->expressionType == NUM){   // NUM + NUM CASE
		NumberNode temp;
		temp.value = left->exprNodePtr->numNode1.value + right->exprNodePtr->numNode1.value;
		if (left->exprNodePtr->numNode1.isDouble == 1 || right->exprNodePtr->numNode1.isDouble == 1) { // AT LEAST ONE OF THE OPERANDS IS REAL NUMBER
			temp.isDouble = 1;
		}
		else{  // BOTH OPERANDS ARE INTEGERS
			temp.isDouble = 0;
		}
		//printf("yyyyy%d\n", temp.value);
		return makeNumber(temp,linenumber,1);
	}
	else if (left->expressionType == STRING && right->expressionType == STRING) { // STRING + STRING CASE
		StringNode temp;
		temp.text = add2strs(left->exprNodePtr->strNode1.text , right->exprNodePtr->strNode1.text);
		return makeString(temp,linenumber,1);
	}
	else{
		if (left->expressionType != XXX && right->expressionType != XXX){
			PrintNode * invalidExpr = createPrintNode(0,linenumber,1); // val, line, typemismatch
			add2PrintList(invalidExpr);
			topLevelExprPrintListAdder(right);
			topLevelExprPrintListAdder(left);
			return makeXXX	();
		}
		else{
			if (left->expressionType == XXX && right->expressionType != XXX && right->line != 0) {
				topLevelExprPrintListAdder(right);

			}
			else if (left->expressionType != XXX && right->expressionType == XXX  && left->line != 0) {
				topLevelExprPrintListAdder(left);
			}

			return makeXXX();
		}
		
	}

	// BELOW THIS LINE THE ADD OPERATION IS INVALID. TODO: IMPLEMENT THAT.
	return makeXXX();
}


TreeNode * makeSubtraction (TreeNode * left, TreeNode * right, int linenumber) { // TODO: DEAL WITH THE LINE NUMBER

	if ( left->expressionType == NUM && right->expressionType == NUM){   // NUM - NUM CASE
		NumberNode temp;
		temp.value = left->exprNodePtr->numNode1.value - right->exprNodePtr->numNode1.value;
		if (left->exprNodePtr->numNode1.isDouble == 1 || right->exprNodePtr->numNode1.isDouble == 1) { // AT LEAST ONE OF THE OPERANDS IS REAL NUMBER
			temp.isDouble = 1;
		}
		else{  // BOTH OPERANDS ARE INTEGERS
			temp.isDouble = 0;
		}
		return makeNumber(temp,linenumber,1);
	}
	else {

		if (left->expressionType != XXX && right->expressionType != XXX){
			
			PrintNode * invalidExpr = createPrintNode(0,linenumber,1); // val, line, typemismatch
			add2PrintList(invalidExpr);
			topLevelExprPrintListAdder(right);
			topLevelExprPrintListAdder(left);
			return makeXXX	();
		}
		else{
			return makeXXX();

		}

	}
	// BELOW THIS LINE THE ADD OPERATION IS INVALID. TODO: IMPLEMENT THAT.
}

TreeNode * makeDivision (TreeNode * left, TreeNode * right, int linenumber) { // TODO: DEAL WITH THE LINE NUMBER

	if ( left->expressionType == NUM && right->expressionType == NUM){   // NUM / NUM CASE
		NumberNode temp;
		temp.value = (double)left->exprNodePtr->numNode1.value / (double)right->exprNodePtr->numNode1.value;

		/* printf("x-x-x- (%f) \n", temp.value); */
		if (left->exprNodePtr->numNode1.isDouble == 1 || right->exprNodePtr->numNode1.isDouble == 1) { // AT LEAST ONE OF THE OPERANDS IS REAL NUMBER
			temp.isDouble = 1;
		}
		else{  // BOTH OPERANDS ARE INTEGERS
			temp.isDouble = 0;
		}
		double int_part;
		double frac_part;

		frac_part = modf(temp.value, &int_part);

		if (frac_part != 0 && temp.isDouble == 0) {
			
			temp.value = (int)int_part;
			printf("The result is a double, but temp.isDouble is 0. Integer part: %d\n", (int)int_part);
		}

		return makeNumber(temp,linenumber,1);
	}
	else {

		if (left->expressionType != XXX && right->expressionType != XXX){
			PrintNode * invalidExpr = createPrintNode(0,linenumber,1); // val, line, typemismatch
			add2PrintList(invalidExpr);
			topLevelExprPrintListAdder(right);
			topLevelExprPrintListAdder(left);
			return makeXXX	();
		}
		else{

			if (left->expressionType == XXX && right->expressionType != XXX && right->line != 0) {
				topLevelExprPrintListAdder(right);

			}
			else if (left->expressionType != XXX && right->expressionType == XXX  && left->line != 0) {
				topLevelExprPrintListAdder(left);
			}

			return makeXXX();

		}

	}

	// BELOW THIS LINE THE ADD OPERATION IS INVALID. TODO: IMPLEMENT THAT.
	return makeXXX();

}

TreeNode * makeMultiplication (TreeNode * left, TreeNode * right, int linenumber) { // TODO: DEAL WITH THE LINE NUMBER

	if ( left->expressionType == NUM && right->expressionType == NUM){   // NUM * NUM CASE
		NumberNode temp;
		temp.value = left->exprNodePtr->numNode1.value * right->exprNodePtr->numNode1.value;
		if (left->exprNodePtr->numNode1.isDouble == 1 || right->exprNodePtr->numNode1.isDouble == 1) { // AT LEAST ONE OF THE OPERANDS IS REAL NUMBER
			temp.isDouble = 1;
		}
		else{  // BOTH OPERANDS ARE INTEGERS
			temp.isDouble = 0;
		}

		return makeNumber(temp,linenumber,1);
	}
	else if (left->expressionType == NUM && right->expressionType == STRING){ // NUM * STRING CASE
		
		if (left->exprNodePtr->numNode1.isDouble == 1){
			//printf("IM HERE!!\n");
			PrintNode * invalidExpr = createPrintNode(0,linenumber,1); // val, line, typemismatch
			add2PrintList(invalidExpr);
			topLevelExprPrintListAdder(right);
			topLevelExprPrintListAdder(left);
			return makeXXX();
		}
		
		if (left->exprNodePtr->numNode1.value < 0){
			return makeXXX();
		}
		else if (left->exprNodePtr->numNode1.value == 0) {
			StringNode  x;
			char * temp = "";

			return makeString(x,linenumber,1);
		}
		else {
			StringNode  x;
			char * tempstr = "";
			

			int idx;

			for (idx =0; idx < left->exprNodePtr->numNode1.value; idx++) {
				tempstr = add2strs(tempstr, right->exprNodePtr->strNode1.text);
			}
			x.text = tempstr;
			return makeString(x,linenumber,1);
		}

	}
	else {
		if (left->expressionType != XXX && right->expressionType != XXX){
			PrintNode * invalidExpr = createPrintNode(0,linenumber,1); // val, line, typemismatch
			add2PrintList(invalidExpr);
			topLevelExprPrintListAdder(right);
			topLevelExprPrintListAdder(left);
			return makeXXX	();
		}
		else{

			if (left->expressionType == XXX && right->expressionType != XXX && right->line != 0) {
				topLevelExprPrintListAdder(right);

			}
			else if (left->expressionType != XXX && right->expressionType == XXX  && left->line != 0) {
				topLevelExprPrintListAdder(left);
			}

			return makeXXX();
		}

	}
}

void topLevelExprPrintListAdder (TreeNode * toadd) {

	if (toadd->line != 0 && toadd->isExpression == 1){

		if (toadd->expressionType == STRING){
			//printf("deneme\n");
			char * result = toadd->exprNodePtr->strNode1.text;
			int line = toadd->line;
			PrintNode *temp = malloc(sizeof(PrintNode));
			temp->text = result;
			temp->line = line;
			temp->typeMismatch = 0;
			temp->next = NULL;
			temp->expressionType = STRING;
			add2PrintList(temp);

		}
		else if (toadd->expressionType == NUM) {
			PrintNode *temp = malloc(sizeof(PrintNode));
			double result = toadd->exprNodePtr->numNode1.value;
			//printf("heyy %d\n", toadd->exprNodePtr->numNode1.value);
			int isdouble = toadd->exprNodePtr->numNode1.isDouble;
			int line = toadd->line;

			temp->line = line;
			temp->typeMismatch = 0;
			temp->next = NULL;
			temp-> expressionType = NUM;
			temp->isDouble = isdouble;

			if (isdouble == 1) {
				double int_part, frac_part;

				int_part = (double)(int)(result * 10);
				frac_part = result * 10 - int_part;

				if (result >= 0) {
					result = (frac_part >= 0.5) ? (int_part + 1) / 10.0 : int_part / 10.0;
				} else {
					result = (-frac_part >= 0.5) ? (int_part - 1) / 10.0 : int_part / 10.0;
				}

			}
			temp->value = result;
			/* printf("kkkkk (%f) \n", temp->isDouble); */
			add2PrintList(temp);

		}
	}

}


int main (){
	if (yyparse()) {
		printf("ERROR\n");
		return 1;
	}
	else {
		head;
		printf("OK\n");
		printTotalList();
		return 0;
	}
}
