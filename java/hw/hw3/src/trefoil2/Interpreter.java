package trefoil2;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Interprets expressions and bindings in the context of a dynamic environment
 * according to the semantics of Trefoil v2.
 */
public class Interpreter {
    /**
     * Evaluates e in the given environment. Returns the resulting value.
     *
     * Throws TrefoilError.RuntimeError when the Trefoil programmer makes a mistake.
     */
    public static Expression interpretExpression(Expression e, DynamicEnvironment environment) {
        if (e instanceof Expression.IntegerLiteral) {
            return e;
        } else if (e instanceof Expression.VariableReference) {
            Expression.VariableReference var = (Expression.VariableReference) e;
            return environment.getVariable(var.getVarname());
        } else if (e instanceof Expression.Plus) {
            Expression.Plus p = (Expression.Plus) e;
            Expression v1 = interpretExpression(p.getLeft(), environment);
            Expression v2 = interpretExpression(p.getRight(), environment);
            if (v1 instanceof Expression.IntegerLiteral && v2 instanceof Expression.IntegerLiteral) {
                return new Expression.IntegerLiteral(
                        ((Expression.IntegerLiteral) v1).getData() +
                                ((Expression.IntegerLiteral) v2).getData()
                );
            } else {
                throw new Trefoil2.TrefoilError.RuntimeError("The arguments given are not valid.");
            }
        } else if (e instanceof Expression.Minus) {
            Expression.Minus m = (Expression.Minus) e;
            Expression v1 = interpretExpression(m.getLeft(), environment);
            Expression v2 = interpretExpression(m.getRight(), environment);
            if (v1 instanceof Expression.IntegerLiteral && v2 instanceof Expression.IntegerLiteral) {
                return new Expression.IntegerLiteral(
                        ((Expression.IntegerLiteral) v1).getData() -
                                ((Expression.IntegerLiteral) v2).getData()
                );
            } else {
                throw new Trefoil2.TrefoilError.RuntimeError("The arguments given are not valid.");
            }
        } else if (e instanceof Expression.Times) {
            Expression.Times t = (Expression.Times) e;
            Expression v1 = interpretExpression(t.getLeft(), environment);
            Expression v2 = interpretExpression(t.getRight(), environment);
            if (v1 instanceof Expression.IntegerLiteral && v2 instanceof Expression.IntegerLiteral) {
                return new Expression.IntegerLiteral(
                        ((Expression.IntegerLiteral) v1).getData() *
                                ((Expression.IntegerLiteral) v2).getData()
                );
            } else {
                throw new Trefoil2.TrefoilError.RuntimeError("The arguments given are not valid.");
            }
        } else if (e instanceof Expression.Div) {
            Expression.Div d = (Expression.Div) e;
            Expression v1 = interpretExpression(d.getLeft(), environment);
            Expression v2 = interpretExpression(d.getRight(), environment);
            if (v1 instanceof Expression.IntegerLiteral && v2 instanceof Expression.IntegerLiteral) {
                return new Expression.IntegerLiteral(
                        ((Expression.IntegerLiteral) v1).getData() /
                                ((Expression.IntegerLiteral) v2).getData()
                );
            } else {
                throw new Trefoil2.TrefoilError.RuntimeError("The arguments given are not valid.");
            }
        }else if (e instanceof Expression.Equals) {
            Expression.Equals eq = (Expression.Equals) e;
            Expression v1 = interpretExpression(eq.getLeft(), environment);
            Expression v2 = interpretExpression(eq.getRight(), environment);
            if (v1 instanceof Expression.IntegerLiteral && v2 instanceof Expression.IntegerLiteral) {
                return new Expression.BooleanLiteral(
                        ((Expression.IntegerLiteral) v1).getData() ==
                                ((Expression.IntegerLiteral) v2).getData()
                );
            } else {
                throw new Trefoil2.TrefoilError.RuntimeError("The arguments given are not valid.");
            }
        } else if (e instanceof Expression.Let) {
            Expression.Let l = (Expression.Let) e;
            Expression v1 = interpretExpression(l.getDef(), environment);
            DynamicEnvironment env = environment.extendVariable(l.getName(), v1);
            Expression v2 = interpretExpression(l.getBody(), env);
            env = environment.extendVariable(l.getName(), v2);
            return env.getVariable(l.getName());
        } else if (e instanceof Expression.Car) {
            Expression.Car c = (Expression.Car) e;
            Expression.Cons v1 = (Expression.Cons) interpretExpression(c.getExp(), environment);
            return interpretExpression(v1.getLeft(), environment);
        } else if (e instanceof Expression.Cdr) {
            Expression.Cdr c = (Expression.Cdr) e;
            Expression.Cons v1 = (Expression.Cons) interpretExpression(c.getExp(), environment);
                return interpretExpression(v1.getRight(), environment);
        }
        else if (e instanceof Expression.NilQ) {
            Expression.NilQ c = (Expression.NilQ) e;
            Expression v1 = interpretExpression(c.getExp(), environment);
            if (v1 instanceof Expression.Nil) {
                return new Expression.BooleanLiteral(true);
            } else {
                return new Expression.BooleanLiteral(false);
            }
        }
        else if (e instanceof Expression.ConQ) {
            Expression.ConQ c = (Expression.ConQ) e;
            if (!(c.getExp() instanceof Expression.IntegerLiteral) && !(c.getExp() instanceof Expression.BooleanLiteral) &&
                    !(c.getExp() instanceof Expression.Nil)) {
                return new Expression.BooleanLiteral(true);
            } else {
                return new Expression.BooleanLiteral(false);
            }
        }
        else if (e instanceof Expression.If) {
            Expression.If i = (Expression.If) e;
            Expression v1 = interpretExpression(i.getOne(), environment);
            Expression v2 = interpretExpression(i.getTwo(), environment);
            if (v1 instanceof Expression.BooleanLiteral) {
                if (((Expression.BooleanLiteral) v1).isData()) {
                    return v2;
                } else {
                    return interpretExpression(i.getThree(), environment);
                }
            } else {
                return v2;
            }
        } else if (e instanceof Expression.Function) {
            Expression.Function f = (Expression.Function) e;
            List<Expression> args = f.getExps();
            DynamicEnvironment.Entry.FunctionEntry entry = environment.getFunction(f.getName());
            List<String> params = entry.getFunctionBinding().getArgnames();
            DynamicEnvironment defenv = entry.getDefiningEnvironment();

            if (args.size() != params.size()) {
                throw new Trefoil2.TrefoilError.RuntimeError("There are not the right number of args.");
            }
            List<Expression> vals = new ArrayList<>();
            for (Expression arg : args) {
                vals.add(interpretExpression(arg, environment));
            }
            return interpretExpression(entry.getFunctionBinding().getBody(), defenv.extendVariables
                    (params, vals));

        } else if (e instanceof Expression.BooleanLiteral) {
            return e;
        } else if (e instanceof Expression.Nil) {
            return e;
        } else if (e instanceof Expression.Cons) {
            return e;
        } else {
            // Otherwise it's an expression AST node we don't recognize. Tell the interpreter implementor.
            throw new Trefoil2.InternalInterpreterError("\"impossible\" expression AST node " + e.getClass());
        }
    }

