# HW3: Trefoil v2

This homework is the next step in our Trefoil journey. You will implement an
interpreter for version 2 of Trefoil, which supports nested syntax based on
parenthesized symbol trees (PSTs). (Everyone except for 22sp 341 calls PSTs
S-expressions, in case you want to Google.)

## Detailed tour of the starter code

This tour is careful to discuss every file, so you might want to only skim this tour on first reading.

You made it into the `hw3/` subdirectory. Here's what you see.
- `README.md`: his file, your guide to HW3
- `LANGUAGE.md`: the specification for Trefoil v2
- `FEEDBACK.md`: our usual questions about homework, to fill out after you're done
- `src/`: Java files implementing the interpreter
- `tst/Trefoil2Test.java`: Unit tests for the interpreter

In `src/` there are several files.
- `trefoil2/Trefoil2.java`: main entry point of the interpreter
  - Skim the main method. We won't ask you change it, but it might be useful for debugging (see comments)
    - Similar to HW1, `main` supports either keyboard or file input
    - It constructs a `PSTParser` and then repeatedly reads PSTs off the input
    - For each PST, it parses it as an *AST* using `Binding.parsePST`, and then interprets the binding.
    - This is the semantics of Trefoil v2 programs!
    - At the end of the program, main prints the final environment.
  - This file also declares `TrefoilError` and its several subclasses, which you will need to throw,
    as well as `InternalInterpreterError`, which you *might* need to throw
- Several files in the `parser/` package implement `PSTParser` that you do *not* need to understand or edit.
  Of course, you are free to read these files if you are curious how they work. They are not very complicated.
  - `PeekCharReader.java`: buffers characters one at a time while tracking line numbers
  - `Tokenizer.java`: splits the input into parentheses, comments, and symbols
  - `PSTParser.java`: constructs a PST from a token stream
- You will need to understand and edit the files in the `trefoil2` package.
  - `ParenthesizedSymbolTree.java`: represents a PST
    - You will need to understand and use (but not edit) the `Symbol` and `Node` classes.
  - `Expression.java`: represents the *abstract* syntax tree (AST) of an expression
    - For every kind of expression in the language, there will be a inner public static subclass of `Expression`,
      similar to the examples like `IntegerLiteral`, `Plus`, etc. in the starter code.
    - We will ask you to use the existing Expression subclasses as well as add several new ones.
    - The method `parsePST` converts (or tries to convert) a PST into an expression AST.
      - For each subclass of `Expression` there should be a case in `parsePST` that produces it from the corresponding PST.
      - Check out the examples in the starter code of symbol keywords and node keywords.
        We will ask you to add more of each kind of keyword as you produce new ASTs that you add.
  - `Binding.java`: represents the AST of a top-level binding
    - For every kind of binding, there is a subclass of `Binding`.
    - You will need to understand the existing bindings. Start with variable bindings.
      Ignore function bindings until later in the assignment..
    - We will ask you to add one new top-level binding.
  - `Interpreter.java`: the interpreter!!
    - Interprets expressions and bindings in the context of a dynamic environment.
    - You will need to understand the starter code in this file *thoroughly*. Your primary task on HW3 is to extend it.
      - `interpretExpression` evaluates an expression to a value in a given dynamic environment
      - `interpretBinding` transforms and returns a new dynamic environment as the result of executing the given binding
      - You will extend both of these functions with several new cases.
    - This file also defines the `DynamicEnvironment` class, which implements a map from strings to "entries".
      You will implement a few of its methods.
      - Variable names map to their values
      - Function names map to a pair of their function binding and their defining environment.

### A note on Lombok

