#ifndef __HW3_H
#define __HW3_H

typedef enum { NUM, STRING, XXX } TypeOfExpression;


typedef struct NumberNode {
    double value;
    int isDouble; // used as a boolean
} NumberNode;

typedef struct StringNode {
    char * text;
} StringNode;


typedef union ExprNode{
    NumberNode numNode1;
    StringNode strNode1;


} ExprNode;

typedef struct TreeNode {
    TypeOfExpression expressionType;
    ExprNode * exprNodePtr;
    int line;
    int isExpression;

} TreeNode;

typedef struct PrintNode {
    int isDouble;
    TypeOfExpression expressionType;
    char * text;
    double value;
    int line;
    int typeMismatch; // used as a boolean
    struct PrintNode * next;

} PrintNode;


PrintNode * createPrintNode (int val, int line, int typemismatch);
TreeNode * makeNumber (NumberNode num, int linee, int isExp);
TreeNode * makeString (StringNode str, int linee, int isExp);
TreeNode * makeXXX ();
TreeNode * makeAddition (TreeNode * left, TreeNode * right, int linenumber);
TreeNode * makeSubtraction (TreeNode * left, TreeNode * right, int linenumber);
TreeNode * makeDivision (TreeNode * left, TreeNode * right, int linenumber);
TreeNode * makeMultiplication (TreeNode * left, TreeNode * right, int linenumber);


#endif
