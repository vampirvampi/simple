using System;
using System.IO;
using System.Text;
using System.Reflection;
using System.Collections.Generic;
using PascalABCCompiler.SyntaxTree;
using SimplePascalParser;
using PascalABCCompiler.Parsers;
using GPPGParserScanner;

namespace PascalABCCompiler.SimplePascalParser
{
    public class SimplePascalLanguageParser
    {
        public static string LastWord(string s)
        {
            if (s==null)
                return "!!Oops! NoType!!";
            var ss = s.Split('.');
            if (ss[ss.Length - 1]=="")
                return "!!Oops! NoType!!";
            else return ss[ss.Length-1];

        }

        public static void PrintNode(syntax_tree_node n)
        {
            if (n.GetType() == typeof(program_module))
            {
                program_module pm = (program_module)n;
                Console.WriteLine("PROGRAM {0};", pm.program_name.prog_name.name);
                PrintNode(pm.program_block);
                Console.WriteLine(".");
            }
            else if (n.GetType() == typeof(block))
            {
                block b = (block)n;
                PrintNode(b.defs);
                Console.WriteLine("BEGIN");
                PrintNode(b.program_code);
                Console.Write("END");
            }
            else if (n.GetType() == typeof(declarations))
            {
                var ds = (declarations)n;
                foreach (var d in ds.defs)
                    PrintNode(d);
            }
            else if (n.GetType() == typeof(variable_definitions))
            {
                var vd = (variable_definitions)n;
                foreach (var d in vd.var_definitions)
                    PrintNode(d);
            }
            else if (n.GetType() == typeof(var_def_statement))
            {
                var vds = (var_def_statement)n;
                foreach (var d in vds.vars.idents)
                    Console.Write(LastWord(d.ToString())+" ");
                Console.WriteLine(": "+vds.vars_type);
            }
            else if (n.GetType() == typeof(statement_list))
            {
                var sl = (statement_list)n;
                foreach (var d in sl.subnodes)
                    PrintNode(d);
            }
            else if(n.GetType() == typeof(while_node))
            {
                var wh = (while_node)n;
                Console.WriteLine(LastWord(wh.ToString()    ) + " " + LastWord(wh.expr.ToString())+ " " );
                var st = (statement_list)wh.statements;
                foreach (var d in st.subnodes)
                    PrintNode(d);
                
            }
            else if (n.GetType()== typeof(assign))
            {
                var ass = (assign)n;
                Console.WriteLine(LastWord(n.ToString()) + " to " + LastWord(ass.to.ToString()) + " from " + LastWord(ass.from.ToString()));
            }
            else Console.WriteLine(LastWord(n.ToString()));
        }

        public static void Main()
        {
            parse("D:\\Program1.pas");
        }
        public static GPPGParser parse(string filename)
        {
            string FileName = filename;
            StreamReader sr = new StreamReader(FileName);
            string Text = sr.ReadToEnd();
            PT.CurrentFileName = FileName;
            
            Scanner scanner = new Scanner();
            scanner.SetSource(Text, 0);
            
            GPPGParser parser = new GPPGParser(scanner);
                      
            var b = parser.Parse();
            sr.Close();
            if (!b)
            {
                if (PT.Errors.Count == 0)
                    PT.AddError("Неопознанная синтаксическая ошибка!", null);
                Console.WriteLine(PT.Errors[0]);
            }
            else Console.WriteLine("Дерево успешно построено");
            // parser.root содержит корень синтаксического дерева
            if (parser.root != null) { PrintNode(parser.root); }
            
            Console.ReadLine();
            return parser;
        }

    }
}
