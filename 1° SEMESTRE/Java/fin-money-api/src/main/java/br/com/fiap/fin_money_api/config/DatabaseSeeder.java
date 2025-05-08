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
 
    @Autowired
    private CategoryRepository categoryRepository;
 
    @Autowired
    private TransactionRepository transactionRepository;
 
    @Autowired
    private UserRepository userRepository;
 
    @Autowired
    private PasswordEncoder passwordEncoder;
 
    @PostConstruct
    public void init() {
        
        //criptografando a senha com o passwordEncoder
        String password = passwordEncoder.encode("12345");
 
        var joao = User.builder().email("joao@fiap.com.br").password(password).build();
        var maria = User.builder().email("maria@fiap.com.br").password(password).build();
        userRepository.saveAll(List.of(joao, maria));
 
        var categories = List.of(
                Category.builder().name("Educação").icon("Book").user(joao).build(),
                Category.builder().name("Lazer").icon("Dices").user(joao).build(),
                Category.builder().name("Transporte").icon("Bus").user(joao).build(),
                Category.builder().name("Moradia").icon("House").user(joao).build(),
                Category.builder().name("Saúde").icon("Heart").user(maria).build());
 
        categoryRepository.saveAll(categories);
 
        var descriptions = List.of("Aluguel", "99 taxi", "Conta de luz", "Supermercado", "Telefone",
                "Internet", "Gasolina", "Seguro do carro", "Empréstimo",
                "Plano de saúde", "Academia", "TV a cabo", "Rastreamento de encomendas",
                "Alimentação fora de casa", "Farmácia", "Cabeleireiro", "Manutenção do carro",
                "Educação (curso, faculdade)", "Viagem", "Presentes");
 
        List<Transaction> transactions = new ArrayList<>();
        for (int i = 0; i < 50; i++) {
            transactions.add(
                Transaction.builder()
                    .description(descriptions.get(new Random().nextInt(descriptions.size())))
                    .amount(BigDecimal.valueOf(new Random().nextDouble() * 500))
                    .date(LocalDate.now().minusDays(new Random().nextInt(30)))
                    .type(TransactionType.EXPENSE)
                    .category(categories.get(new Random().nextInt(categories.size())))
                    .build()
            );
 
        }
 
        transactionRepository.saveAll(transactions);
    }
}
