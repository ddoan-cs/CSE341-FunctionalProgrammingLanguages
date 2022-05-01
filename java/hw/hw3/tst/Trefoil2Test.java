import org.junit.Test;
import trefoil2.*;

import static junit.framework.TestCase.assertEquals;

public class Trefoil2Test {
    // ---------------------------------------------------------------------------------------------
    // Expression tests
    // ---------------------------------------------------------------------------------------------

    @Test
    public void testIntLit() {
        assertEquals(Expression.ofInt(3),
                Interpreter.interpretExpression(Expression.parseString("3")));
    }

    @Test
    public void testIntLitNegative() {
        assertEquals(Expression.ofInt(-10),
                Interpreter.interpretExpression(Expression.parseString("-10")));
    }

    @Test
    public void testBoolLitTrue() {
        assertEquals(new Expression.BooleanLiteral(true),
                Interpreter.interpretExpression(Expression.parseString("true")));
    }

    @Test
    public void testBoolLitFalseParsing() {
        assertEquals(Expression.ofBoolean(false), Expression.parseString("false"));
    }

    @Test
    public void testBoolLitFalse() {
        assertEquals(new Expression.BooleanLiteral(false),
                Interpreter.interpretExpression(Expression.parseString("false")));
    }

    @Test(expected = Trefoil2.TrefoilError.AbstractSyntaxError.class)
    public void testEmptyParen() {
        Interpreter.interpretExpression(Expression.parseString("()"));
    }