    /**
     * Executes the binding in the given environment, returning the new environment.
     *
     * The environment passed in as an argument is *not* mutated. Instead, it is copied
     * and any modifications are made on the copy and returned.
     *
     * Throws TrefoilError.RuntimeError when the Trefoil programmer makes a mistake.
     */
    public static DynamicEnvironment interpretBinding(Binding b, DynamicEnvironment environment) {
        if (b instanceof Binding.VariableBinding) {
            Binding.VariableBinding vb = (Binding.VariableBinding) b;
            Expression value = interpretExpression(vb.getVardef(), environment);
            System.out.println(vb.getVarname() + " = " + value);
            return environment.extendVariable(vb.getVarname(), value);
        } else if (b instanceof Binding.TopLevelExpression) {
            Binding.TopLevelExpression tle = (Binding.TopLevelExpression) b;
            System.out.println(interpretExpression(tle.getExpression(), environment));
            return environment;
        } else if (b instanceof Binding.FunctionBinding) {
            Binding.FunctionBinding fb = (Binding.FunctionBinding) b;
            DynamicEnvironment newEnvironment = environment.extendFunction(fb.getFunname(), fb);
            System.out.println(fb.getFunname() + " is defined");
            return newEnvironment;
        }
        else if (b instanceof Binding.TestBinding) {
            Binding.TestBinding tb = (Binding.TestBinding) b;
            Expression bool = (interpretExpression(tb.getExpression(), environment));
            System.out.println(bool);
            if (!(bool.equals(Expression.ofBoolean(true)))) {
                throw new Trefoil2.TrefoilError.RuntimeError("Test has failed.");
            }
            return environment;
        } else {
            // Otherwise it's a binding AST node we don't recognize. Tell the interpreter implementor.
            throw new Trefoil2.InternalInterpreterError("\"impossible\" binding AST node " + b.getClass());
        }
    }


