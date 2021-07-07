%namespace GPPGParserScanner

%using SimplePascalParser;

Alpha [a-zA-Z_]
Digit [0-9]
AlphaDigit {Alpha}|{Digit}
INTNUM {Digit}+
REALNUM {Digit}+,{Digit}+
ID {Alpha}{AlphaDigit}* 
CHARACTER '[^'\n]'
%%

":=" { return (int)Tokens.ASSIGN; }
";" { return (int)Tokens.SEMICOLUMN; }
"-" { return (int)Tokens.MINUS; }
"+" { return (int)Tokens.PLUS; }
"*" { return (int)Tokens.MULT; }
"/" { return (int)Tokens.DIVIDE; }
"<" { return (int)Tokens.LT; }
">" { return (int)Tokens.GT; }
"<=" { return (int)Tokens.LE; }
">=" { return (int)Tokens.GE; }
"=" { return (int)Tokens.EQ; }
"<>" { return (int)Tokens.NE; }
"(" { return (int)Tokens.LPAREN; }
")" { return (int)Tokens.RPAREN; }
"," { return (int)Tokens.COMMA; }
"." { return (int)Tokens.DOT; }
":" { return (int)Tokens.COLON; }
\x01 { return (int)Tokens.INVISIBLE; }

{ID}  { 
  int res = Keywords.KeywordOrIDToken(yytext);
  if (res == (int)Tokens.ID)
    yylval.sVal = yytext;
  return res;
}

{INTNUM} { 
  yylval.iVal = int.Parse(yytext); 
  return (int)Tokens.INTNUM; 
}

{REALNUM} {
  yylval.rVal = double.Parse(yytext);
  return (int)Tokens.REALNUM;
}

{CHARACTER} { 
  yylval.cVal = yytext[1]; 
  return (int)Tokens.CHARACTER; 
}

%{
  yylloc = new QUT.Gppg.LexLocation(tokLin, tokCol, tokELin, tokECol);
%}

%%

  public override void yyerror(string format, params object[] args) 
  {
    string errorMsg = PT.CreateErrorString(args);
    PT.AddError(errorMsg,yylloc);
  }

// Статический класс, определяющий ключевые слова языка
public static class Keywords
{
	private static Dictionary<string, int> keywords = new Dictionary<string, int>();

	static Keywords()
	{
		keywords.Add("TRUE", (int)Tokens.TRUE);
		keywords.Add("FALSE", (int)Tokens.FALSE);
		keywords.Add("AND", (int)Tokens.AND);
		keywords.Add("NOT", (int)Tokens.NOT);
		keywords.Add("ODD", (int)Tokens.ODD);
		keywords.Add("OR", (int)Tokens.OR);
		keywords.Add("IF", (int)Tokens.IF);
		keywords.Add("THEN", (int)Tokens.THEN);
		keywords.Add("ELSE", (int)Tokens.ELSE);
		keywords.Add("BEGIN", (int)Tokens.BEGIN);
		keywords.Add("END", (int)Tokens.END);
		keywords.Add("WHILE", (int)Tokens.WHILE);
		keywords.Add("DO", (int)Tokens.DO);
		keywords.Add("BOOLEAN", (int)Tokens.BOOLEAN);
		keywords.Add("INTEGER", (int)Tokens.INTEGER);
		keywords.Add("REAL", (int)Tokens.REAL);
		keywords.Add("CHAR", (int)Tokens.CHAR);
		keywords.Add("PROGRAM", (int)Tokens.PROGRAM);
		keywords.Add("CONST", (int)Tokens.CONST);
		keywords.Add("VAR", (int)Tokens.VAR);
		keywords.Add("PROCEDURE", (int)Tokens.PROCEDURE);
		keywords.Add("DIV", (int)Tokens.DIV);
		keywords.Add("MOD", (int)Tokens.MOD);
		keywords.Add("FOR", (int)Tokens.FOR);
		keywords.Add("TO", (int)Tokens.TO);
		keywords.Add("STEP", (int)Tokens.STEP);
		
	}
	public static int KeywordOrIDToken(string s)
	{
		s = s.ToUpper();
		if (keywords.ContainsKey(s))
			return keywords[s];
		else
			return (int)Tokens.ID;
	}
}
  
