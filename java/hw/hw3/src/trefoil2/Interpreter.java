package trefoil2;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

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
            // TODO: the following return statement is wrong because it does not correctly check
            //       for run-time type errors. fix it by checking that both children evaluated to
            //       IntegerLiterals and if not throwing TrefoilError.RuntimeError.
            return new Expression.IntegerLiteral(
                    ((Expression.IntegerLiteral) v1).getData() +
                            ((Expression.IntegerLiteral) v2).getData()
            );


        // TODO: implement semantics for new AST nodes here, following the examples above
        // TODO: be sure to check for run-time type errors and throw TrefoilError.RuntimeError.
        // } else if (e instanceof ...) {


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
        // TODO: implement the TestBinding here


        // Otherwise it's a binding AST node we don't recognize. Tell the interpreter implementor.
        throw new Trefoil2.InternalInterpreterError("\"impossible\" binding AST node " + b.getClass());
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
            // TODO: convert this assert to instead throw a TrefoilError.RuntimeError if the variable is not bound
            assert containsVariable(varname);



            // TODO: lookup the variable in the map and return the corresponding value
            // Hint: first, read the code for containsVariable().
            // Hint: you will likely need the value field from Entry.VariableEntry
            return null;
        }

        public void putVariable(String varname, Expression value) {
            // TODO: bind the variable in the backing map
            // Hint: map.put
            // Hint: either call new Entry.VariableEntry or the factory Entry.variable
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
            // TODO: convert this assert to instead throw a TrefoilError.RuntimeError if the function is not bound
            assert containsFunction(funname);

            // TODO: lookup the function in the map and return the corresponding function binding
            // Hint: first, read the code for containsFunction().
            return null;
        }

        public void putFunction(String funname, Binding.FunctionBinding functionBinding) {
            // TODO: bind the function in the backing map
            // Be careful to set up recursion correctly!
            // Hint: Pass definingEnvironment=this to the Entry.function factory, and then call map.put.
            //       That way, by the time Trefoil calls the function, everything points to
            //       the right place. Tricky!
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