    // Convenience methods for interpreting in the empty environment.
    // Used for testing.
    public static Expression interpretExpression(Expression e) {
        return interpretExpression(e, new DynamicEnvironment());
    }
    public static DynamicEnvironment interpretBinding(Binding b) {
        return interpretBinding(b, DynamicEnvironment.empty());
    }


    /**
     * Represents the dynamic environment, which is a mapping from strings to "entries".
     * In the starter code, the string always represents a variable name and an entry is always a VariableEntry.
     * You will extend it to also support function names and FunctionEntries.
     */
    @Data
    public static class DynamicEnvironment {
        public static abstract class Entry {
            @EqualsAndHashCode(callSuper = false)
            @Data
            public static class VariableEntry extends Entry {
                private final Expression value;
            }

            @EqualsAndHashCode(callSuper = false)
            @Data
            public static class FunctionEntry extends Entry {
                private final Binding.FunctionBinding functionBinding;

                @ToString.Exclude
                private final DynamicEnvironment definingEnvironment;
            }

            // Convenience factory methods

            public static Entry variable(Expression value) {
                return new VariableEntry(value);
            }
            public static Entry function(Binding.FunctionBinding functionBinding, DynamicEnvironment definingEnvironment) {
                return new FunctionEntry(functionBinding, definingEnvironment);
            }
        }

        // The backing map of this dynamic environment.
        private final Map<String, Entry> map;

        public DynamicEnvironment() {
            this.map = new HashMap<>();
        }

        public DynamicEnvironment(DynamicEnvironment other) {
            this.map = new HashMap<>(other.getMap());
        }

        private boolean containsVariable(String varname) {
            return map.containsKey(varname) && map.get(varname) instanceof Entry.VariableEntry;
        }

        public Expression getVariable(String varname) {
            if (!(containsVariable(varname))) {
                throw new Trefoil2.TrefoilError.RuntimeError("Unbound variable arguments.");
            }
            Entry.VariableEntry var = (Entry.VariableEntry)map.get(varname);
            return var.value;
        }

        public void putVariable(String varname, Expression value) {
            map.put(varname, new Entry.VariableEntry(value));
        }

        /**
         * Returns a *new* DynamicEnvironment extended by the binding varname -> value.
         *
         * Does not change this! Creates a copy.
         */
        public DynamicEnvironment extendVariable(String varname, Expression value) {
            DynamicEnvironment newEnv = new DynamicEnvironment(this);  // create a copy
            newEnv.putVariable(varname, value);  // mutate the copy
            return newEnv;  // return the mutated copy (this remains unchanged!)
        }

        /**
         * Returns a *new* Dynamic environment extended by the given mappings.
         *
         * Does not change this! Creates a copy.
         *
         * varnames and values must have the same length
         *
         * @param varnames variable names to bind
         * @param values values to bind the variables to
         */
        public DynamicEnvironment extendVariables(List<String> varnames, List<Expression> values) {
            DynamicEnvironment newEnv = new DynamicEnvironment(this);
            assert varnames.size() == values.size();
            for (int i = 0; i < varnames.size(); i++) {
                newEnv.putVariable(varnames.get(i), values.get(i));
            }
            return newEnv;
        }

        private boolean containsFunction(String funname) {
            return map.containsKey(funname) && map.get(funname) instanceof Entry.FunctionEntry;
        }

        public Entry.FunctionEntry getFunction(String funname) {
            if (!(containsFunction(funname))) {
                throw new Trefoil2.TrefoilError.RuntimeError("Unbound variable arguments.");
            }
            return (Entry.FunctionEntry)map.get(funname);
            // TODO: convert this assert to instead throw a TrefoilError.RuntimeError if the function is not bound

            // TODO: lookup the function in the map and return the corresponding function binding
            // Hint: first, read the code for containsFunction().
        }

        public void putFunction(String funname, Binding.FunctionBinding functionBinding) {
            Entry.FunctionEntry fun = new Entry.FunctionEntry(functionBinding, this);
            map.put(funname, fun);
        }

        public DynamicEnvironment extendFunction(String funname, Binding.FunctionBinding functionBinding) {
            DynamicEnvironment newEnv = new DynamicEnvironment(this);  // create a copy of this
            newEnv.putFunction(funname, functionBinding);  // mutate the copy
            return newEnv;  // return the copy
        }

        // Convenience factory methods

        public static DynamicEnvironment empty() {
            return new DynamicEnvironment();
        }

        public static DynamicEnvironment singleton(String varname, Expression value) {
            return empty().extendVariable(varname, value);
        }
    }
}
