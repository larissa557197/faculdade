package br.com.fiap.fin_money_api.repository;


import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import br.com.fiap.fin_money_api.model.User;


// define a interface UserRepository que estende JpaRepository para fornecer acesso a métodos prontos para manipulação de dados de usuários
// JpaRepository é uma interface do Spring Data JPA que fornece métodos para operações CRUD e consultas em entidades
public interface UserRepository extends JpaRepository<User, Long> {

    
    // declara um método para buscar um usuário pelo e-mail
    // o Spring Data JPA implementa esse método automaticamente com base no nome
    Optional<User> findByEmail(String email);

}
