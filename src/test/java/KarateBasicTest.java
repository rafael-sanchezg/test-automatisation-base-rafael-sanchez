import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:karate-test.feature").tags("@REQ_HU-PRUEBA-TECNICA");
    }

    @Karate.Test
    Karate testGets() {
        return Karate.run("classpath:karate-test.feature").tags("@get");
    }

    @Karate.Test
    Karate testCreates() {
        return Karate.run("classpath:karate-test.feature").tags("@post");
    }

    @Karate.Test
    Karate testUpdates() {
        return Karate.run("classpath:karate-test.feature").tags("@put");
    }

    @Karate.Test
    Karate testDeletes() {
        return Karate.run("classpath:karate-test.feature").tags("@delete");
    }

    @Karate.Test
    Karate testErrors() {
        return Karate.run("classpath:karate-test.feature").tags("@error");
    }

}
