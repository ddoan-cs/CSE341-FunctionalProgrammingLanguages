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

    @Test
    public void interpretComments() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 2 3 ;asdfasdfsadf");
        assertEquals(trefoil.toString(), "1 2 3");
    }

    @Test
    public void interpretSub() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 3 -");
        assertEquals(trefoil.toString(), "-2");
    }

    @Test
    public void interpretMul() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("2 3 *");
        assertEquals(trefoil.toString(), "6");
    }

    @Test
    public void interpretEmpty() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("");
        assertEquals(trefoil.toString(), "");
    }

    @Test
    public void interpretPrint() {
        //Just makes sure value is popped off, sys.out is fine from what is shown
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("2 .");
        assertEquals(trefoil.toString(), "");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void stackUnderflow() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 +");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void interpretReverseOperation() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret(". 1");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void interpretUnknownToken() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("/ 1");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void interpretLessThanTwoElementsAdd() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 +");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void interpretLessThanTwoElementsSub() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 -");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void interpretLessThanTwoElementsMul() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret("1 *");
    }

    @Test(expected = Trefoil.TrefoilError.class)
    public void interpretPrintLessThanOneValue() {
        Trefoil trefoil = new Trefoil();
        trefoil.interpret(".");
        assertEquals(trefoil.toString(), "");
    }
}