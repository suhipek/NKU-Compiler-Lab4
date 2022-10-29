%option noyywrap
%{
    /*
    * You will need to comment this line in lab5.
    */
    #define ONLY_FOR_LEX
    
    #ifdef ONLY_FOR_LEX
    #else
    #define YYSTYPE void *
    #include "parser.h"
    #endif

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #include <string>

    #ifdef ONLY_FOR_LEX
    #include <sstream>
    #include <iostream>
    #include <iomanip>
    #include <ostream>
    #include <fstream>
    #include <map>
    #include <vector>
    
    using namespace std;
    extern FILE *yyin; 
    extern FILE *yyout;
    
    int nowIdAttr = 0;
    struct Symtab{
        map<string, int> idAttrMap; 
        vector<Symtab*> subScopes;
        Symtab *parent;
    };
    Symtab globalScope;
    Symtab *nowScope = &globalScope;

    #define TABLE_WIDTH 16
    
    
    void DEBUG_FOR_LAB4_TABLE(string s1, string s2, string s3=""){
        stringstream ss;
        ss << left << setw(TABLE_WIDTH) << s1;
        ss << left << setw(TABLE_WIDTH) << s2;
        ss << left << setw(TABLE_WIDTH) << yylineno;
        ss << left << setw(TABLE_WIDTH) << s3;
        ss << endl;
        fputs(ss.str().c_str(), yyout);
        // std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        // fputs(DEBUG_INFO.c_str(), yyout);
    }
    #endif
%}

DECIMIAL ([1-9][0-9]*|0)
HEX (0[xX][0-9a-fA-F]+)
OCT (0[0-7]+)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t ]
commentbegin "/*"
commentend "*/"
commentline "//"
commentelement [^\n]

%x BLOCKCOMMENT
%x LINECOMMENT











%%

"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("INT", "int");
    #else
        return INT;
    #endif
}
"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("VOID", "void");
    #else
        return VOID;
    #endif 
}
"while" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("WHILE", "while");
    #else
        return WHILE;
    #endif
}
"for" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("FOR", "for");
    #else
        return FOR;
    #endif
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("IF", "if");
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("ELSE", "else");
    #else
        return ELSE;
    #endif
};
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("RETURN", "return");
    #else
        return RETURN;
    #endif
}

"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("ASSIGN", "=");
    #else
        return ASSIGN;
    #endif
}
"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("LESS", "<");
    #else
        return LESS;
    #endif
}
">" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("GREAT", ">");
    #else
        return GREAT;
    #endif
}
"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("ADD", "+");
    #else
        return ADD;
    #endif
}
"-" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("SUB", "-");
    #else
        return SUB;
    #endif
}
"*" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("STAR", "*");
    #else
        return STAR;
    #endif
}

"==" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("EQUAL", "==");
    #else
        return EQUAL;
    #endif
}

"！=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("NOEQUAL", "!=");
    #else
        return NOEQUAL;
    #endif
}


";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("SEMICOLON", ";");
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("LPAREN", "(");
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("RPAREN", ")");
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        Symtab *newScope = new Symtab();
        newScope->parent = nowScope;
        nowScope->subScopes.push_back(newScope);
        nowScope = newScope;
        DEBUG_FOR_LAB4_TABLE("LBRACE", "{");
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        nowScope = nowScope->parent;
        DEBUG_FOR_LAB4_TABLE("RBRACE", "}");
    #else
        return RBRACE;
    #endif
}
{HEX} {
    stringstream conv;
    int temp;
    conv << hex << yytext;
    conv >> temp;
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("HEX", yytext, to_string(temp));
    #else
        return HEX;
    #endif
}
{OCT} {
    stringstream conv;
    int temp;
    conv << oct << yytext;
    conv >> temp;
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("OCT", yytext, to_string(temp));
    #else
        return OCT;
    #endif
}
{DECIMIAL} {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4_TABLE("DECIMAL", yytext);
    #else
    return INTEGER;
    #endif
}
{ID} {
    #ifdef ONLY_FOR_LEX
        // Symtab *temp = nowScope; 
        // while(temp != NULL) //向上遍历符号表树
        // {
        //     if(temp->idAttrMap.find(yytext) != temp->idAttrMap.end()) //找到了
        //     {
        //         DEBUG_FOR_LAB4_TABLE("ID", yytext, to_string(temp->idAttrMap[yytext]));
        //         break;
        //     }
        //     temp = temp->parent;
        // }
        // if(temp == NULL) //没找到
        // {
        //     nowScope->idAttrMap[yytext] = nowIdAttr;
        //     DEBUG_FOR_LAB4_TABLE("ID", yytext, to_string(nowIdAttr));
        //     nowIdAttr++;
        // }
        // 虽然我们的设计兼容了在local中重定义global变量的要求，
        // 但是在LAB4中我们没有语法分析器的帮助，
        // 是无从得知变量定义的时间的，因此封存该段代码
        stringstream ss;
        if(nowScope->idAttrMap.find(yytext) == nowScope->idAttrMap.end()) //没找到
        {
            nowScope->idAttrMap[yytext] = nowIdAttr;
            ss << nowIdAttr;
            nowIdAttr++;
        }
        else //找到了
        {
            ss << nowScope->idAttrMap[yytext];      
        }
        ss << "    " << nowScope;
        DEBUG_FOR_LAB4_TABLE("ID", yytext, ss.str());
    #else
    return ID;
    #endif
}
{commentbegin} {
    BEGIN BLOCKCOMMENT;
}
<BLOCKCOMMENT>{commentelement} {
}
<BLOCKCOMMENT>{EOL} {
    yylineno++;
}
<BLOCKCOMMENT>{commentend} {
    BEGIN INITIAL;
}

{commentline} {
    BEGIN LINECOMMENT;
}
<LINECOMMENT>{commentelement} {
}
<LINECOMMENT>{EOL} {
    yylineno++;
    BEGIN INITIAL;
}


{EOL} yylineno++;
{WHITE}
%%


#ifdef ONLY_FOR_LEX
int main(int argc, char **argv){
    globalScope.parent = NULL;
    if(argc != 5){
        fprintf(stderr, "Argument Not Enough");
        exit(EXIT_FAILURE);
    }

    if(!(yyin = fopen(argv[1], "r"))){
        fprintf(stderr, "No such file or directory: %s", argv[1]);
        exit(EXIT_FAILURE);
    }

    if(!(yyout = fopen(argv[3], "w"))){
        fprintf(stderr, "No such file or directory: %s", argv[3]);
        exit(EXIT_FAILURE);
    }

    yylex();
    return 0;
}
#endif
