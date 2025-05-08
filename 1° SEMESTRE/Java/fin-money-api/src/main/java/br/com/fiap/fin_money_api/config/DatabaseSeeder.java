package br.com.fiap.fin_money_api.config;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import br.com.fiap.fin_money_api.model.Category;
import br.com.fiap.fin_money_api.model.Transaction;


import br.com.fiap.fin_money_api.model.TransactionType;
import br.com.fiap.fin_money_api.repository.CategoryRepository;
import br.com.fiap.fin_money_api.repository.TransactionRepository;
import br.com.fiap.fin_money_api.repository.UserRepository;
import jakarta.annotation.PostConstruct;

import br.com.fiap.fin_money_api.model.User;

@Component
public class DatabaseSeeder {
 
    // Injeta automaticamente o repositório de categorias
    @Autowired
    private CategoryRepository categoryRepository;
 
    // Injeta automaticamente o repositório de transações
    @Autowired
    private TransactionRepository transactionRepository;
 
    // Injeta automaticamente o repositório de usuários
    @Autowired
    private UserRepository userRepository;
 
    // Injeta automaticamente o codificador de senhas
    @Autowired
    private PasswordEncoder passwordEncoder;
 
    // Método que será executado automaticamente após a construção do bean
    @PostConstruct
    public void init() {
        
        //criptografando a senha com o passwordEncoder
        String password = passwordEncoder.encode("12345");
 
        // cria 2 usuários com a mesma senha codificada
        var joao = User.builder().email("joao@fiap.com.br").password(password).build();
        var maria = User.builder().email("maria@fiap.com.br").password(password).build();
        
        // salva os usuários no banco de dados
        userRepository.saveAll(List.of(joao, maria));
 
        // cria uma lista de categorias associadas a cada usuário
        var categories = List.of(
                Category.builder().name("Educação").icon("Book").user(joao).build(),
                Category.builder().name("Lazer").icon("Dices").user(joao).build(),
                Category.builder().name("Transporte").icon("Bus").user(joao).build(),
                Category.builder().name("Moradia").icon("House").user(joao).build(),
                Category.builder().name("Saúde").icon("Heart").user(maria).build());
 
        // salva as categorias no banco de dados
        categoryRepository.saveAll(categories);
 

        //lista com descrições para transações aleatórias
        var descriptions = List.of("Aluguel", "99 taxi", "Conta de luz", "Supermercado", "Telefone",
                "Internet", "Gasolina", "Seguro do carro", "Empréstimo",
                "Plano de saúde", "Academia", "TV a cabo", "Rastreamento de encomendas",
                "Alimentação fora de casa", "Farmácia", "Cabeleireiro", "Manutenção do carro",
                "Educação (curso, faculdade)", "Viagem", "Presentes");

        // cria uma lista para armazenar as transações
        var transactions = new ArrayList<Transaction>();
 
        // gera 50 transações aleatórias 
        for (int i = 0; i < 50; i++) {
            transactions.add(Transaction.builder()
                    // seleciona aleatoriamente uma descrição da lista
                    .description(descriptions.get(new Random().nextInt(descriptions.size())))
                    // gera um valor entre 10 e 510 como valor da transação
                    .amount(BigDecimal.valueOf(10 + new Random().nextDouble() * 500))
                    // define uma data nos últimos 30 dias
                    .date(LocalDate.now().minusDays(new Random().nextInt(30)))
                    // define o tipo como despesa
                    .type(TransactionType.EXPENSE)
                    // seleciona aleatoriamente uma categoria craiada anteriormente
                    .category(categories.get(new Random().nextInt(categories.size())))
                    // finaliza a contrução da transação
                    .build());
        }
        
        // salva todas as transações geradas no banco de dados
        transactionRepository.saveAll(transactions);
    }
}
