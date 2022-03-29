import org.junit.Test;

import static junit.framework.TestCase.*;

public class TrefoilTest {
    @Test
    public void interpretOne() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1");
        assertEquals(1, trefoil.pop());
    }

    @Test
    public void interpretAdd() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 2 +");
        assertEquals(3, trefoil.pop());
    }

    @Test
    public void interpretAddSplit() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 2");
        // the interpreter should track the stack across multiple calls to interpret()
        trefoil.interpret("+");
        assertEquals(3, trefoil.pop());
    }

    @Test
    public void toString_() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 2 3");
        assertEquals("1 2 3", trefoil.toString());
    }

    // TODO: add unit tests here to cover all features in the language (don't forget to test comments!)



    @Test(expected = Trefoil.TrefoilError.class)
    public void stackUnderflow() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 +");
    }

    // TODO: add unit tests for malformed programs that the user might accidentally input
    //       you can use the @Test(expected = Trefoil.TrefoilError.class) notation above
    //       to write a test that fails if the exception is *not* thrown. Add at least
    //       one test for each operator that can signal an error, plus at least one test
    //       containing malformed input (a word that is not a token).
}