The starter code makes fairly extensive use of `@Data` and `@EqualsAndHashcode`
from [Project Lombok](https://projectlombok.org/). These annotations
automatically generate tedious methods such as `toString`, `equals`, and
`hashCode`, as well as getter and setter methods. We *think* you mostly won't
have to understand how this works at all. But you will have to copy these
annotations on to your own AST classes that you add. We have included a copy of
Lombok in the dependencies of the starter code, and modern versions of IntelliJ
have native support for Lombok.

Please ask questions on Ed if you get stuck!


## Informal description of the language

A Trefoil v2 program is a sequence of bindings which are evaluated in order in a
(initially empty) dynamic environment. The environment can be transformed by
each binding as that binding executes.

### Bindings

There are four kinds of bindings: variable bindings, top-level expressions,
test bindings and (part 2) function bindings.

We have discussed all but test bindings in lecture. See the slides and demo code
for an informal description of those. See `LANGUAGE.md` for a formal description.

Test bindings are written like this example:

```
(test (= 3 (+ 1 2)))
```

A test binding evaluates its expression. If expression evaluates to true, the
test passes and nothing happens to the environment. If the expression evaluates
to *anything other than true* (false or any other value, e.g., 17), the test
fails and a (nice) error is reported to the Trefoil programmer.

### Expressions

There are 16 kinds of expressions. See the lecture material for an informal
introduction and `LANGUAGE.md` for a formal list and description.

The only expressions we did not discuss in lecture are:
- Equality on integers, written `(= (+ 1 2) 3)`. `=` is a binary operator that
  takes two integers, just like `+` does, except that `=` returns a boolean
  indicating whether its arguments are equal. Note that `=` *only works on
  integers*. It is a runtime error to pass anything besides an integer to `=`.
- Checking if a value is a pair, written `(cons? (+ 1 2))`. `cons?` is a unary
  operator similar to `nil?` that returns true if its argument is a pair. Unlike
  `nil?`, which returns true *only* on `nil`, there are many different values on
  which `cons?` returns true: for example, `(cons 0 1)`, `(cons true (cons false
  nil))`, etc.

## Your tasks

Complete the starter code to implement the Trefoil v2 language as specified in
`LANGUAGE.md`. Write tests that cover the normal and error case behavior for all
language features.

We have left several `TODO`s for you throughout the code. You can use IntelliJ's
TODO tab to keep track of them all easily.

## Suggested workflow

You can do anything in whatever order you want, but here is one suggested path.

Familiarize yourself with the provided files:
- Skim this file without looking at the starter code.
- Read the tour more carefully and poke around at the starter code files so you
  know where too look later.
- Press the "Build" button in IntelliJ and ensure there are no errors.
- Run the tests in `Trefoil2Test.java` and ensure that 24 fail and 8 pass. (!)
  The passing tests are due to features we have implemented for you in the starter code.
- Look at `LANGUAGE.md` to get an idea of the list of expressions and bindings
  you have to add.

Implement new expressions:
- Start with `true`. The AST node is already defined (`BooleanLiteral`), and
  `Expression.parsePST` is done for you in the starter code. All that's left is to
  implement the case in `Interpreter.interpretExpression`.
  - Hint: it is similar to the case for `IntegerLiteral`
  - Ensure that `Trefoil2Test.testBoolLitTrue` passes.
- Now implement with `false`.
  - The AST node is the same as `true`, just with a different `data` field value.
  - This time, you have to implement the case in `Expression.parsePST`.
    - Hint: it is similar to the case for `true`.
    - Ensure that `Trefoil2Test.testBoolLitFalseParsing` passes.
  - Make sure your interpreter handles `false` as well. Depending on how you
    handled `true`, you may not need any code changes.
  - Ensure that `Trefoil2Test.testBoolLitFalse` passes.
- Implement better error handling in `Interpreter.interpretExpression` for `+`.
  - Ensure that `Trefoil2Test.testPlusTypeError` passes.
- Implement `-` and `*`. They are similar to `+`.
  - First, define their AST classes by copying `Plus` and renaming it.
    - Be sure to include the `@Data` and `@Equals...` annotations, and to extend
      `Expression`, or you will get very confusing bugs later.
  - Next, extend `Expression.parsePST` with cases for `-` and `*`.
    - Write tests analogous to `testBoolLitFalseParsing` but for `-` and `*`.
      - You can compare the pared result with a manually constructed AST by
        calling `new Minus(Expression.ofInt(3), Expression.ofInt(17))` or
        whatever.
      - Ensure these tests pass.
  - Finally, extend `Interpreter.interpretExpression` with cases for `-` and `*`.
    - Ensure that `testMinus` and `testTimes` pass.
  - Write error tests for minus and times that check for incorrectly typed arguments,
    and ensure your new tests pass.
    - Be sure you are handling type errors for these operators just like you are for `+`.
      You must throw `Trefoil2.TrefoilError.RuntimeError` and not anything else.
  - Write error tests for minus and times that check what happens when too few or
    too many arguments are given. Ensure they pass.
- Implement `=` following the workflow below.
  - Remember that this operator only works on integers!
    - The interpreter should throw `TrefoilError.RuntimeError` if `=` is given
      anything other than integers.
  - Workflow for all new expression forms
    - Be sure you understand the syntax and semantics as specified in `LANGUAGE.md`.
    - Declare new AST class
    - Write new case in `Expression.parsePST`
    - Write a test for the new case in `parsePST` by comparing it to a manually
      constructed AST, and ensure the test passes.
    - Write new case in `Interpreter.interpretExpression`.
    - Ensure that the provided normal case test for this expression passes (if any).
    - Write (additional) normal case tests to cover all behavior of the feature.
    - Write error case tests for the feature covering the following:
      - wrong type of data passed as argument (should throw `TrefoilError.RuntimeError`)
      - wrong number of arguments passed to primitive operation (should throw `TrefoilError.AbstractSyntaxError`)
- Implement `if` following the workflow.

Implement the new `test` binding:
- Implement the `test` *binding* using this modified workflow.
  - Since `test` is a *binding* not an expression:
    - Declare the new AST class as a public static inner subclass of `Binding`.
    - Extend `Binding.parsePST` instead of the similar method for expressions
    - Extend `Interpreter.interpretBinding` instead of the similar method for
      expressions
  - Ensure the `testTestBinding...` provided tests pass
  - Still write a `parsePST` test
  - Write any additional normal case or error case tests you think are
    appropriate and ensure they pass.

Implement the missing methods about variables in `DynamicEnvironment`:
- Refamiliarize yourself with the starter code for `DynamicEnvironment`
- Fix the first `TODO` in `DynamicEnvironment.getVariable` and ensure
  `testVarNotFound` passes.
- Fix the second `TODO` in `DynamicEnvironment.getVariable` and ensure `testVar`
  passes.
- Implement `DynamicEnvironment.putVariable` and ensure `testPutVariable` and
  `testVarBindingLookup` pass.

Finish implementing the other expressions (*except* function calls):
- Implement `let` following the workflow.
  - Hint: use `extendVariable`, which calls `putVariable` for you on a copy of
    the environment. If you call `putVariable` directly, it is too easy to
    forget to make a copy.
  - Ensure the `testLet...` tests pass.
- Implement `nil`, `cons`, `nil?`, `cons?`, `car`, and `cdr` following the workflow for each.
  - For `nil` and `cons`, fix the TODOs in the factory methods `nil()` and
    `cons()` in `Expression.java`.
  - No provided tests for `nil?` and `cons?`. You should write both normal and
    error case tests for these.

Implement the missing methods about functions in `DynamicEnvironment`:
- Implement `getFunction` and `PutFunction` in `DynamicEnvironment`.
  - Write normal case tests for these and ensure they pass.

Implement functions:
- Implement function *bindings* by following the modified binding workflow.
  - Don't forget to save the defining environment in the `FunctionEntry`
- Implement function *calls* (which are expressions) following the expression workflow.
  - Don't forget to evaluate the function body in an extended version of its
    *defining* environment, *not* the environment of the caller!

Implement your own feature (optional):
- Design and implement a new expression or binding.
  - Spend as much or as little time as you want on this. It's fine if your
    feature is super simple. If you can't think of any ideas, make a post on Ed,
    and we will help brainstorm.
- Write normal and error case tests for your feature
- Describe your work in your answer to the first question in `FEEDBACK.md`

Tidy up and submit:
- Fill out the rest of `FEEDBACK.md`.
- Ensure your code is committed and pushed to Gitlab.
- Submit your code to Gradescope via the Gitlab button.
- Congrats! You finished a "real" interpreter!!

## Working from the command line or using something other than IntelliJ

We have updated the root Makefile with the following targets:
- `make` or `make all` will compile your project
- `make run` will run your Trefoil v2 interpreter interactively
- `make test` will run the Trefoil v2 unit tests

## Grading

330 "syllabus points" available this homework because it covers more material than
originally intended over a longer due date.

We try to give a detailed points breakdown below, but your homework will be
graded manually, and we judge your work holistically as well. In practice this
means you can get some points for doing well overall even if you mess up one part.

- 200 points for AST declaration, parsing, and interpreting all the new features
  - 5 points for `true`
  - 10 points for `false`
  - 10 points for `+` error handling
  - 20 points combined for `-` and `*`
  - 10 points for `=`
  - 10 points for `if`
  - 15 points for the `test` binding
  - 10 points combined for `getVariable` and `putVariable`
  - 20 points for `let`
  - 5 points each for `nil`, `cons`, `nil?`, `cons?`, `car`, and `cdr` (30 total)
  - 10 points combined for `getFunction` and `putFunction`
  - 20 points for function bindings
  - 30 points for function call expressions
- 100 points for (additional) normal case and (additional) error case tests
  - 10 points combined for additional `-` and `*` tests
  - 5 points for `=`
  - 5 points for `if`
  - 10 points for the `test binding`
  - 5 points combined for `getVariable` and `putVariable`
  - 10 points for `let`
  - 2.5 points each for `nil`, `cons`, `car`, and `cdr` (10 points total)
  - 10 points combined for `nil?` and `cons?`
  - 5 points combined for `getFunction` and `putFunction`
  - 15 points for function bindings
  - 15 points for function calls
- Up to 40 points for designing, implementing, and testing your own feature and
  describing it in the first question in `FEEDBACK.md`.
- Up to 20 points for one or more adversarial tests that point out an ambiguity
  in the `LANGUAGE.md` specification or otherwise highlight corner cases of the
  language or are likely to cause the staff solution to crash or leak
  implementation details. Also describe your tests in `FEEDBACK.md`.
- 30 points for filling out the rest of `FEEDBACK.md`.

Because designing, implementing, testing, and describing your own feature and
the adversarial test are (even more) optional (than usual), there are actually 390
points available this week. Only 330 of them are "on the syllabus", meaning we
promise to make at least `2200 - 220 for HW1 - 220 for HW2 - 330 for HW3 = 1430`
points available for the rest of the quarter.
