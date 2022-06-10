# HW5 Questions and feedback

## Questions

What difference did you discover between your Java implementation and your OCaml
implementation? Include an example Trefoil program that illustrates the difference.

One difference is when integer overflow occurs in the Java implementation compared to the 
OCaml implementation. 

(+ 1 2147483646)) 

The largest int value in Java is 2147483647 while the largest int value in OCaml is 1073721823.
As such, the expression above would cause an integer overflow in OCaml while it would work as 
intended in Java. 

`LANGUAGE.md` contained a detailed explanation of structural equality to give
semantics to Trefoil's `=` operator. Explain why your implementation of `=` is
correct even though you didn't have to explicitly write a recursive "structural
equality checker" on values.

The implementation of  '=' is correct because of the way the '=' operator works in
OCaml. The OCaml '=' operator recursively traverses the elements of its operands
and compares them to eachother, and since the elements of all our operands are 
guaranteed to be values, the '=' will only say they are equivalent when structurally 
equal. 

(Optional) What new expression, binding or pattern did you add? Describe its syntax and semantics.

Describe the substantial program you wrote in Trefoil. What file did you put it in?

The substrantial program I wrote was determining whether two dates matched and if they did return 
true else return false. I used struct dates and compared each of the elements to determine whether 
they were the same date or not. I put the file in the my-program.trefoil file. 

## Feedback

Approximately how many hours did you spend on this homework?

10 hours 

Any feedback about the lecture material corresponding to this homework?

The lecture contained all the material we needed for this homework.

Any feedback about the homework itself?

This homework was one of the harder ones for me compared to all the others. 

Anything else you want us to know?

Nope!