# HW1: Trefoil v1

In this homework, you will implement an interpreter for version 1 of the *T*h*re*e
*f*orty *o*ne *i*nstructional *l*anguage (Trefoil). The language is not much more than a
pocket calculator at this point, but we will extend it throughout the quarter.

## Informal description

A Trefoil v1 program is a space-separated sequence of integer literals and operators.
Programs are evaluated left to right and in the context of a stack of integers.
When encountering an integer literal in the program, it is pushed on the stack.

The four operators are `+`, `-`, `*`, and `.` (a period). All manipulate items
near the top of the stack. The first three pop two integers off the top of the
stack and combine them according to the operators usual arithmetic meaning; the
result is pushed back onto the stack. For the `-` operator, the order of
operations is to subtract the top of the stack *from* the second item on the
stack. (Read that sentence carefully!!) The `.` operator pops one element from
the top of the stack and prints it.

We recommend you try to take a first cut at implementing this language and its
interpreter based on the description in this file, before returning to the full
description in `LANGUAGE.md`. There are many fiddly details to get right
eventually, but it's more fun to get something mostly working quickly first
before worrying about corner cases.

## A tour of the starter code

We recommend you use IntelliJ for the Java projects. Open the folder `java/` at
the root of this repository (two levels above this file) as a project in
IntelliJ. (We have included a settings directory that should work
automatically.)

There are two starter files: `java/hw/hw1/src/Trefoil.java` and
`java/hw/hw1/tst/TrefoilTest.java`. You should not need to create any other
files for this homework.

We recommend reading both files before starting to make changes.

### `Trefoil.java`

We have a provided a nearly complete `main` method for you that will either read
input from `System.in` or from a file, based on arguments passed on the command
line. These two possibilities both channel into the `interpret(Scanner)` method.
At the bottom of `main` we call `println` on the `Trefoil` instance to print the
stack.

You will implement three public methods on `Trefoil`: `interpret(Scanner)`,
`pop()` and `toString()`.

Unlike the demo code in lecture, you should store the state of the interpreter
(the stack) as a field or fields on the `Trefoil` class. The `interpret` and
`pop` methods will manipulate this stack.

We have placed `TODO`s in this file everywhere we think you will need to change.
That said, you are free to do whatever you want as long as you don't change the
change the public interface to this class, nor change the command-line behavior.
For example, you could add features to the `main` method to implement a `--help`
flag, or whatever else you think would be fun.

### `TrefoilTest.java`

This file contains just a handful of unit tests for the interpreter to get you
started. Even if you are not familiar with JUnit, hopefully the tests should be
relatively self explanatory. All tests start by constructing a `Trefoil` object.
They then send that object some input and make some assertions or expectations
about the resulting behavior. The first four starter tests are "normal case"
tests, i.e., about programs that do not contain errors. The fifth test is an
"error case" test, i.e., about a program that contains an error.

The tests should help you understand how to fill out the `TODO`s in `Trefoil.java`.
There are also two `TODO`s in the test file. You need to add tests that cover features
not covered by the starter tests.

## Suggested workflow

You can do anything in whatever order you want, but here is one suggested path.

- Read both starter files.
- Press the "Build" button in IntelliJ and ensure there are no errors.
- Run the tests in `TrefoilTest.java` and ensure that they all fail.
- Decide how you will represent the interpreter's stack in Java. Fix the first
  two `TODO`s in `Trefoil.java`. Feel free to follow our choice in from Lecture
  1 or do your own thing.
- Implement `Trefoil.pop()`.
- Implement `Trefoil.toString()`. This will help you if you need to debug later.
- Implement integer literals in `Trefoil.interpret(Scanner)`.
  - Ensure `TrefoilTest.interpretOne` passes
  - Ensure `TrefoilTest.toString_` passes
- Implement the `+` operator in `Trefoil.interpret(Scanner)`.
  - Ensure `TrefoilTest.interpretAdd` and `TrefoilTest.interpretAddSplit` pass.
- Implement graceful error handling if the stack is too short for the `+` operator.
  - Ensure `TrefoilTest.stackUnderflow` passes.
- Write normal case tests for `-`, `*`, and `.`.
  - Be careful to get the order of subtraction right in your test! (See lecture 1.)
- Implement `-`, `*`, and `.`.
  - Ensure your normal case tests pass.
- Somewhere around here, take a look at `LANGUAGE.md`.
- Write error case tests for `-`, `*`, and `.` and ensure they pass.
- Write normal case tests for comments.
- Implement comments and ensure your normal case tests pass.
- (No need to write error case tests since comments never signal an error.)
- Write an error case test for a program with a word that is not a token.
- Fix the `TODO` on the `TrefoilError` class by editing `main()` to catch this
  exception, print a nice error message, and exit with status 1.
- Run `Trefoil` from the command line and play around with the interpreter
  interactively.
  - Make sure that your tool really does gracefully handle erroneous inputs.

## Working from the command line or using something other than IntelliJ

We have provided a Makefile with the following targets:
- `make` or `make all` will compile your project
- `make run` will run your interpreter interactively
- `make test` will run the unit tests

## Grading

This homework will be graded relatively leniently. We expect most people who
attempt it will get full credit.

- 75 points for the `Trefoil.interpret(Scanner)` method
- 75 points for normal case and error case tests
- 25 points for `Trefoil.toString()`
- 10 points for `Trefoil.pop()`
- 10 points for error handling in `main()`
- 25 points for filling out `FEEDBACK.md`

## Submitting your work

Commit and push your work to Gitlab. We will open the Gradescope for this
assignment and give further instructions soon. You will be able to submit on
Gradescope through Gitlab.
