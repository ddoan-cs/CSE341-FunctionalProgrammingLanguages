import java.io.*;
import java.util.*;

/**
 * Interpreter for the Trefoil v1 language.
 *
 * The interpreter's state is a stack of integers.
 *
 * The interpreter also implements a main method to accept input from the keyboard or a file.a
 */
public class Trefoil {
    /**
     * Contains information about the state
     */
    Stack<Integer> values;

    /**
     * Initializes a stack to track the state of the interpreter
     */
    public Trefoil() {
        values = new Stack<>();
    }

    public static void main(String[] args) {
        Trefoil trefoil = new Trefoil();

        if (args.length == 0) {
            trefoil.interpret(new Scanner(System.in));
        } else if (args.length == 1) {
            try {
                trefoil.interpret(new Scanner(new File(args[0])));
            } catch (FileNotFoundException e) {
                System.out.println("File argument not found.");
                System.exit(1);
            } catch (TrefoilError e) {
                System.exit(1);
            }

        } else {
            System.err.println("Expected 0 or 1 arguments but got " + args.length);
            System.exit(1);
        }

        // print the stack
        System.out.println(trefoil);
    }

    /**
     * Interprets the program given by the scanner.
     */
    public void interpret(Scanner scanner) {
        while (scanner.hasNext()) {
            //Pushes integers onto the stack
            if (scanner.hasNextInt()) {
                values.push(scanner.nextInt());
            }
            else {
                String token = scanner.next();

                //Checks for comments and does nothing
                if (token.startsWith(";")) {
                }
                //Pops two values off stack and pushes back sum
                else if (token.equals(".") && values.size() >= 1) {
                    System.out.println(values.pop());
                }
                else if (values.size() >= 2) {
                    if (token.equals("+")) {
                        values.push(values.pop() + values.pop());
                    }
                    //Pops two values off stack and pushes back difference (second value - first value)
                    else if (token.equals("-")) {
                        int value1 = values.pop();
                        int value2 = values.pop();
                        values.push(value2 - value1);
                    }
                    //Pops two values off stack and pushes back product
                    else if (token.equals("*")) {
                        values.push(values.pop() * values.pop());
                    }
                    else {
                        throw new TrefoilError("Operation does not exist.");
                    }
                    //Throws exception if token is not found
                }
                else {
                    throw new TrefoilError("Illegal number of arguments in stack.");
                }

            }
        }
        System.out.println(values);
    }

    /**
     * Convenience method to interpret the given string. Useful for unit tests.
     */
    public void interpret(String input) {
        // Don't change this method unless you know what you're doing.
        interpret(new Scanner(input));
    }

    /**
     * Pop a value off the stack and return it. Useful for unit tests.
     *
     * @throws TrefoilError if there are no elements on the stack.
     */
    public int pop() {
        if (values.isEmpty()) {
            throw new TrefoilError("There are no values to pop from the stack");
        }
        return values.pop();
    }

    @Override
    public String toString() {
        String output = "";
        if (values.isEmpty()) {
            return output;
        }
        for (Integer integer : values) {
            output += integer + " ";
        }
        return output.trim();
    }

    /**
     * Throw this error whenever your interpreter detects a problem.
     *
     */
    public static class TrefoilError extends RuntimeException {
        public TrefoilError(String message) {
            super(message);
        }
    }
}
