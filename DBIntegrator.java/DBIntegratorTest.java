package com.seuprojeto.integraçao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class DBIntegratorTest {

    @Test
    public void testEnvioParaDB() {
        DBIntegrator integrador = new DBIntegrator();
        boolean resultado = integrador.enviarParaDB();
        assertTrue(resultado, "Os dados deveriam ter sido salvos no DB");
    }
}