    @Test
    public void testVar() {
        assertEquals(Expression.ofInt(3),
                Interpreter.interpretExpression(Expression.parseString("x"),
                        Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(3))));
    }

    @Test(expected = Trefoil2.TrefoilError.RuntimeError.class)
    public void testVarNotFound() {
        Interpreter.interpretExpression(Expression.parseString("x"));
    }

    @Test
    public void testPlus() {
        assertEquals(Expression.ofInt(3),
                Interpreter.interpretExpression(Expression.parseString("(+ 1 2)")));
    }

    @Test(expected = Trefoil2.TrefoilError.AbstractSyntaxError.class)
    public void testPlusMissingOneArg() {
        Interpreter.interpretExpression(Expression.parseString("(+ 1)"));
    }

    @Test(expected = Trefoil2.TrefoilError.RuntimeError.class)
    public void testPlusTypeError() {
        assertEquals(Expression.ofInt(3),
                Interpreter.interpretExpression(Expression.parseString("(+ 1 true)")));
    }

    @Test
    public void testMinus() {
        assertEquals(Expression.ofInt(-1),
                Interpreter.interpretExpression(Expression.parseString("(- 1 2)")));
    }

    @Test
    public void testTimes() {
        assertEquals(Expression.ofInt(6),
                Interpreter.interpretExpression(Expression.parseString("(* 2 3)")));
    }

    @Test
    public void testEqualsIntTrue() {
        assertEquals(Expression.ofBoolean(true),
                Interpreter.interpretExpression(Expression.parseString("(= 3 (+ 1 2))")));
    }

    @Test
    public void testEqualsIntFalse() {
        assertEquals(Expression.ofBoolean(false),
                Interpreter.interpretExpression(Expression.parseString("(= 4 (+ 1 2))")));
    }

    @Test(expected = Trefoil2.TrefoilError.RuntimeError.class)
    public void testEqualsIntWrongType() {
        Interpreter.interpretExpression(Expression.parseString("(= 4 true)"));
    }

    @Test
    public void testIfTrue() {
        assertEquals(Expression.ofInt(0),
                Interpreter.interpretExpression(Expression.parseString("(if true 0 1)")));
    }

    @Test
    public void testIfFalse() {
        assertEquals(Expression.ofInt(1),
                Interpreter.interpretExpression(Expression.parseString("(if false 0 1)")));
    }

    @Test
    public void testIfNonBool() {
        // anything not false is true
        // different from how (test ...) bindings are interpreted!!
        assertEquals(Expression.ofInt(0),
                Interpreter.interpretExpression(Expression.parseString("(if 5 0 1)")));
    }

    @Test
    public void testIfNoEval() {
        // since the condition is true, the interpreter should not even look at the else branch.
        assertEquals(Expression.ofInt(0),
                Interpreter.interpretExpression(Expression.parseString("(if true 0 x)")));
    }

    @Test
    public void testPutVariable() {
        Interpreter.DynamicEnvironment env = Interpreter.DynamicEnvironment.empty();
        env.putVariable("x", Expression.ofInt(42));

        assertEquals(Expression.ofInt(42), env.getVariable("x"));
    }

    @Test
    public void testLet() {
        assertEquals(Expression.ofInt(4),
                Interpreter.interpretExpression(Expression.parseString("(let ((x 3)) (+ x 1))")));
    }

    @Test
    public void testLetShadow1() {
        assertEquals(Expression.ofInt(2),
                Interpreter.interpretExpression(Expression.parseString("(let ((x 1)) (let ((x 2)) x))")));
    }

    @Test
    public void testLetShadow2() {
        assertEquals(Expression.ofInt(21),
                Interpreter.interpretExpression(Expression.parseString("(let ((x 2)) (* (let ((x 3)) x) (+ x 5)))")));
    }

    @Test
    public void testComment() {
        assertEquals(Expression.ofInt(3),
                Interpreter.interpretExpression(Expression.parseString("(+ ;asdf asdf asdf\n1 2)")));
    }

    @Test
    public void testNil() {
        assertEquals(Expression.nil(),
                Interpreter.interpretExpression(Expression.parseString("nil")));
    }

    @Test
    public void testCons() {
        assertEquals(Expression.cons(Expression.ofInt(1), Expression.ofInt(2)),
                Interpreter.interpretExpression(Expression.parseString("(cons 1 2)")));
    }

    // TODO: add tests for nil? and cons? here

    @Test
    public void testCar() {
        assertEquals(Expression.ofInt(1),
                Interpreter.interpretExpression(Expression.parseString("(car (cons 1 2))")));
    }

    @Test
    public void testCdr() {
        assertEquals(Expression.ofInt(2),
                Interpreter.interpretExpression(Expression.parseString("(cdr (cons 1 2))")));
    }

    // ---------------------------------------------------------------------------------------------
    // Binding tests
    // ---------------------------------------------------------------------------------------------

    @Test
    public void testVarBinding() {
        assertEquals(Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(3)),
                Interpreter.interpretBinding(Binding.parseString("(define x (+ 1 2))")));
    }

    @Test
    public void testVarBindingLookup() {
        Interpreter.DynamicEnvironment env = Interpreter.interpretBinding(Binding.parseString("(define x (+ 1 2))"));

        assertEquals(Expression.ofInt(3), env.getVariable("x"));
    }

    @Test(expected = Trefoil2.TrefoilError.AbstractSyntaxError.class)
    public void testBindingEmptyParen() {
        Interpreter.interpretBinding(Binding.parseString("()"));
    }

    @Test
    public void testTopLevelExpr() {
        // We don't test anything about the answer, since the interpreter just prints it to stdout,
        // and it would be too much work to try to capture this output for testing.
        // Instead, we just check that the environment is unchanged.
        Interpreter.DynamicEnvironment env = Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(3));
        assertEquals(env, Interpreter.interpretBinding(Binding.parseString("(* 2 x)"), env));
    }

    @Test
    public void testTestBindingPass() {
        // Who tests the tests??
        Interpreter.DynamicEnvironment env = Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(3));

        // just check that no exception is thrown here
        Interpreter.interpretBinding(Binding.parseString("(test (= 3 x))"), env);
    }

    @Test(expected = Trefoil2.TrefoilError.RuntimeError.class)
    public void testTestBindingFail() {
        Interpreter.DynamicEnvironment env = Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(3));
        Interpreter.interpretBinding(Binding.parseString("(test (= 2 x))"), env);
    }

    @Test(expected = Trefoil2.TrefoilError.RuntimeError.class)
    public void testTestBindingBadData() {
        Interpreter.DynamicEnvironment env = Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(3));
        Interpreter.interpretBinding(Binding.parseString("(test x)"), env);
    }

    @Test
    public void testFunctionBinding() {
        Interpreter.DynamicEnvironment env =
                Interpreter.interpretBinding(
                        Binding.parseString("(define (f x) (+ x 1))"));
        env = Interpreter.interpretBinding(
                Binding.parseString("(define y (f 2))"),
                env
        );
        assertEquals(
                Expression.ofInt(3),
                Interpreter.interpretExpression(Expression.parseString("y"), env)
        );
    }

    @Test
    public void testFunctionBindingLexicalScope() {
        Interpreter.DynamicEnvironment env =
                Interpreter.interpretBinding(
                        Binding.parseString("(define (f y) (+ x y))"),
                        Interpreter.DynamicEnvironment.singleton("x", Expression.ofInt(1))
                );
        env = Interpreter.interpretBinding(
                Binding.parseString("(define z (let ((x 2)) (f 3)))"),
                env
        );
        assertEquals(
                Expression.ofInt(4),
                Interpreter.interpretExpression(Expression.parseString("z"), env)
        );
    }

    @Test
    public void testFunctionBindingRecursive() {
        String program =
                "(define (pow base exp) " +
                        "(if (= exp 0) " +
                        "    1 " +
                        "    (* base (pow base (- exp 1)))))";
        Interpreter.DynamicEnvironment env =
                Interpreter.interpretBinding(
                        Binding.parseString(program)
                );
        env = Interpreter.interpretBinding(
                Binding.parseString("(define x (pow 2 3))"),
                env
        );
        assertEquals(
                Expression.ofInt(8),
                Interpreter.interpretExpression(Expression.parseString("x"), env)
        );
    }

    public static String countdownBinding =
            "(define (countdown n) " +
                    "(if (= n 0) " +
                    "    nil " +
                    "    (cons n (countdown (- n 1)))))";
    @Test
    public void testFunctionBindingListGenerator() {
        Interpreter.DynamicEnvironment env =
                Interpreter.interpretBinding(
                        Binding.parseString(countdownBinding)
                );
        env = Interpreter.interpretBinding(
                Binding.parseString("(define x (car (cdr (countdown 10))))"),
                env
        );
        Expression ans = Interpreter.interpretExpression(Expression.parseString("x"), env);
        assertEquals(Expression.ofInt(9), ans);
    }

    @Test
    public void testFunctionBindingListConsumer() {
        String sumBinding =
                "(define (sum l) " +
                        "(if (nil? l) " +
                        "    0 " +
                        "    (+ (car l) (sum (cdr l)))))";
        System.out.println(sumBinding);
        Interpreter.DynamicEnvironment env = Interpreter.DynamicEnvironment.empty();
        env = Interpreter.interpretBinding(Binding.parseString(countdownBinding), env);
        env = Interpreter.interpretBinding(Binding.parseString(sumBinding), env);
        env = Interpreter.interpretBinding(
                Binding.parseString("(define x (sum (countdown 10)))"),
                env
        );
        assertEquals(
                Expression.ofInt(55),
                Interpreter.interpretExpression(Expression.parseString("x"), env)
        );
    }

    // TODO: add a test for your new top-level "test" binding here
}
