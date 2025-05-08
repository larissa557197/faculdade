package br.com.fiap.fin_money_api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.fiap.fin_money_api.model.Category;
import br.com.fiap.fin_money_api.model.User;


// interface que representa o repositório de categorias
// estende JpaRepository para fornecer acesso a diversos métodos prontos, como save, findAll, findById, delete, etc.
public interface CategoryRepository extends JpaRepository<Category, Long> {

    // método personalizado para buscar todas as categorias associadas a um usuário específico
    // o Spring Data JPA entende esse nome de método e automaticamente cria a consulta baseada nele
    List<Category> findByUser(User user);
    
    
}
