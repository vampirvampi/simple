cls
GPLex_GPPG\gplex.exe /unicode SimplePascal.lex
GPLex_GPPG\gppg.exe /no-lines /gplex SimplePascal.y

copy ..\..\bin\SyntaxTree.dll DLL\SyntaxTree.dll
%windir%\microsoft.net\framework\v3.5\msbuild /t:rebuild /property:Configuration=Release SimplePascal.sln

copy bin\Release\SimplePascalParser.dll Install\PascalABC.NET\SimplePascalParser.dll
