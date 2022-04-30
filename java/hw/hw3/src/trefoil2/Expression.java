package trefoil2;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

/**
 * An expression AST. See LANGUAGE.md for a list of possibilities.
 */
@Data
public abstract class Expression {
    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class IntegerLiteral extends Expression {
        private final int data;

        @Override
        public String toString() {
            return Integer.toString(data);
        }
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class BooleanLiteral extends Expression {
        private final boolean data;

        @Override
        public String toString() {
            return Boolean.toString(data);
        }
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class VariableReference extends Expression {
        private final String varname;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Plus extends Expression {
        private final Expression left, right;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Minus extends Expression {
        private final Expression left, right;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    
    public static class Multiply extends Expression {
=======
    public static class Times extends Expression {
        private final Expression left, right;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Equals extends Expression {
        private final Expression left, right;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Let extends Expression {
        private final String name;
        private final Expression def, body;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Nil extends Expression {
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Cons extends Expression {
        private final Expression left, right;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Car extends Expression {
        private final Expression exp;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Cdr extends Expression {
        private final Expression exp;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class NilQ extends Expression {
        private final Expression exp;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class ConQ extends Expression {
        private final Expression exp;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class If extends Expression {
        private final Expression one,two, three;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Function extends Expression {
        private final String name;
        private final List<Expression> exps;
    }

    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class Div extends Expression {
>>>>>>> ec328d8ad2ee00f33cd92636e84f3c4cf32967aa
        private final Expression left, right;
    }

    // TODO: Your new AST classes here.
    // TODO: Don't forget to copy the @Equals... and @Data annotations onto all your classes.


    // Convenience factory methods
    public static IntegerLiteral ofInt(int x) {
        return new IntegerLiteral(x);
    }
    public static BooleanLiteral ofBoolean(boolean b) {
        return new BooleanLiteral(b);
    }
    public static Expression nil() {
        return new Nil();
    }
    public static Expression cons(Expression e1, Expression e2) {
        return new Cons(e1, e2);
    }

    /**
     * Tries to convert a PST to an Expression.
     *
     * See LANGUAGE.md for a description of how this should work at a high level.
     *
     * If conversion fails, throws TrefoilError.AbstractSyntaxError with a nice message.
     */
    public static Expression parsePST(ParenthesizedSymbolTree pst) {
        // Either the PST is a Symbol or a Node
        if (pst instanceof ParenthesizedSymbolTree.Symbol) {
            // If it is a symbol, it is either a number, a symbol keyword, or a variable reference.
            ParenthesizedSymbolTree.Symbol symbol = (ParenthesizedSymbolTree.Symbol) pst;
            String s = symbol.getSymbol();
            try {
                return Expression.ofInt(Integer.parseInt(s));
            } catch (NumberFormatException e) {
                switch (s) {
                    case "true":
                        return new BooleanLiteral(true);
                    case "false":
                        return new BooleanLiteral(false);
                    case "nil":
                        return new Nil();
                    // if the symbol is not a symbol keyword, then it represents a variable reference
                    default:
                        return new VariableReference(s);
                }
            }
        } else {
            // Otherwise it is a Node, in which case it might be a built-in form with a node keyword,
            // or if not, then it is a function call.
            ParenthesizedSymbolTree.Node n = (ParenthesizedSymbolTree.Node) pst;
            List<ParenthesizedSymbolTree> children = n.getChildren();
            if (children.size() == 0) {
                throw new Trefoil2.TrefoilError.AbstractSyntaxError("Unexpected empty pair of parentheses.");
            }
            String head = ((ParenthesizedSymbolTree.Symbol) children.get(0)).getSymbol();
            switch (head) {
                case "+":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Plus(parsePST(children.get(1)), parsePST(children.get(2)));
                case "-":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Minus(parsePST(children.get(1)), parsePST(children.get(2)));
                case "*":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Times(parsePST(children.get(1)), parsePST(children.get(2)));
                case "=":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Equals(parsePST(children.get(1)), parsePST(children.get(2)));
                case "/":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Div(parsePST(children.get(1)), parsePST(children.get(2)));
                case "let":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    ParenthesizedSymbolTree p = children.get(1);
                    ParenthesizedSymbolTree.Node node = (ParenthesizedSymbolTree.Node) p;
                    List<ParenthesizedSymbolTree> nodeChildren = node.getChildren();
                    ParenthesizedSymbolTree.Node var = (ParenthesizedSymbolTree.Node) nodeChildren.get(0);
                    List<ParenthesizedSymbolTree> varChildren = var.getChildren();
                    if (varChildren.size() != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments," +
                                "a variable and an expression as its first argument and another expression defining it.");
                    }
                    return new Let(((ParenthesizedSymbolTree.Symbol) varChildren.get(0)).getSymbol(),parsePST(varChildren.
                            get(1)), parsePST(children.get(2)));
                case "nil?":
                    if (children.size() - 1 /* -1 for head */ != 1) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new NilQ(parsePST(children.get(1)));
                case "cons?":
                    if (children.size() - 1 /* -1 for head */ != 1) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new ConQ(parsePST(children.get(1)));
                case "car":
                    if (children.size() - 1 /* -1 for head */ != 1) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Car(parsePST(children.get(1)));
                case "cdr":
                    if (children.size() - 1 /* -1 for head */ != 1) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Cdr(parsePST(children.get(1)));
                case "cons":
                    if (children.size() - 1 /* -1 for head */ != 2) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new Cons(parsePST(children.get(1)), parsePST(children.get(2)));
                case "if":
                    if (children.size() - 1 /* -1 for head */ != 3) {
                        throw new Trefoil2.TrefoilError.AbstractSyntaxError("Operator " + head + " expects 2 arguments");
                    }
                    return new If(parsePST(children.get(1)), parsePST(children.get(2)),  parsePST(children.get(3)));
                // if the symbol is not a node keyword, then it represents a function call
                default:
                    // eventually we will add function calls here
                    List<Expression> funcs = new ArrayList<>();
                    for (int i = 1; i < children.size(); i++) {
                        funcs.add(parsePST(children.get(i)));
                    }
                    return new Function(((ParenthesizedSymbolTree.Symbol) children.get(0)).getSymbol(), funcs);
            }
        }
    }

    // Convenience factory method for unit tests.
    public static Expression parseString(String s) {
        return parsePST(ParenthesizedSymbolTree.parseString(s));
    }
}
