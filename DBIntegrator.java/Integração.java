package com.seuprojeto.integracao;

import com.seuprojeto.db.DBService;
import com.seuprojeto.back.BackService;

public class DBIntegrator {

    private DBService db;
    private BackService back;

    public DBIntegrator() {
        this.db = new DBService();
        this.back = new BackService(); // pega os dados já processados do back
    }

    public boolean enviarParaDB() {
        // Pega os dados diretamente do back
        String dadosProcessados = back.getDadosProcessados();

        // Envia para o DB
        boolean sucesso = db.salvar(dadosProcessados);

        if(sucesso) {
            System.out.println("[INTEGRACAO] Dados enviados com sucesso para o DB.");
        } else {
            System.out.println("[INTEGRACAO] Falha ao enviar dados para o DB.");
        }

        return sucesso;
    }

    public static void main(String[] args) {
        DBIntegrator integrador = new DBIntegrator();
        integrador.enviarParaDB();
    }
}
