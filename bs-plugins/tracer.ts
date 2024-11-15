import { CompilerPlugin, BeforePrepareFileEvent, isBrsFile, WalkMode, createVisitor, TokenKind, ExpressionStatement, LiteralExpression, TaggedTemplateStringExpression, OnGetCodeActionsEvent, createToken, SourceLiteralExpression, Parser, ParseMode, PrintStatement } from 'brighterscript';

export default function () {
  return {
    name: 'traceFunctionCalls',
    beforePrepareFile: (event: BeforePrepareFileEvent) => {

      if (!isBrsFile(event.file)) return
      const ignorePaths = (event.program.options as any)?.tracer?.ignorePaths ?? []
      // return if event.file.pkgPath includes one of the ignore paths
      if (ignorePaths.some((path: string) => event.file.pkgPath?.includes(path) ?? false)) return

      event.file.ast.walk(createVisitor({
        FunctionExpression: (func) => {
          const printStatement = new PrintStatement(
            {
              print: createToken(TokenKind.Print),
              expressions: [
                new SourceLiteralExpression({
                  value: createToken(TokenKind.FunctionNameLiteral, 'FUNCTION_NAME', func.location)
                }),
                new LiteralExpression({
                  value: createToken(TokenKind.Print, '" "', func.location)
                }),
                new SourceLiteralExpression({
                  value: createToken(TokenKind.SourceLocationLiteral)
                }),
              ]
            }
          );
          func.body.statements.unshift(printStatement);
        }
      }), {
        walkMode: WalkMode.visitExpressionsRecursive
      });
    }
  } as CompilerPlugin;
}
